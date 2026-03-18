using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SteVince__and_Friends_MP_FINALPROJECT
{
    public partial class Admin_Dashboard : System.Web.UI.Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SwiftCareDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string name = Session["UserName"]?.ToString() ?? "Admin";
                lblSidebarName.Text = name;
                lblGreetName.Text = name.Split(' ')[0];

                LoadStats();
                LoadAllBookings();
                LoadAllUsers();
                LoadAllCaregivers();
            }
        }

        // ── STATS ──
        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'User'", conn))
                    lblTotalUsers.Text = cmd.ExecuteScalar().ToString();

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Caregiver'", conn))
                    lblTotalCaregivers.Text = cmd.ExecuteScalar().ToString();

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings", conn))
                    lblTotalBookings.Text = cmd.ExecuteScalar().ToString();

                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings WHERE Status = 'Pending'", conn))
                    lblPendingBookings.Text = cmd.ExecuteScalar().ToString();
            }
        }

        // ── ALL BOOKINGS ──
        private void LoadAllBookings(string statusFilter = "")
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT
                        b.BookingID,
                        u.FirstName + ' ' + u.LastName              AS ClientName,
                        cu.FirstName + ' ' + cu.LastName            AS CaregiverName,
                        s.ServiceName,
                        CONVERT(VARCHAR, b.BookingDate, 107)        AS BookingDate,
                        CONVERT(VARCHAR, b.StartTime,   108)        AS StartTime,
                        CONVERT(VARCHAR, b.EndTime,     108)        AS EndTime,
                        b.Status,
                        LOWER(b.Status)                             AS StatusClass
                    FROM Bookings b
                    INNER JOIN Users u              ON b.UserID      = u.UserID
                    INNER JOIN CaregiverProfiles cp ON b.CaregiverID = cp.CaregiverID
                    INNER JOIN Users cu             ON cp.UserID     = cu.UserID
                    INNER JOIN Services s           ON b.ServiceID   = s.ServiceID
                    WHERE (@Status = '' OR b.Status = @Status)
                    ORDER BY b.BookingDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", statusFilter);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptBookings.DataSource = dt;
                    rptBookings.DataBind();
                    pnlNoBookings.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        // ── ALL USERS ──
        private void LoadAllUsers(string searchName = "")
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT
                        UserID,
                        FirstName + ' ' + LastName  AS FullName,
                        Email,
                        ISNULL(ContactNo, 'N/A')    AS ContactNo,
                        ISNULL(Address,  'N/A')     AS Address,
                        Role,
                        AccountStatus,
                        LOWER(AccountStatus)        AS StatusClass
                    FROM Users
                    WHERE Role != 'Admin'
                      AND (@Name = '' OR FirstName + ' ' + LastName LIKE '%' + @Name + '%'
                           OR Email LIKE '%' + @Name + '%')
                    ORDER BY UserID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", searchName);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptUsers.DataSource = dt;
                    rptUsers.DataBind();
                    pnlNoUsers.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        // ── ALL CAREGIVERS ──
        private void LoadAllCaregivers(string searchName = "")
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string query = @"
                    SELECT
                        u.UserID,
                        cp.CaregiverID,
                        u.FirstName + ' ' + u.LastName              AS FullName,
                        u.Email,
                        ISNULL(u.ContactNo, 'N/A')                  AS ContactNo,
                        ISNULL(u.Address,   'N/A')                  AS Address,
                        ISNULL(
                            (SELECT STRING_AGG(s.ServiceName, ', ')
                             FROM CaregiverServices cs
                             INNER JOIN Services s ON cs.ServiceID = s.ServiceID
                             WHERE cs.CaregiverID = cp.CaregiverID),
                        'N/A')                                       AS ServicesOffered,
                        ISNULL(cp.HourlyRate, 0)                    AS HourlyRate,
                        ISNULL(cp.AvailabilityStatus, 'N/A')        AS AvailabilityStatus,
                        u.AccountStatus,
                        LOWER(u.AccountStatus)                      AS StatusClass,
                        (SELECT COUNT(*) FROM Bookings b WHERE b.CaregiverID = cp.CaregiverID) AS TotalBookings
                    FROM CaregiverProfiles cp
                    INNER JOIN Users u ON cp.UserID = u.UserID
                    WHERE (@Name = '' OR u.FirstName + ' ' + u.LastName LIKE '%' + @Name + '%'
                           OR u.Email LIKE '%' + @Name + '%')
                    ORDER BY u.UserID DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", searchName);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCaregivers.DataSource = dt;
                    rptCaregivers.DataBind();
                    pnlNoCaregivers.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        // ── SEARCH USERS ──
        protected void btnSearchUsers_Click(object sender, EventArgs e)
        {
            LoadAllUsers(txtSearchUsers.Text.Trim());
        }

        // ── SEARCH CAREGIVERS ──
        protected void btnSearchCaregivers_Click(object sender, EventArgs e)
        {
            LoadAllCaregivers(txtSearchCaregivers.Text.Trim());
        }

        // ── FILTER BOOKINGS ──
        protected void btnFilterBookings_Click(object sender, EventArgs e)
        {
            LoadAllBookings(ddlBookingFilter.SelectedValue);
        }

        // ── TOGGLE ACCOUNT STATUS ──
        protected void AccountAction_Command(object sender, CommandEventArgs e)
        {
            try
            {
                int userID = Convert.ToInt32(e.CommandArgument);
                string newStatus = e.CommandName == "Deactivate" ? "Inactive" : "Active";

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE Users SET AccountStatus = @Status WHERE UserID = @UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@UID", userID);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblAdminMsg.Text = e.CommandName == "Deactivate" ? "Account deactivated." : "✓ Account activated!";
                LoadStats();
                LoadAllUsers(txtSearchUsers.Text.Trim());
                LoadAllCaregivers(txtSearchCaregivers.Text.Trim());
            }
            catch (Exception ex)
            {
                lblAdminMsg.Text = "Error: " + ex.Message;
            }
        }

        // ── UPDATE BOOKING STATUS ──
        protected void BookingAction_Command(object sender, CommandEventArgs e)
        {
            try
            {
                int bookingID = Convert.ToInt32(e.CommandArgument);
                string newStatus = e.CommandName;

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE Bookings SET Status = @Status WHERE BookingID = @BID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@BID", bookingID);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblAdminMsg.Text = "✓ Booking updated to " + newStatus + "!";
                LoadStats();
                LoadAllBookings(ddlBookingFilter.SelectedValue);
            }
            catch (Exception ex)
            {
                lblAdminMsg.Text = "Error: " + ex.Message;
            }
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