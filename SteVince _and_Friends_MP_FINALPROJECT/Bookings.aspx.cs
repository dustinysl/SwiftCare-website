using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SteVince__and_Friends_MP_FINALPROJECT
{
    public partial class Bookings : Page
    {
        // ── Exposed to ASPX ──
        public string CaregiverDisplayName { get; private set; } = "";
        public string RateDecimal { get; private set; } = "0";
        public string ToastMessage { get; private set; } = "";
        public string AvailableDaysJson { get; private set; } = "[]";
        public string DayStartVal { get; private set; } = "";
        public string DayEndVal { get; private set; } = "";

        private string ConnStr => ConfigurationManager.ConnectionStrings["SwiftCareDB"].ConnectionString;

        // ─────────────────────────────────────────────────
        //  PAGE LOAD
        // ─────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            // Only logged-in Users may book
            if (Session["UserID"] == null || Session["UserRole"]?.ToString() != "User")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // CaregiverID must be passed via query string: ActiveBooking.aspx?cgID=3
            string cgParam = Request.QueryString["cgID"];
            if (string.IsNullOrWhiteSpace(cgParam) || !int.TryParse(cgParam, out int cgID))
            {
                Response.Redirect("~/User Dashboard.aspx");
                return;
            }

            string name = Session["UserName"]?.ToString() ?? "User";
            lblSidebarName.Text = name;
            lblGreetName.Text = name.Split(' ')[0];

            // ── Always reload services ──
            // DropDownList items populated from DB are NOT stored in ViewState,
            // so they vanish on every postback. Save the user's selection first,
            // rebuild the list, then restore the selection afterwards.
            string previousSelection = hfSelectedService.Value;
            LoadServices();
            if (!string.IsNullOrEmpty(previousSelection))
            {
                var item = ddlService.Items.FindByValue(previousSelection);
                if (item != null) item.Selected = true;
            }

            // ── Always load caregiver summary ──
            // RateDecimal and CaregiverDisplayName are written into page HTML via
            // <%= %> at render time — they must be set on every single request.
            int activeCgID = IsPostBack
                ? (int.TryParse(hfCaregiverID.Value, out int stored) ? stored : cgID)
                : cgID;

            LoadCaregiverSummary(activeCgID);

            if (!IsPostBack)
            {
                hfCaregiverID.Value = cgID.ToString();
                txtBookingDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }

        // ─────────────────────────────────────────────────
        //  LOAD CAREGIVER SUMMARY (right card)
        // ─────────────────────────────────────────────────
        private void LoadCaregiverSummary(int cgID)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                string sql = @"
                    SELECT
                        u.FirstName + ' ' + u.LastName              AS FullName,
                        ISNULL(u.ContactNo, 'N/A')                  AS ContactNo,
                        ISNULL(u.Gender,   'N/A')                   AS Gender,
                        ISNULL(u.Address,  'N/A')                   AS Address,
                        ISNULL(cp.HourlyRate, 0)                    AS HourlyRate,
                        ISNULL(cp.AvailabilityStatus, 'Available')  AS AvailabilityStatus,
                        ISNULL(cp.AvailableDays, '')                AS AvailableDays,
                        CASE WHEN COL_LENGTH('CaregiverProfiles','DayStartTime') IS NOT NULL
                             THEN ISNULL(cp.DayStartTime,'') ELSE '' END AS DayStartTime,
                        CASE WHEN COL_LENGTH('CaregiverProfiles','DayEndTime') IS NOT NULL
                             THEN ISNULL(cp.DayEndTime,'') ELSE '' END AS DayEndTime,
                        ISNULL(
                            (SELECT STRING_AGG(s.ServiceName, ', ')
                             FROM CaregiverServices cs
                             INNER JOIN Services s ON cs.ServiceID = s.ServiceID
                             WHERE cs.CaregiverID = cp.CaregiverID),
                        '')                                          AS ServicesOffered
                    FROM CaregiverProfiles cp
                    INNER JOIN Users u ON cp.UserID = u.UserID
                    WHERE cp.CaregiverID = @CgID";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CgID", cgID);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            string fullName = r["FullName"].ToString();
                            string rate = string.Format("{0:N2}", r["HourlyRate"]);
                            string services = r["ServicesOffered"].ToString();
                            string availDays = r["AvailableDays"].ToString();

                            CaregiverDisplayName = fullName;
                            RateDecimal = Convert.ToDecimal(r["HourlyRate"]).ToString("F2");

                            // Expose time range to JS
                            DayStartVal = r["DayStartTime"].ToString();
                            DayEndVal = r["DayEndTime"].ToString();

                            // Build AvailableDays JSON array for JS
                            if (!string.IsNullOrEmpty(availDays))
                            {
                                var nums = new System.Collections.Generic.List<string>();
                                foreach (string d in availDays.Split(','))
                                    if (int.TryParse(d.Trim(), out int n)) nums.Add(n.ToString());
                                AvailableDaysJson = "[" + string.Join(",", nums) + "]";
                            }

                            lblCgName.Text = fullName;
                            txtCaregiverName.Text = fullName;
                            lblCgLocation.Text = r["Address"].ToString();
                            lblCgContact.Text = r["ContactNo"].ToString();
                            lblCgGender.Text = r["Gender"].ToString();
                            lblCgAddress.Text = r["Address"].ToString();
                            lblCgRate.Text = rate;
                            lblHourlyRate.Text = rate;
                            lblCgAvailability.Text = r["AvailabilityStatus"].ToString();

                            // Build service tags
                            string tagHtml = "";
                            foreach (string s in services.Split(','))
                            {
                                string svc = s.Trim();
                                if (!string.IsNullOrEmpty(svc))
                                    tagHtml += $"<span class=\"service-tag\">{System.Web.HttpUtility.HtmlEncode(svc)}</span>";
                            }
                            litServiceTags.Text = tagHtml;

                            // Build available days badges (Mon–Sun order: 1,2,3,4,5,6,0)
                            string[] allDays = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
                            string daysHtml = "";
                            if (!string.IsNullOrEmpty(availDays))
                            {
                                var selectedNums = new System.Collections.Generic.HashSet<int>();
                                foreach (string d in availDays.Split(','))
                                    if (int.TryParse(d.Trim(), out int num)) selectedNums.Add(num);

                                foreach (int dayNum in new[] { 1, 2, 3, 4, 5, 6, 0 })
                                {
                                    string cssClass = selectedNums.Contains(dayNum) ? "avail-day" : "avail-day off";
                                    daysHtml += $"<span class=\"{cssClass}\">{allDays[dayNum]}</span>";
                                }
                            }
                            else
                            {
                                daysHtml = "<span class=\"avail-none\">No availability set yet.</span>";
                            }
                            litAvailDays.Text = daysHtml;

                            // Build single whole-day time display
                            string timesHtml = "";
                            if (!string.IsNullOrEmpty(DayStartVal) && !string.IsNullOrEmpty(DayEndVal))
                                timesHtml = $"<div class=\"avail-time-row\"><span class=\"avail-time-label\">🕐 Working Hours</span><span class=\"avail-time-val\">{DayStartVal} – {DayEndVal}</span></div>";
                            else
                                timesHtml = "<span class=\"avail-none\">No hours set yet.</span>";
                            litAvailTimes.Text = timesHtml;
                        }
                        else
                        {
                            Response.Redirect("~/User Dashboard.aspx");
                        }
                    }
                }
            }
        }

        // ─────────────────────────────────────────────────
        //  LOAD SERVICES — only caregiver's offered services
        // ─────────────────────────────────────────────────
        private void LoadServices()
        {
            // Get cgID from query string or hidden field
            int cgID = 0;
            int.TryParse(Request.QueryString["cgID"] ?? hfCaregiverID.Value, out cgID);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                ddlService.Items.Clear();
                ddlService.Items.Add(new ListItem("-- Select a Service --", ""));

                // Load only the services this specific caregiver offers via CaregiverServices
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT s.ServiceID, s.ServiceName
                    FROM CaregiverServices cs
                    INNER JOIN Services s ON cs.ServiceID = s.ServiceID
                    WHERE cs.CaregiverID = @CgID
                    ORDER BY s.ServiceName", conn))
                {
                    cmd.Parameters.AddWithValue("@CgID", cgID);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Fallback: if caregiver has no services assigned yet, show all services
                    if (dt.Rows.Count == 0)
                    {
                        using (SqlCommand fallback = new SqlCommand(
                            "SELECT ServiceID, ServiceName FROM Services ORDER BY ServiceName", conn))
                        {
                            da.SelectCommand = fallback;
                            dt.Clear();
                            da.Fill(dt);
                        }
                    }

                    foreach (DataRow row in dt.Rows)
                        ddlService.Items.Add(new ListItem(
                            row["ServiceName"].ToString(),
                            row["ServiceID"].ToString()));
                }
            }
        }

        // ─────────────────────────────────────────────────
        //  HELPER: get hourly rate for rate display after postback
        // ─────────────────────────────────────────────────
        private string GetHourlyRate(int cgID)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(HourlyRate, 0) FROM CaregiverProfiles WHERE CaregiverID = @CgID", conn))
                {
                    cmd.Parameters.AddWithValue("@CgID", cgID);
                    object result = cmd.ExecuteScalar();
                    return result == null ? "0" : Convert.ToDecimal(result).ToString("F2");
                }
            }
        }

        // ─────────────────────────────────────────────────
        //  CONFIRM BOOKING — INSERT into Bookings
        // ─────────────────────────────────────────────────
        protected void btnConfirmBooking_Click(object sender, EventArgs e)
        {
            // ── Validate ──
            if (string.IsNullOrWhiteSpace(ddlService.SelectedValue))
            { ShowError("Please select a service."); return; }

            if (!int.TryParse(ddlService.SelectedValue, out int serviceID))
            { ShowError("Invalid service selected."); return; }

            if (!DateTime.TryParse(txtBookingDate.Text, out DateTime bookingDate))
            { ShowError("Please enter a valid booking date."); return; }

            if (bookingDate.Date < DateTime.Today)
            { ShowError("Booking date cannot be in the past."); return; }

            if (!TimeSpan.TryParse(txtStartTime.Text, out TimeSpan startTime))
            { ShowError("Please enter a valid start time."); return; }

            if (!TimeSpan.TryParse(txtEndTime.Text, out TimeSpan endTime))
            { ShowError("Please enter a valid end time."); return; }

            if (endTime <= startTime)
            { ShowError("End time must be after start time."); return; }

            if (!int.TryParse(hfCaregiverID.Value, out int caregiverID))
            { ShowError("Invalid caregiver. Please go back and try again."); return; }

            int userID = Convert.ToInt32(Session["UserID"]);

            // ── INSERT ──
            try
            {
                int newBookingID;

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Check for overlapping booking on the same caregiver
                    string overlapSql = @"
                        SELECT COUNT(*) FROM Bookings
                        WHERE CaregiverID = @CgID
                          AND BookingDate  = @Date
                          AND Status NOT IN ('Cancelled')
                          AND StartTime < @End
                          AND EndTime   > @Start";

                    using (SqlCommand chk = new SqlCommand(overlapSql, conn))
                    {
                        chk.Parameters.AddWithValue("@CgID", caregiverID);
                        chk.Parameters.AddWithValue("@Date", bookingDate.Date);
                        chk.Parameters.AddWithValue("@Start", startTime);
                        chk.Parameters.AddWithValue("@End", endTime);
                        int conflicts = (int)chk.ExecuteScalar();
                        if (conflicts > 0)
                        {
                            ShowError("⚠️ The caregiver already has a booking that overlaps this time slot. Please choose a different time.");
                            return;
                        }
                    }

                    // Insert the booking
                    string insertSql = @"
                        INSERT INTO Bookings (UserID, CaregiverID, ServiceID, BookingDate, StartTime, EndTime, Status)
                        OUTPUT INSERTED.BookingID
                        VALUES (@UserID, @CgID, @SvcID, @Date, @Start, @End, 'Pending')";

                    using (SqlCommand ins = new SqlCommand(insertSql, conn))
                    {
                        ins.Parameters.AddWithValue("@UserID", userID);
                        ins.Parameters.AddWithValue("@CgID", caregiverID);
                        ins.Parameters.AddWithValue("@SvcID", serviceID);
                        ins.Parameters.AddWithValue("@Date", bookingDate.Date);
                        ins.Parameters.AddWithValue("@Start", startTime);
                        ins.Parameters.AddWithValue("@End", endTime);
                        newBookingID = (int)ins.ExecuteScalar();
                    }
                }

                // ── Show success panel ──
                pnlBookingForm.Visible = false;
                pnlSuccess.Visible = true;

                lblNewBookingID.Text = newBookingID.ToString();
                lblSuccessCg.Text = lblCgName.Text;
                lblSuccessService.Text = ddlService.SelectedItem?.Text ?? "";
                lblSuccessDate.Text = bookingDate.ToString("MMMM dd, yyyy");
                lblSuccessTime.Text = DateTime.Today.Add(startTime).ToString("hh:mm tt")
                                       + " – "
                                       + DateTime.Today.Add(endTime).ToString("hh:mm tt");

                ToastMessage = "✅ Booking #" + newBookingID + " confirmed!";
            }
            catch (Exception ex)
            {
                ShowError("An error occurred: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────
        //  LOGOUT
        // ─────────────────────────────────────────────────
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Homepage.aspx");
        }

        // ─────────────────────────────────────────────────
        //  HELPERS
        // ─────────────────────────────────────────────────
        private void ShowError(string msg)
        {
            lblBookingMsg.Text = msg;
            lblBookingMsg.CssClass = "server-msg";
            pnlBookingForm.Visible = true;
            pnlSuccess.Visible = false;
        }
    }
}