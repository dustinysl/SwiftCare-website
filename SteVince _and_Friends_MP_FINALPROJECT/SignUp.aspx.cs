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
    public partial class SignUp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                string role = Session["UserRole"]?.ToString();
                if (role == "User")
                    Response.Redirect("~/User Dashboard.aspx");
                else if (role == "Caregiver")
                    Response.Redirect("~/Caregiver Dashboard.aspx");
            }
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string contactNo = txtContactNo.Text.Trim();
            string birthdate = txtBirthdate.Text.Trim();
            string gender = ddlGender.SelectedValue;
            string address = txtAddress.Text.Trim();
            string password = txtPassword.Text;
            string confirmPw = txtConfirmPassword.Text;
            string role = hdnRole.Value; 


            if (string.IsNullOrWhiteSpace(firstName) ||
                string.IsNullOrWhiteSpace(lastName) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(contactNo) ||
                string.IsNullOrWhiteSpace(birthdate) ||
                string.IsNullOrWhiteSpace(gender) ||
                string.IsNullOrWhiteSpace(address) ||
                string.IsNullOrWhiteSpace(password))
            {
                ShowError("Please fill in all required fields.");
                return;
            }

            if (password.Length < 8)
            {
                ShowError("Password must be at least 8 characters.");
                return;
            }

            if (password != confirmPw)
            {
                ShowError("Passwords do not match.");
                return;
            }

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["SwiftCareDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    using (SqlCommand checkCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Users WHERE Email = @Email", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            ShowError("An account with this email already exists.");
                            return;
                        }
                    }

 
                    int newUserID = 1;
                    using (SqlCommand maxCmd = new SqlCommand(
                        "SELECT ISNULL(MAX(UserID), 0) + 1 FROM Users", conn))
                    {
                        newUserID = Convert.ToInt32(maxCmd.ExecuteScalar());
                    }

                    string insertQuery = @"
                        INSERT INTO Users 
                            (UserID, FirstName, LastName, Email, Password,
                             ContactNo, Address, Role, AccountStatus, Birthdate, Gender)
                        VALUES 
                            (@UserID, @FirstName, @LastName, @Email, @Password,
                             @ContactNo, @Address, @Role, @AccountStatus, @Birthdate, @Gender)";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", newUserID);
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@ContactNo", contactNo);
                        cmd.Parameters.AddWithValue("@Address", address);
                        cmd.Parameters.AddWithValue("@Role", role);
                        cmd.Parameters.AddWithValue("@AccountStatus", "Active");
                        cmd.Parameters.AddWithValue("@Birthdate", DateTime.Parse(birthdate));
                        cmd.Parameters.AddWithValue("@Gender", gender);
                        cmd.ExecuteNonQuery();
                    }

  
                    Session["UserID"] = newUserID;
                    Session["UserRole"] = role;
                    Session["UserName"] = firstName + " " + lastName;

                    if (role == "Caregiver")
                    {
              
                        int newCaregiverID = 1;
                        using (SqlCommand maxCgCmd = new SqlCommand(
                            "SELECT ISNULL(MAX(CaregiverID), 0) + 1 FROM CaregiverProfiles", conn))
                        {
                            newCaregiverID = Convert.ToInt32(maxCgCmd.ExecuteScalar());
                        }

                        string cgInsert = @"
                            INSERT INTO CaregiverProfiles 
                                (CaregiverID, UserID, ServicesOffered, HourlyRate, AvailabilityStatus)
                            VALUES 
                                (@CaregiverID, @UserID, @ServicesOffered, @HourlyRate, @AvailabilityStatus)";

                        using (SqlCommand cgCmd = new SqlCommand(cgInsert, conn))
                        {
                            cgCmd.Parameters.AddWithValue("@CaregiverID", newCaregiverID);
                            cgCmd.Parameters.AddWithValue("@UserID", newUserID);
                            cgCmd.Parameters.AddWithValue("@ServicesOffered", "");
                            cgCmd.Parameters.AddWithValue("@HourlyRate", 0);
                            cgCmd.Parameters.AddWithValue("@AvailabilityStatus", "Available");
                            cgCmd.ExecuteNonQuery();
                        }
                    }
                }

                if (role == "Caregiver")
                    Response.Redirect("~/Caregiver Dashboard.aspx");
                else
                    Response.Redirect("~/User Dashboard.aspx");
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