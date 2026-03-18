using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace SteVince__and_Friends_MP_FINALPROJECT
{
    public partial class User_Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["UserRole"]?.ToString() != "User")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string name = Session["UserName"]?.ToString();
            lblSidebarName.Text = name;
            lblGreetName.Text = name;
            lblProfileName.Text = name;

            LoadServiceFilter();
            LoadCaregivers();
            LoadBookings();

            if (!IsPostBack)
                LoadProfile();
        }

        private string ConnStr => ConfigurationManager.ConnectionStrings["SwiftCareDB"].ConnectionString;
        private int UserID => Convert.ToInt32(Session["UserID"]);

        // ── SERVICE FILTER DROPDOWN ──
        private void LoadServiceFilter()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string prev = ddlService.SelectedValue;
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ServiceName FROM Services ORDER BY ServiceName", conn))
                {
                    ddlService.Items.Clear();
                    ddlService.Items.Add(new ListItem("All Services", ""));
                    using (SqlDataReader r = cmd.ExecuteReader())
                        while (r.Read())
                            ddlService.Items.Add(new ListItem(
                                r["ServiceName"].ToString(), r["ServiceName"].ToString()));
                }
                var sel = ddlService.Items.FindByValue(prev);
                if (sel != null) sel.Selected = true;
            }
        }

        // ── LOAD CAREGIVERS ──
        private void LoadCaregivers(string searchName = "", string searchService = "")
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT
                        cp.CaregiverID,
                        ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS FullName,
                        ISNULL(u.Address,   'N/A')                             AS Address,
                        ISNULL(u.ContactNo, 'N/A')                             AS ContactNo,
                        ISNULL(cp.HourlyRate, 0)                               AS HourlyRate,
                        ISNULL(cp.AvailabilityStatus, 'N/A')                   AS AvailabilityStatus,
                        ISNULL(cp.AvailableDays, '')                           AS AvailableDays,
                        ISNULL(cp.Bio, '')                                     AS Bio,
                        CASE WHEN LEN(ISNULL(cp.Bio,'')) > 60
                             THEN LEFT(cp.Bio, 60) + '...'
                             ELSE ISNULL(cp.Bio, 'No bio yet') END             AS ShortBio,
                        ISNULL(
                            (SELECT STRING_AGG(s.ServiceName, ', ')
                             FROM CaregiverServices cs
                             INNER JOIN Services s ON cs.ServiceID = s.ServiceID
                             WHERE cs.CaregiverID = cp.CaregiverID),
                        'N/A')                                                  AS ServicesOffered
                    FROM CaregiverProfiles cp
                    LEFT JOIN Users u ON cp.UserID = u.UserID
                    WHERE (@Name = '' OR ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') LIKE '%' + @Name + '%')
                      AND (@Svc  = '' OR EXISTS (
                            SELECT 1
                            FROM CaregiverServices cs2
                            INNER JOIN Services s2 ON cs2.ServiceID = s2.ServiceID
                            WHERE cs2.CaregiverID = cp.CaregiverID
                              AND s2.ServiceName = @Svc))";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", searchName);
                    cmd.Parameters.AddWithValue("@Svc", searchService);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCaregivers.DataSource = dt;
                    rptCaregivers.DataBind();
                    pnlNoCaregivers.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        // ── LOAD ALL BOOKINGS ──
        private void LoadBookings()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT
                        b.BookingID,
                        b.CaregiverID,
                        u.FirstName + ' ' + u.LastName              AS CaregiverName,
                        s.ServiceName,
                        CONVERT(VARCHAR, b.BookingDate, 107)        AS BookingDate,
                        CONVERT(VARCHAR, b.StartTime,   108)        AS StartTime,
                        CONVERT(VARCHAR, b.EndTime,     108)        AS EndTime,
                        b.Status,
                        LOWER(b.Status)                             AS StatusClass,
                        CASE WHEN EXISTS (
                            SELECT 1 FROM Reviews r
                            WHERE r.BookingID = b.BookingID AND r.UserID = @UID
                        ) THEN 1 ELSE 0 END                         AS HasReview
                    FROM Bookings b
                    INNER JOIN CaregiverProfiles cp ON b.CaregiverID = cp.CaregiverID
                    INNER JOIN Users u  ON cp.UserID = u.UserID
                    INNER JOIN Services s ON b.ServiceID = s.ServiceID
                    WHERE b.UserID = @UID
                    ORDER BY b.BookingDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UID", UserID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptBookings.DataSource = dt;
                    rptBookings.DataBind();
                    pnlNoBookings.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        // ── LOAD PROFILE ──
        private void LoadProfile()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT FirstName, LastName, Email, ContactNo, Gender, Birthdate, Address FROM Users WHERE UserID = @UID", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", UserID);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            txtProfileFirstName.Text = r["FirstName"].ToString();
                            txtProfileLastName.Text = r["LastName"].ToString();
                            txtProfileEmail.Text = r["Email"].ToString();
                            txtProfileContact.Text = r["ContactNo"].ToString();
                            txtProfileGender.Text = r["Gender"].ToString();
                            txtProfileBirthdate.Text = r["Birthdate"] != DBNull.Value
                                ? Convert.ToDateTime(r["Birthdate"]).ToString("MMMM dd, yyyy") : "";
                            txtProfileAddress.Text = r["Address"].ToString();
                        }
                    }
                }
            }
        }

        // ── SEARCH ──
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCaregivers(txtSearch.Text.Trim(), ddlService.SelectedValue);
        }

        // ── SAVE PROFILE ──
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    string q = @"UPDATE Users SET
                                    FirstName = @FN, LastName = @LN,
                                    Email     = @Em, ContactNo = @CN,
                                    Address   = @Ad
                                 WHERE UserID = @UID";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@FN", txtProfileFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@LN", txtProfileLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Em", txtProfileEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@CN", txtProfileContact.Text.Trim());
                        cmd.Parameters.AddWithValue("@Ad", txtProfileAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@UID", UserID);
                        cmd.ExecuteNonQuery();
                    }
                }

                string newName = txtProfileFirstName.Text.Trim() + " " + txtProfileLastName.Text.Trim();
                Session["UserName"] = newName;
                lblSidebarName.Text = newName;
                lblGreetName.Text = newName;
                lblProfileName.Text = newName;
                lblProfileMsg.Text = "✓ Profile updated successfully!";
            }
            catch (Exception ex)
            {
                lblProfileMsg.Text = "Error: " + ex.Message;
            }
        }

        // ── GET REVIEWS (called via fetch from modal JS) ──
        [WebMethod]
        public static string GetCaregiverReviews(int caregiverID)
        {
            string connStr = System.Configuration.ConfigurationManager
                .ConnectionStrings["SwiftCareDB"].ConnectionString;

            var reviews = new System.Collections.Generic.List<object>();
            double avgRating = 0;
            int totalCount = 0;

            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                using (var cmd = new System.Data.SqlClient.SqlCommand(@"
                    SELECT
                        u.FirstName + ' ' + u.LastName  AS ReviewerName,
                        r.Rating,
                        ISNULL(r.Comment, '')           AS Comment,
                        REPLICATE(N'★', r.Rating) + REPLICATE(N'☆', 5 - r.Rating) AS Stars
                    FROM Reviews r
                    INNER JOIN Users u ON r.UserID = u.UserID
                    WHERE r.CaregiverID = @CgID
                    ORDER BY r.ReviewID DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@CgID", caregiverID);
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            reviews.Add(new
                            {
                                ReviewerName = r["ReviewerName"].ToString(),
                                Rating = Convert.ToInt32(r["Rating"]),
                                Comment = r["Comment"].ToString(),
                                Stars = r["Stars"].ToString()
                            });
                            totalCount++;
                        }
                    }
                }

                // Average rating
                if (totalCount > 0)
                {
                    using (var cmd = new System.Data.SqlClient.SqlCommand(
                        "SELECT AVG(CAST(Rating AS FLOAT)) FROM Reviews WHERE CaregiverID = @CgID", conn))
                    {
                        cmd.Parameters.AddWithValue("@CgID", caregiverID);
                        object avg = cmd.ExecuteScalar();
                        if (avg != null && avg != System.DBNull.Value)
                            avgRating = Math.Round(Convert.ToDouble(avg), 1);
                    }
                }
            }

            var result = new { avgRating, totalCount, reviews };
            return new JavaScriptSerializer().Serialize(result);
        }

        // ── SUBMIT REVIEW ──
        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            int bookingID = 0;
            int caregiverID = 0;

            if (!int.TryParse(hfReviewBookingID.Value, out bookingID) || bookingID == 0)
            { lblReviewMsg.Text = "Invalid booking."; ReopenModal(); return; }
            if (!int.TryParse(hfReviewCaregiverID.Value, out caregiverID) || caregiverID == 0)
            { lblReviewMsg.Text = "Invalid caregiver."; ReopenModal(); return; }

            int rating = 0;
            int.TryParse(Request.Form["hdnRatingValue"], out rating);
            if (rating < 1 || rating > 5)
            { lblReviewMsg.Text = "Please select a star rating."; ReopenModal(); return; }

            string comment = txtReviewComment.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Prevent duplicate — one review per booking per user
                    using (SqlCommand chk = new SqlCommand(
                        "SELECT COUNT(*) FROM Reviews WHERE BookingID=@BID AND UserID=@UID", conn))
                    {
                        chk.Parameters.AddWithValue("@BID", bookingID);
                        chk.Parameters.AddWithValue("@UID", UserID);
                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            lblReviewMsg.Text = "You have already reviewed this booking.";
                            ScriptManager.RegisterStartupScript(this, GetType(), "panelBookings",
                                "window.addEventListener('DOMContentLoaded',function(){ showPanel('bookings'); });", true);
                            return;
                        }
                    }

                    // INSERT into Reviews table
                    using (SqlCommand ins = new SqlCommand(@"
                        INSERT INTO Reviews (BookingID, UserID, CaregiverID, Rating, Comment)
                        VALUES (@BID, @UID, @CgID, @Rating, @Comment)", conn))
                    {
                        ins.Parameters.AddWithValue("@BID", bookingID);
                        ins.Parameters.AddWithValue("@UID", UserID);
                        ins.Parameters.AddWithValue("@CgID", caregiverID);
                        ins.Parameters.AddWithValue("@Rating", rating);
                        ins.Parameters.AddWithValue("@Comment",
                            string.IsNullOrEmpty(comment) ? (object)DBNull.Value : comment);
                        ins.ExecuteNonQuery();
                    }
                }

                LoadBookings();
                lblReviewMsg.Text = "";
                lblProfileMsg.Text = "";
                ScriptManager.RegisterStartupScript(this, GetType(), "reviewDone",
                    "window.addEventListener('DOMContentLoaded',function(){ " +
                    "showPanel('bookings'); showToast('✓ Review submitted!'); });", true);
            }
            catch (Exception ex)
            {
                lblReviewMsg.Text = "Error: " + ex.Message;
                ReopenModal();
            }
        }

        private void ReopenModal()
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "panelAndModal",
                "window.addEventListener('DOMContentLoaded',function(){ " +
                "showPanel('bookings'); " +
                "document.getElementById('reviewModal').classList.add('open'); });", true);
        }

        // ── LOGOUT ──
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Homepage.aspx");
        }
    }
}