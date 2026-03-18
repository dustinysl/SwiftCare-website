<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare — Log In</title>
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
            --shadow-md:   0 8px 32px rgba(10,42,74,0.14);
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
        .btn-back:hover {
            background: var(--teal-light);
            color: var(--blue-dark);
        }

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

        .left-signup-prompt {
            margin-top: 48px;
            font-size: 24px; color: rgba(255,255,255,0.6);
        }
        .left-signup-prompt a {
            color: var(--teal-bright); font-weight: 700; text-decoration: none;
        }
        .left-signup-prompt a:hover { text-decoration: underline; }

        /* RIGHT PANEL */
        .right-panel {
            display: flex; align-items: center; justify-content: center;
            padding: 48px 6%;
            background: var(--off-white);
        }

        .login-card {
            background: white;
            border-radius: 24px;
            padding: 44px 40px;
            width: 100%; max-width: 460px;
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

        /* Form */
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 18px; }

        .form-label {
            font-size: 13px; font-weight: 700;
            color: var(--text-mid); letter-spacing: 0.3px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e8f4f8;
            border-radius: 10px;
            font-family: 'Nunito', sans-serif;
            font-size: 14px; color: var(--text-dark);
            background: #f8fdff;
            transition: all 0.25s;
            outline: none;
            -webkit-appearance: none;
        }
        .form-input:focus {
            border-color: var(--teal-bright);
            background: white;
            box-shadow: 0 0 0 4px rgba(38,198,218,0.1);
        }
        .form-input.error { border-color: var(--error); }

        /* Forgot link */
        .forgot-row {
            display: flex; justify-content: flex-end;
            margin-bottom: 6px;
        }
        .forgot-link {
            font-size: 13px; font-weight: 700; color: var(--teal-mid);
            text-decoration: none; transition: color 0.2s;
        }
        .forgot-link:hover { color: var(--teal-dark); text-decoration: underline; }

        .error-msg {
            font-size: 12px; color: var(--error);
            font-weight: 600; display: none;
        }
        .error-msg.show { display: block; }

        /* Server message */
        .server-msg {
            padding: 12px 16px; border-radius: 10px;
            font-size: 13px; font-weight: 600;
            margin-bottom: 16px; display: none;
        }
        .server-msg.error-box   { background: #fdecea; color: var(--error); border: 1px solid #f5c6c6; }
        .server-msg.success-box { background: #e0f7fa; color: var(--teal-dark); border: 1px solid var(--teal-light); }

        /* Submit */
        .btn-submit {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright));
            color: white; border: none;
            border-radius: 12px;
            font-family: 'Nunito', sans-serif;
            font-size: 16px; font-weight: 800;
            cursor: pointer; margin-top: 8px;
            transition: all 0.3s;
            box-shadow: 0 4px 14px rgba(38,198,218,0.35);
            letter-spacing: 0.3px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(38,198,218,0.45);
        }
        .btn-submit:active { transform: translateY(0); }

        .signup-note {
            text-align: center; font-size: 13px;
            color: var(--text-light); margin-top: 18px;
        }
        .signup-note a {
            color: var(--teal-mid); font-weight: 700; text-decoration: none;
        }
        .signup-note a:hover { text-decoration: underline; }

        /* Responsive */
        @media (max-width: 900px) {
            .page-wrapper { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 32px 5%; }
        }
        @media (max-width: 480px) {
            .login-card { padding: 32px 22px; }
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
                    <h2>Welcome back to <span>SwiftCare</span></h2>
                    <p>Log in to connect with verified caregivers or manage your bookings all in one place.</p>

                    <p class="left-signup-prompt">
                        Don't have an account? <a href="SignUp.aspx">Sign Up</a>
                    </p>
                </div>
            </div>

            <!-- RIGHT PANEL — LOGIN FORM -->
            <div class="right-panel">
                <div class="login-card">
                    <div class="card-title">Log in to your account</div>
                    <div class="card-sub">Enter your credentials to continue.</div>

                    <!-- Server message -->
                    <asp:Label ID="lblMessage" runat="server" CssClass="server-msg" />

                    <!-- Email -->
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input"
                            TextMode="Email" placeholder="you@email.com" MaxLength="150" />
                        <span class="error-msg" id="errEmail">Please enter a valid email.</span>
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input"
                            TextMode="Password" placeholder="Enter your password" MaxLength="50" />
                        <span class="error-msg" id="errPassword">Please enter your password.</span>
                    </div>

                    <!-- Forgot Password -->
                    <div class="forgot-row">
                        <a href="#" class="forgot-link">Forgot password?</a>
                    </div>

                    <!-- Submit -->
                    <asp:Button ID="btnLogin" runat="server" Text="Log In"
                        CssClass="btn-submit" OnClick="btnLogin_Click"
                        OnClientClick="return validateForm();" />

                </div>
            </div>

        </div>

        <script>
            // Client-side validation
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

                check('<%= txtEmail.ClientID %>', 'errEmail', function (v) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v); });
                check('<%= txtPassword.ClientID %>', 'errPassword', function (v) { return v.trim().length > 0; });

                return valid;
            }
        </script>

    </form>
</body>
</html>
