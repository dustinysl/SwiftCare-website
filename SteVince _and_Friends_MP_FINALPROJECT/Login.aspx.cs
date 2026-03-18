using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SteVince__and_Friends_MP_FINALPROJECT
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                string existingRole = Session["UserRole"]?.ToString();
                if (existingRole == "Caregiver")
                    Response.Redirect("~/Caregiver Dashboard.aspx");
                else if (existingRole == "Admin")
                    Response.Redirect("~/Admin Dashboard.aspx");
                else
                    Response.Redirect("~/User Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("Please enter your email and password.");
                return;
            }

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["SwiftCareDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string query = @"
                        SELECT UserID, FirstName, LastName, Role, AccountStatus
                        FROM Users
                        WHERE Email = @Email AND Password = @Password";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string accountStatus = reader["AccountStatus"].ToString();

                                if (accountStatus != "Active")
                                {
                                    ShowError("Your account is inactive. Please contact support.");
                                    return;
                                }

                                Session["UserID"] = reader["UserID"].ToString();
                                Session["UserRole"] = reader["Role"].ToString();
                                Session["UserName"] = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();

                                string role = reader["Role"].ToString();

                                if (role == "Caregiver")
                                    Response.Redirect("~/Caregiver Dashboard.aspx");
                                else if (role == "Admin")
                                    Response.Redirect("~/Admin Dashboard.aspx");
                                else
                                    Response.Redirect("~/User Dashboard.aspx");
                            }
                            else
                            {
                                ShowError("Invalid email or password. Please try again.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Something went wrong: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "server-msg error-box";
            ScriptManager.RegisterStartupScript(this, GetType(), "showMsg",
                "document.querySelector('.server-msg').style.display='block';", true);
        }
    }
}