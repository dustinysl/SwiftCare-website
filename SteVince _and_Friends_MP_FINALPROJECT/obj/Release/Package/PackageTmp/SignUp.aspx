<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.SignUp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare — Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <style>
        :root {
            --blue-dark:   #0a2a4a;
            --blue-mid:    #1565a0;
            --blue-bright: #1e88e5;
            --teal-dark:   #006064;
            --teal-mid:    #00838f;
            --teal-bright: #26c6da;
            --teal-light:  #80deea;
            --teal-pale:   #e0f7fa;
            --white:       #ffffff;
            --off-white:   #f4fbfc;
            --text-dark:   #062035;
            --text-mid:    #1a4a62;
            --text-light:  #4a7a92;
            --error:       #e53935;
            --radius:      14px;
            --shadow-lg:   0 20px 60px rgba(10,42,74,0.18);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body {
            font-family: 'Nunito', sans-serif;
            background: var(--off-white);
            color: var(--text-dark);
            min-height: 100vh;
        }

        /* ── NAV ── */
        nav {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 5%; height: 90px;
            background: var(--blue-dark);
            box-shadow: 0 2px 16px rgba(10,42,74,0.35);
        }
        .nav-logo { display: flex; align-items: center; }
        .nav-logo img { height: 150px; width: auto; object-fit: contain; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 8px;
            background: transparent;
            border: 2px solid var(--teal-light);
            color: var(--teal-light);
            font-family: 'Nunito', sans-serif;
            font-size: 14px; font-weight: 700;
            padding: 8px 20px; border-radius: 50px;
            text-decoration: none; cursor: pointer;
            transition: all 0.3s;
        }
        .btn-back:hover { background: var(--teal-light); color: var(--blue-dark); }

        /* ── PAGE LAYOUT ── */
        .page-wrapper {
            min-height: 100vh;
            padding-top: 90px;
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        /* LEFT PANEL */
        .left-panel {
            background: linear-gradient(160deg, var(--blue-dark) 0%, var(--teal-dark) 100%);
            display: flex; flex-direction: column;
            justify-content: center; align-items: flex-start;
            padding: 60px 8%;
            position: relative; overflow: hidden;
        }
        .left-panel::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(ellipse 70% 60% at 80% 30%, rgba(38,198,218,0.15) 0%, transparent 70%);
        }
        .left-panel-content { position: relative; z-index: 1; }
        .left-panel h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: clamp(35px, 3vw, 42px); font-weight: 800;
            color: white; line-height: 1.15; letter-spacing: -0.5px;
            margin-bottom: 18px;
        }
        .left-panel h2 span { color: var(--teal-bright); }
        .left-panel p {
            font-size: 25px; color: rgba(255,255,255,0.75);
            line-height: 1.75; max-width: 380px; margin-bottom: 40px;
        }
        .left-login-prompt {
            margin-top: 48px;
            font-size: 24px; color: rgba(255,255,255,0.6);
        }
        .left-login-prompt a {
            color: var(--teal-bright); font-weight: 700; text-decoration: none;
        }
        .left-login-prompt a:hover { text-decoration: underline; }

        /* RIGHT PANEL */
        .right-panel {
            display: flex; align-items: center; justify-content: center;
            padding: 48px 6%;
            background: var(--off-white);
        }
        .signup-card {
            background: white;
            border-radius: 24px;
            padding: 44px 40px;
            width: 100%; max-width: 520px;
            box-shadow: var(--shadow-lg);
            animation: cardIn 0.6s ease forwards;
            opacity: 0;
        }
        @keyframes cardIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .card-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 26px; font-weight: 800;
            color: var(--text-dark); margin-bottom: 6px;
        }
        .card-sub {
            font-size: 14px; color: var(--text-light);
            margin-bottom: 28px;
        }

        /* Role Toggle */
        .role-toggle {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 10px; margin-bottom: 28px;
        }
        .role-btn {
            padding: 12px; border-radius: 12px;
            border: 2px solid var(--teal-pale);
            background: white; cursor: pointer;
            text-align: center; transition: all 0.25s;
            font-family: 'Nunito', sans-serif;
        }
        .role-btn .role-img { width: 52px; height: 52px; object-fit: contain; display: block; margin: 0 auto 6px; }
        .role-btn .role-label { font-size: 13px; font-weight: 700; color: var(--text-mid); }
        .role-btn.active { border-color: var(--teal-mid); background: var(--teal-pale); }
        .role-btn.active .role-label { color: var(--teal-dark); }

        /* Form */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-label {
            font-size: 13px; font-weight: 700;
            color: var(--text-mid); letter-spacing: 0.3px;
        }
        .form-input {
            width: 100%; padding: 12px 16px;
            border: 2px solid #e8f4f8;
            border-radius: 10px;
            font-family: 'Nunito', sans-serif;
            font-size: 14px; color: var(--text-dark);
            background: #f8fdff;
            transition: all 0.25s; outline: none;
        }
        .form-input:focus {
            border-color: var(--teal-bright);
            background: white;
            box-shadow: 0 0 0 4px rgba(38,198,218,0.1);
        }
        .form-input.error { border-color: var(--error); }
        select.form-input { cursor: pointer; }

        .error-msg {
            font-size: 12px; color: var(--error);
            font-weight: 600; display: none;
        }
        .error-msg.show { display: block; }

        /* Submit */
        .btn-submit {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright));
            color: white; border: none;
            border-radius: 12px;
            font-family: 'Nunito', sans-serif;
            font-size: 16px; font-weight: 800;
            cursor: pointer; margin-top: 20px;
            transition: all 0.3s;
            box-shadow: 0 4px 14px rgba(38,198,218,0.35);
            letter-spacing: 0.3px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(38,198,218,0.45); }
        .btn-submit:active { transform: translateY(0); }

        .terms-note {
            text-align: center; font-size: 12px;
            color: var(--text-light); margin-top: 14px; line-height: 1.6;
        }

        /* Server message */
        .server-msg {
            padding: 12px 16px; border-radius: 10px;
            font-size: 13px; font-weight: 600;
            margin-bottom: 16px; display: none;
        }
        .server-msg.error-box { background: #fdecea; color: var(--error); border: 1px solid #f5c6c6; }
        .server-msg.success-box { background: #e0f7fa; color: var(--teal-dark); border: 1px solid var(--teal-light); }

        /* Responsive */
        @media (max-width: 900px) {
            .page-wrapper { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 32px 5%; }
        }
        @media (max-width: 480px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: 1; }
            .signup-card { padding: 32px 22px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- NAV -->
        <nav>
            <div class="nav-logo">
                <img src="<%=ResolveUrl("~/App Data/No_Bg_Logo.png")%>" alt="SwiftCare Logo" />
            </div>
            <a href="Homepage.aspx" class="btn-back">← Back to Home</a>
        </nav>

        <div class="page-wrapper">

            <!-- LEFT PANEL -->
            <div class="left-panel">
                <div class="left-panel-content">
                    <h2>Join <span>SwiftCare</span> today</h2>
                    <p>Connect with trusted caregivers or start earning by offering your skills all in one platform built for Filipino families.</p>
                    <p class="left-login-prompt">
                        Already have an account? <a href="Login.aspx">Log In</a>
                    </p>
                </div>
            </div>

            <!-- RIGHT PANEL -->
            <div class="right-panel">
                <div class="signup-card">
                    <div class="card-title">Create your account</div>
                    <div class="card-sub">Fill in your details to get started with SwiftCare.</div>

                    <!-- Server message -->
                    <asp:Label ID="lblMessage" runat="server" CssClass="server-msg" />

                    <!-- Role Selection -->
                    <div class="role-toggle" id="roleToggle">
                        <div class="role-btn active" id="roleUser" onclick="selectRole('User')">
                            <img src="<%=ResolveUrl("~/App Data/Find A Caregiver.png")%>" class="role-img" alt="Find a Caregiver" />
                            <span class="role-label">I need a Caregiver</span>
                        </div>
                        <div class="role-btn" id="roleCaregiver" onclick="selectRole('Caregiver')">
                            <img src="<%=ResolveUrl("~/App Data/Be A Caregiver.png")%>" class="role-img" alt="Be a Caregiver" />
                            <span class="role-label">Be A Caregiver</span>
                        </div>
                    </div>
                    <asp:HiddenField ID="hdnRole" runat="server" Value="User" />

                    <div class="form-grid">

                        <!-- First Name -->
                        <div class="form-group">
                            <label class="form-label" for="txtFirstName">First Name</label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-input"
                                placeholder="e.g. Juan" MaxLength="50" />
                            <span class="error-msg" id="errFirstName">Enter your first name.</span>
                        </div>

                        <!-- Last Name -->
                        <div class="form-group">
                            <label class="form-label" for="txtLastName">Last Name</label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-input"
                                placeholder="e.g. dela Cruz" MaxLength="50" />
                            <span class="error-msg" id="errLastName">Enter your last name.</span>
                        </div>

                        <!-- Email -->
                        <div class="form-group full">
                            <label class="form-label" for="txtEmail">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                                TextMode="Email" placeholder="you@email.com" MaxLength="100" />
                            <span class="error-msg" id="errEmail">Please enter a valid email.</span>
                        </div>

                        <!-- Contact No -->
                        <div class="form-group full">
                            <label class="form-label" for="txtContactNo">Contact Number</label>
                            <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-input"
                                placeholder="09XX XXX XXXX" MaxLength="20" />
                            <span class="error-msg" id="errContactNo">Please enter your contact number.</span>
                        </div>

                        <!-- Birthdate -->
                        <div class="form-group">
                            <label class="form-label" for="txtBirthdate">Birthdate</label>
                            <asp:TextBox ID="txtBirthdate" runat="server" CssClass="form-input"
                                TextMode="Date" />
                            <span class="error-msg" id="errBirthdate">Please enter your birthdate.</span>
                        </div>

                        <!-- Gender -->
                        <div class="form-group">
                            <label class="form-label" for="ddlGender">Gender</label>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-input">
                                <asp:ListItem Value="" Text="-- Select --" />
                                <asp:ListItem Value="Male" Text="Male" />
                                <asp:ListItem Value="Female" Text="Female" />
                            </asp:DropDownList>
                            <span class="error-msg" id="errGender">Please select your gender.</span>
                        </div>

                        <!-- Address -->
                        <div class="form-group full">
                            <label class="form-label" for="txtAddress">Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-input"
                                placeholder="Street, Barangay, City, Province" MaxLength="100" />
                            <span class="error-msg" id="errAddress">Please enter your address.</span>
                        </div>

                        <!-- Password -->
                        <div class="form-group full">
                            <label class="form-label" for="txtPassword">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input"
                                TextMode="Password" placeholder="At least 8 characters" MaxLength="50" />
                            <span class="error-msg" id="errPassword">Password must be at least 8 characters.</span>
                        </div>

                        <!-- Confirm Password -->
                        <div class="form-group full">
                            <label class="form-label" for="txtConfirmPassword">Confirm Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input"
                                TextMode="Password" placeholder="Re-enter your password" MaxLength="50" />
                            <span class="error-msg" id="errConfirm">Passwords do not match.</span>
                        </div>

                    </div>

                    <!-- Submit -->
                    <asp:Button ID="btnSignUp" runat="server" Text="Create Account"
                        CssClass="btn-submit" OnClick="btnSignUp_Click"
                        OnClientClick="return validateForm();" />
                </div>
            </div>

        </div>

        <script>
            function selectRole(role) {
                document.getElementById('hdnRole').value = role;
                document.getElementById('roleUser').classList.toggle('active', role === 'User');
                document.getElementById('roleCaregiver').classList.toggle('active', role === 'Caregiver');
            }

            function validateForm() {
                var valid = true;

                function check(fieldId, errorId, condition) {
                    var field = document.getElementById(fieldId);
                    var err = document.getElementById(errorId);
                    if (!condition(field ? field.value : '')) {
                        if (field) field.classList.add('error');
                        if (err) err.classList.add('show');
                        valid = false;
                    } else {
                        if (field) field.classList.remove('error');
                        if (err) err.classList.remove('show');
                    }
                }

                check('<%= txtFirstName.ClientID %>', 'errFirstName', function (v) { return v.trim().length > 0; });
                check('<%= txtLastName.ClientID %>', 'errLastName', function (v) { return v.trim().length > 0; });
                check('<%= txtEmail.ClientID %>', 'errEmail', function (v) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v); });
                check('<%= txtContactNo.ClientID %>',   'errContactNo',  function(v) { return v.trim().length >= 10; });
                check('<%= txtBirthdate.ClientID %>',   'errBirthdate',  function(v) { return v.trim() !== ''; });
                check('<%= ddlGender.ClientID %>',      'errGender',     function(v) { return v !== ''; });
                check('<%= txtAddress.ClientID %>',     'errAddress',    function(v) { return v.trim().length > 3; });
                check('<%= txtPassword.ClientID %>',    'errPassword',   function(v) { return v.length >= 8; });

                var pw    = document.getElementById('<%= txtPassword.ClientID %>').value;
                var cpw   = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
                var errC  = document.getElementById('errConfirm');
                var cfField = document.getElementById('<%= txtConfirmPassword.ClientID %>');
                if (pw !== cpw || cpw === '') {
                    cfField.classList.add('error');
                    errC.classList.add('show');
                    valid = false;
                } else {
                    cfField.classList.remove('error');
                    errC.classList.remove('show');
                }

                return valid;
            }
        </script>

    </form>
</body>
</html>
