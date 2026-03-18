using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace SteVince__and_Friends_MP_FINALPROJECT
{
    public partial class Caregiver_Dashboard : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SwiftCareDB"].ConnectionString;
        private int UserID => Convert.ToInt32(Session["UserID"]);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Caregiver")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string name = Session["UserName"]?.ToString() ?? "Caregiver";
            lblSidebarName.Text = name;
            lblGreetName.Text = name.Split(' ')[0];
            lblProfileName.Text = name;

            // Always reload profile and availability so checks/days are never lost
            LoadProfile();
            LoadAvailability();

            if (!IsPostBack)
            {
                LoadStats();
                LoadBookings();
                LoadReviews();
            }
        }

        // ── Get CaregiverID ──
        private int GetCaregiverID()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT CaregiverID FROM CaregiverProfiles WHERE UserID = @UID", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", UserID);
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        // ── LOAD PROFILE — fills phone, city, rate, bio, services ──
        private void LoadProfile()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Load basic profile fields (no longer reads ServicesOffered string)
                string query = @"
                    SELECT u.FirstName + ' ' + u.LastName AS FullName,
                           u.ContactNo,
                           u.Address,
                           cp.HourlyRate,
                           cp.Bio
                    FROM Users u
                    INNER JOIN CaregiverProfiles cp ON u.UserID = cp.UserID
                    WHERE u.UserID = @UID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UID", UserID);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            txtProfileName.Text = r["FullName"].ToString();
                            txtProfilePhone.Text = r["ContactNo"].ToString();
                            txtProfileCity.Text = r["Address"].ToString();
                            txtProfileRate.Text = r["HourlyRate"].ToString();
                            txtProfileBio.Text = r["Bio"].ToString();
                        }
                    }
                }

                // Load services from the junction table CaregiverServices
                int cgID = GetCaregiverID();
                var checkedServices = new System.Collections.Generic.HashSet<string>();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT s.ServiceName
                    FROM CaregiverServices cs
                    INNER JOIN Services s ON cs.ServiceID = s.ServiceID
                    WHERE cs.CaregiverID = @CgID", conn))
                {
                    cmd.Parameters.AddWithValue("@CgID", cgID);
                    using (SqlDataReader r = cmd.ExecuteReader())
                        while (r.Read())
                            checkedServices.Add(r["ServiceName"].ToString());
                }

                chkChildCare.Checked = checkedServices.Contains("Child Care");
                chkElderlyCare.Checked = checkedServices.Contains("Elderly Care");
                chkPetCare.Checked = checkedServices.Contains("Pet Care");
                chkHouseSitting.Checked = checkedServices.Contains("House Sitting");
                chkSpecialNeeds.Checked = checkedServices.Contains("Special Needs Care");

                string script = "setTimeout(function(){";
                if (chkChildCare.Checked) script += "var e=document.getElementById('svc-childcare');if(e)e.classList.add('checked');";
                if (chkElderlyCare.Checked) script += "var e=document.getElementById('svc-elderly');if(e)e.classList.add('checked');";
                if (chkPetCare.Checked) script += "var e=document.getElementById('svc-pet');if(e)e.classList.add('checked');";
                if (chkHouseSitting.Checked) script += "var e=document.getElementById('svc-house');if(e)e.classList.add('checked');";
                if (chkSpecialNeeds.Checked) script += "var e=document.getElementById('svc-special');if(e)e.classList.add('checked');";
                script += "},100);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "loadSvcs", script, true);
            }
        }

        // ── LOAD STATS ──
        private void LoadStats()
        {
            int cgID = GetCaregiverID();
            if (cgID == 0) { lblTotalBookings.Text = lblPendingBookings.Text = lblCompletedBookings.Text = "0"; lblAvgRating.Text = "—"; return; }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings WHERE CaregiverID=@CID", conn))
                { cmd.Parameters.AddWithValue("@CID", cgID); lblTotalBookings.Text = cmd.ExecuteScalar().ToString(); }

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings WHERE CaregiverID=@CID AND Status='Pending'", conn))
                { cmd.Parameters.AddWithValue("@CID", cgID); lblPendingBookings.Text = cmd.ExecuteScalar().ToString(); }

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings WHERE CaregiverID=@CID AND Status='Completed'", conn))
                { cmd.Parameters.AddWithValue("@CID", cgID); lblCompletedBookings.Text = cmd.ExecuteScalar().ToString(); }

                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(AVG(CAST(Rating AS FLOAT)),0) FROM Reviews WHERE CaregiverID=@CID", conn))
                {
                    cmd.Parameters.AddWithValue("@CID", cgID);
                    object avg = cmd.ExecuteScalar();
                    double val = avg != null && avg != DBNull.Value ? Convert.ToDouble(avg) : 0;
                    lblAvgRating.Text = val > 0 ? val.ToString("0.0") : "—";
                }
            }
        }

        // ── LOAD BOOKINGS ──
        private void LoadBookings()
        {
            int cgID = GetCaregiverID();
            if (cgID == 0)
            {
                rptRecentBookings.DataSource = new List<object>();
                rptRecentBookings.DataBind();
                rptAllBookings.DataSource = new List<object>();
                rptAllBookings.DataBind();
                pnlNoBookings.Visible = true;
                pnlNoAllBookings.Visible = true;
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT b.BookingID,
                           u.FirstName + ' ' + u.LastName               AS ClientName,
                           u.Address                                    AS Location,
                           s.ServiceName                                AS Service,
                           CONVERT(VARCHAR,b.BookingDate,107) + ' · ' +
                           CONVERT(VARCHAR,b.StartTime,108)             AS BookingDate,
                           cp.HourlyRate                                AS Rate,
                           CAST(
                               DATEDIFF(MINUTE, b.StartTime, b.EndTime) / 60.0
                               * cp.HourlyRate
                           AS DECIMAL(10,2))                            AS EstTotal,
                           b.Status,
                           LOWER(b.Status)                              AS StatusClass
                    FROM Bookings b
                    INNER JOIN Users u    ON b.UserID    = u.UserID
                    INNER JOIN Services s ON b.ServiceID = s.ServiceID
                    INNER JOIN CaregiverProfiles cp ON b.CaregiverID = cp.CaregiverID
                    WHERE b.CaregiverID = @CID
                    ORDER BY b.BookingDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CID", cgID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Recent (top 5 for overview)
                    DataTable recent = dt.Rows.Count > 5 ? dt.AsEnumerable().Take(5).CopyToDataTable() : dt;
                    rptRecentBookings.DataSource = recent;
                    rptRecentBookings.DataBind();
                    pnlNoBookings.Visible = (recent.Rows.Count == 0);

                    // All bookings
                    rptAllBookings.DataSource = dt;
                    rptAllBookings.DataBind();
                    pnlNoAllBookings.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        // ── LOAD REVIEWS ──
        private void LoadReviews()
        {
            int cgID = GetCaregiverID();
            if (cgID == 0)
            {
                rptReviews.DataSource = new List<object>();
                rptReviews.DataBind();
                pnlNoReviews.Visible = true;
                lblRatingNum.Text = "—";
                lblReviewCount.Text = "0 reviews";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT u.FirstName + ' ' + u.LastName  AS ClientName,
                           r.Rating,
                           r.Comment                       AS ReviewText,
                           s.ServiceName                   AS Service,
                           'Recent'                        AS ReviewDate
                    FROM Reviews r
                    INNER JOIN Users u    ON r.UserID     = u.UserID
                    INNER JOIN Bookings b ON r.BookingID  = b.BookingID
                    INNER JOIN Services s ON b.ServiceID  = s.ServiceID
                    WHERE r.CaregiverID = @CID
                    ORDER BY r.ReviewID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CID", cgID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Add Stars column
                    dt.Columns.Add("Stars", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        int rating = 0;
                        int.TryParse(row["Rating"].ToString(), out rating);
                        row["Stars"] = new string('★', rating) + new string('☆', 5 - rating);
                    }

                    rptReviews.DataSource = dt;
                    rptReviews.DataBind();
                    pnlNoReviews.Visible = (dt.Rows.Count == 0);

                    if (dt.Rows.Count > 0)
                    {
                        double avg = dt.AsEnumerable().Average(r => Convert.ToDouble(r["Rating"]));
                        lblRatingNum.Text = avg.ToString("0.0");
                        lblAvgRating.Text = avg.ToString("0.0");
                        lblReviewCount.Text = dt.Rows.Count + " review" + (dt.Rows.Count > 1 ? "s" : "");
                    }
                    else
                    {
                        lblRatingNum.Text = "—";
                        lblAvgRating.Text = "—";
                        lblReviewCount.Text = "0 reviews";
                    }
                }
            }
        }

        // ── LOAD AVAILABILITY ──
        private void LoadAvailability()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT ISNULL(AvailableDays,'') AS AvailableDays,
                        CASE WHEN COL_LENGTH('CaregiverProfiles','DayStartTime') IS NOT NULL
                             THEN ISNULL(DayStartTime,'08:00') ELSE '08:00' END AS DayStartTime,
                        CASE WHEN COL_LENGTH('CaregiverProfiles','DayEndTime') IS NOT NULL
                             THEN ISNULL(DayEndTime,'17:00') ELSE '17:00' END AS DayEndTime
                    FROM CaregiverProfiles WHERE UserID = @UID", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", UserID);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            txtDayStart.Text = r["DayStartTime"].ToString();
                            txtDayEnd.Text = r["DayEndTime"].ToString();

                            string days = r["AvailableDays"].ToString();
                            if (!string.IsNullOrEmpty(days))
                            {
                                System.Web.UI.ScriptManager.RegisterStartupScript(
                                    this, GetType(), "loadDays",
                                    $"window.addEventListener('DOMContentLoaded',function(){{loadSavedDays('{days}');}});", true);
                            }
                        }
                    }
                }
            }
        }

        // ── SAVE PROFILE — writes to Users, CaregiverProfiles, and CaregiverServices ──
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            try
            {
                string fullName = txtProfileName.Text.Trim();
                string phone = txtProfilePhone.Text.Trim();
                string city = txtProfileCity.Text.Trim();
                string bio = txtProfileBio.Text.Trim();
                decimal rate = 0;
                decimal.TryParse(txtProfileRate.Text.Trim(), out rate);

                // Collect checked service names
                var selectedServices = new List<string>();
                if (chkChildCare.Checked) selectedServices.Add("Child Care");
                if (chkElderlyCare.Checked) selectedServices.Add("Elderly Care");
                if (chkPetCare.Checked) selectedServices.Add("Pet Care");
                if (chkHouseSitting.Checked) selectedServices.Add("House Sitting");
                if (chkSpecialNeeds.Checked) selectedServices.Add("Special Needs Care");

                // Split full name
                string[] parts = fullName.Split(new char[] { ' ' }, 2);
                string firstName = parts[0];
                string lastName = parts.Length > 1 ? parts[1] : "";

                int cgID = GetCaregiverID();

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // 1. Update Users table
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE Users SET FirstName=@FN, LastName=@LN, ContactNo=@CN, Address=@Ad WHERE UserID=@UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@FN", firstName);
                        cmd.Parameters.AddWithValue("@LN", lastName);
                        cmd.Parameters.AddWithValue("@CN", phone);
                        cmd.Parameters.AddWithValue("@Ad", city);
                        cmd.Parameters.AddWithValue("@UID", UserID);
                        cmd.ExecuteNonQuery();
                    }

                    // 2. Update CaregiverProfiles (HourlyRate and Bio only)
                    using (SqlCommand cmd = new SqlCommand(@"
                        UPDATE CaregiverProfiles SET
                            HourlyRate = @Rate,
                            Bio        = @Bio
                        WHERE UserID = @UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Rate", rate);
                        cmd.Parameters.AddWithValue("@Bio", bio);
                        cmd.Parameters.AddWithValue("@UID", UserID);
                        cmd.ExecuteNonQuery();
                    }

                    // 3. Sync CaregiverServices: delete existing rows then re-insert checked ones
                    using (SqlCommand cmd = new SqlCommand(
                        "DELETE FROM CaregiverServices WHERE CaregiverID = @CgID", conn))
                    {
                        cmd.Parameters.AddWithValue("@CgID", cgID);
                        cmd.ExecuteNonQuery();
                    }

                    foreach (string svcName in selectedServices)
                    {
                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO CaregiverServices (CaregiverID, ServiceID)
                            SELECT @CgID, ServiceID FROM Services WHERE ServiceName = @SvcName", conn))
                        {
                            cmd.Parameters.AddWithValue("@CgID", cgID);
                            cmd.Parameters.AddWithValue("@SvcName", svcName);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                Session["UserName"] = fullName;
                lblSidebarName.Text = fullName;
                lblGreetName.Text = firstName;
                lblProfileName.Text = fullName;
                hdnActivePanel.Value = "profile";
                lblAvailMsg.Text = "";
                lblProfileMsg.Text = "✓ Profile saved successfully!";

                LoadProfile();
            }
            catch (Exception ex)
            {
                lblProfileMsg.Text = "Error: " + ex.Message;
            }
        }


        // ── SAVE AVAILABILITY ──
        protected void btnSaveAvailability_Click(object sender, EventArgs e)
        {
            try
            {
                string availDays = Request.Form["hdnAvailableDays"] ?? "";
                string dayStart = txtDayStart.Text.Trim();
                string dayEnd = txtDayEnd.Text.Trim();

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Add columns if they don't exist yet
                    using (SqlCommand cmd = new SqlCommand(@"
                        IF COL_LENGTH('CaregiverProfiles','DayStartTime') IS NULL
                            ALTER TABLE CaregiverProfiles ADD DayStartTime VARCHAR(10);
                        IF COL_LENGTH('CaregiverProfiles','DayEndTime') IS NULL
                            ALTER TABLE CaregiverProfiles ADD DayEndTime VARCHAR(10);", conn))
                    {
                        cmd.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd = new SqlCommand(@"
                        UPDATE CaregiverProfiles SET
                            AvailableDays      = @Days,
                            DayStartTime       = @DayStart,
                            DayEndTime         = @DayEnd,
                            AvailabilityStatus = CASE WHEN @Days <> '' THEN 'Available' ELSE 'Unavailable' END
                        WHERE UserID = @UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Days", availDays);
                        cmd.Parameters.AddWithValue("@DayStart", dayStart);
                        cmd.Parameters.AddWithValue("@DayEnd", dayEnd);
                        cmd.Parameters.AddWithValue("@UID", UserID);
                        cmd.ExecuteNonQuery();
                    }
                }
                hdnActivePanel.Value = "availability";
                lblProfileMsg.Text = ""; // clear profile msg so it doesn't bleed
                lblAvailMsg.Text = "✓ Availability saved!";
            }
            catch (Exception ex)
            {
                lblProfileMsg.Text = "Error: " + ex.Message;
            }
        }

        // ── BOOKING ACCEPT / DECLINE / COMPLETE ──
        protected void BookingAction_Command(object sender, CommandEventArgs e)
        {
            try
            {
                int bookingID = Convert.ToInt32(e.CommandArgument);

                string newStatus;
                string toastMsg;
                switch (e.CommandName)
                {
                    case "Accept":
                        newStatus = "Confirmed";
                        toastMsg = "✓ Booking accepted!";
                        break;
                    case "Decline":
                        newStatus = "Cancelled";
                        toastMsg = "Booking declined.";
                        break;
                    case "Complete":
                        newStatus = "Completed";
                        toastMsg = "✔ Booking marked as completed!";
                        break;
                    default:
                        return;
                }

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE Bookings SET Status=@Status WHERE BookingID=@BID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@BID", bookingID);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblProfileMsg.Text = toastMsg;
                LoadBookings();
                LoadStats();
            }
            catch (Exception ex)
            {
                lblProfileMsg.Text = "Error: " + ex.Message;
            }
        }

        // ── LOGOUT ──
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}