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

            if (!IsPostBack)
            {
                LoadProfile();
                LoadAvailability();
                LoadStats();
                LoadBookings();
                LoadReviews();
            }
        }

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

        private void LoadProfile()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    string query = @"
                        SELECT u.FirstName + ' ' + u.LastName   AS FullName,
                               ISNULL(u.ContactNo, '')          AS ContactNo,
                               ISNULL(u.Address, '')            AS Address,
                               ISNULL(cp.HourlyRate, 0)         AS HourlyRate,
                               ISNULL(cp.Bio, '')               AS Bio
                        FROM Users u
                        LEFT JOIN CaregiverProfiles cp ON u.UserID = cp.UserID
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
                                decimal rate = 0;
                                decimal.TryParse(r["HourlyRate"].ToString(), out rate);
                                txtProfileRate.Text = rate > 0 ? rate.ToString("0.##") : "";
                                txtProfileBio.Text = r["Bio"].ToString();
                            }
                        }
                    }

                    int cgID = GetCaregiverID();
                    var checkedServiceIDs = new System.Collections.Generic.HashSet<int>();

                    if (cgID > 0)
                    {
                        using (SqlCommand cmd = new SqlCommand(
                            "SELECT ServiceID FROM CaregiverServices WHERE CaregiverID = @CgID", conn))
                        {
                            cmd.Parameters.AddWithValue("@CgID", cgID);
                            using (SqlDataReader r = cmd.ExecuteReader())
                                while (r.Read())
                                    checkedServiceIDs.Add(Convert.ToInt32(r["ServiceID"]));
                        }
                    }

                    chkChildCare.Checked = checkedServiceIDs.Contains(1);
                    chkElderlyCare.Checked = checkedServiceIDs.Contains(2);
                    chkSpecialNeeds.Checked = checkedServiceIDs.Contains(3);
                    chkPetCare.Checked = checkedServiceIDs.Contains(4);
                    chkHouseSitting.Checked = checkedServiceIDs.Contains(5);

                    hdnSelectedServices.Value = string.Join(",", checkedServiceIDs.Select(id => id.ToString()));
                }
            }
            catch (Exception ex)
            {

                lblProfileMsg.Text = "Profile load error: " + ex.Message;
            }
        }

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

                    DataTable recent = dt.Rows.Count > 5 ? dt.AsEnumerable().Take(5).CopyToDataTable() : dt;
                    rptRecentBookings.DataSource = recent;
                    rptRecentBookings.DataBind();
                    pnlNoBookings.Visible = (recent.Rows.Count == 0);

                    rptAllBookings.DataSource = dt;
                    rptAllBookings.DataBind();
                    pnlNoAllBookings.Visible = (dt.Rows.Count == 0);
                }
            }
        }

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
                                    this, GetType(), "setDays",
                                    $"document.getElementById('hdnAvailableDays').value='{days}';loadSavedDays('{days}');", true);
                            }
                        }
                    }
                }
            }
        }

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

                var selectedServiceIDs = new List<int>();
                if (chkChildCare.Checked) selectedServiceIDs.Add(1);
                if (chkElderlyCare.Checked) selectedServiceIDs.Add(2);
                if (chkSpecialNeeds.Checked) selectedServiceIDs.Add(3);
                if (chkPetCare.Checked) selectedServiceIDs.Add(4);
                if (chkHouseSitting.Checked) selectedServiceIDs.Add(5);

                string[] parts = fullName.Split(new char[] { ' ' }, 2);
                string firstName = parts[0];
                string lastName = parts.Length > 1 ? parts[1] : "";

                int cgID = GetCaregiverID();

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(
                        "IF COL_LENGTH('CaregiverProfiles','Bio') IS NULL ALTER TABLE CaregiverProfiles ADD Bio VARCHAR(150);", conn))
                        cmd.ExecuteNonQuery();

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

                    using (SqlCommand cmd = new SqlCommand(@"
                        UPDATE CaregiverProfiles SET
                            HourlyRate = @Rate,
                            Bio        = @Bio
                        WHERE UserID = @UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Rate", rate);
                        cmd.Parameters.AddWithValue("@Bio", bio);
                        cmd.Parameters.AddWithValue("@UID", UserID);
                        int rows = cmd.ExecuteNonQuery();

                        if (rows == 0)
                        {
                            int newCgID = 1;
                            using (SqlCommand maxCmd = new SqlCommand(
                                "SELECT ISNULL(MAX(CaregiverID),0)+1 FROM CaregiverProfiles", conn))
                                newCgID = (int)maxCmd.ExecuteScalar();

                            using (SqlCommand insCmd = new SqlCommand(@"
                                INSERT INTO CaregiverProfiles
                                    (CaregiverID, UserID, HourlyRate, Bio, AvailabilityStatus)
                                VALUES (@CgID, @UID, @Rate, @Bio, 'Available')", conn))
                            {
                                insCmd.Parameters.AddWithValue("@CgID", newCgID);
                                insCmd.Parameters.AddWithValue("@UID", UserID);
                                insCmd.Parameters.AddWithValue("@Rate", rate);
                                insCmd.Parameters.AddWithValue("@Bio", bio);
                                insCmd.ExecuteNonQuery();
                            }
                            cgID = newCgID;
                        }
                    }

                    using (SqlCommand cmd = new SqlCommand(
                        "DELETE FROM CaregiverServices WHERE CaregiverID = @CgID", conn))
                    {
                        cmd.Parameters.AddWithValue("@CgID", cgID);
                        cmd.ExecuteNonQuery();
                    }

                    foreach (int svcID in selectedServiceIDs)
                    {
                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO CaregiverServices (CaregiverID, ServiceID)
                            VALUES (@CgID, @SvcID)", conn))
                        {
                            cmd.Parameters.AddWithValue("@CgID", cgID);
                            cmd.Parameters.AddWithValue("@SvcID", svcID);
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

                    using (SqlCommand cmd = new SqlCommand(
                        "IF COL_LENGTH('CaregiverProfiles','DayStartTime') IS NULL ALTER TABLE CaregiverProfiles ADD DayStartTime VARCHAR(10);", conn))
                        cmd.ExecuteNonQuery();

                    using (SqlCommand cmd = new SqlCommand(
                        "IF COL_LENGTH('CaregiverProfiles','DayEndTime') IS NULL ALTER TABLE CaregiverProfiles ADD DayEndTime VARCHAR(10);", conn))
                        cmd.ExecuteNonQuery();

                    int existingCgID = 0;
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT ISNULL(CaregiverID,0) FROM CaregiverProfiles WHERE UserID=@UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UID", UserID);
                        object res = cmd.ExecuteScalar();
                        if (res != null) existingCgID = Convert.ToInt32(res);
                    }

                    if (existingCgID == 0)
                    {

                        int newCgID = 1;
                        using (SqlCommand cmd = new SqlCommand(
                            "SELECT ISNULL(MAX(CaregiverID),0)+1 FROM CaregiverProfiles", conn))
                            newCgID = (int)cmd.ExecuteScalar();

                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO CaregiverProfiles
                                (CaregiverID, UserID, HourlyRate, AvailabilityStatus,
                                 AvailableDays, DayStartTime, DayEndTime, Bio)
                            VALUES (@CgID, @UID, 0,
                                CASE WHEN @Days<>'' THEN 'Available' ELSE 'Unavailable' END,
                                @Days, @DayStart, @DayEnd, '')", conn))
                        {
                            cmd.Parameters.AddWithValue("@CgID", newCgID);
                            cmd.Parameters.AddWithValue("@UID", UserID);
                            cmd.Parameters.AddWithValue("@Days", availDays);
                            cmd.Parameters.AddWithValue("@DayStart", dayStart);
                            cmd.Parameters.AddWithValue("@DayEnd", dayEnd);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {

                        using (SqlCommand cmd = new SqlCommand(@"
                            UPDATE CaregiverProfiles SET
                                AvailableDays      = @Days,
                                DayStartTime       = @DayStart,
                                DayEndTime         = @DayEnd,
                                AvailabilityStatus = CASE WHEN @Days<>'' THEN 'Available' ELSE 'Unavailable' END
                            WHERE UserID = @UID", conn))
                        {
                            cmd.Parameters.AddWithValue("@Days", availDays);
                            cmd.Parameters.AddWithValue("@DayStart", dayStart);
                            cmd.Parameters.AddWithValue("@DayEnd", dayEnd);
                            cmd.Parameters.AddWithValue("@UID", UserID);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                hdnActivePanel.Value = "availability";
                lblProfileMsg.Text = "";
                lblAvailMsg.Text = "✓ Availability saved!";

                LoadAvailability();
            }
            catch (Exception ex)
            {
                lblAvailMsg.Text = "Error: " + ex.Message;
                lblProfileMsg.Text = "";
            }
        }

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

                lblProfileMsg.Text = "";
                lblAvailMsg.Text = "";
                lblBookingMsg.Text = toastMsg;
                hdnActivePanel.Value = "bookings";
                LoadBookings();
                LoadStats();
                LoadProfile();
                LoadAvailability();
            }
            catch (Exception ex)
            {
                lblBookingMsg.Text = "Error: " + ex.Message;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}