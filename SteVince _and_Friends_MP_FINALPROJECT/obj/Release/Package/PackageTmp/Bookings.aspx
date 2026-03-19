<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ActiveBooking.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.ActiveBooking" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare — Book a Caregiver</title>
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
            --success:     #2e7d32;
            --radius:      14px;
            --sidebar-w:   260px;
            --shadow-sm:   0 2px 8px rgba(10,42,74,0.08);
            --shadow-md:   0 8px 32px rgba(10,42,74,0.13);
            --shadow-lg:   0 20px 60px rgba(10,42,74,0.18);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Nunito', sans-serif; background: var(--off-white); color: var(--text-dark); min-height: 100vh; display: flex; }

        /* ── SIDEBAR ── */
        .sidebar { width: var(--sidebar-w); min-height: 100vh; background: var(--blue-dark); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 50; }
        .sidebar-logo { padding: 0 24px; height: 80px; display: flex; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.07); }
        .sidebar-logo img { height: 110px; width: auto; object-fit: contain; }
        .sidebar-profile { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.07); display: flex; align-items: center; gap: 12px; }
        .profile-avatar-sm { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright)); display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; border: 2px solid rgba(38,198,218,0.4); }
        .profile-info-sm .name { font-size: 14px; font-weight: 700; color: white; }
        .profile-info-sm .role-badge { display: inline-block; font-size: 11px; font-weight: 700; background: rgba(38,198,218,0.18); border: 1px solid rgba(38,198,218,0.35); color: var(--teal-light); padding: 2px 10px; border-radius: 50px; margin-top: 3px; }
        .sidebar-nav { flex: 1; padding: 16px 12px; }
        .nav-section-label { font-size: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 1.5px; color: rgba(255,255,255,0.3); padding: 10px 10px 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 10px; color: rgba(255,255,255,0.6); font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-bottom: 3px; border: none; background: none; width: 100%; text-align: left; text-decoration: none; }
        .nav-item:hover { background: rgba(255,255,255,0.07); color: white; }
        .nav-item.active { background: linear-gradient(135deg, rgba(0,131,143,0.35), rgba(21,101,160,0.25)); color: white; border: 1px solid rgba(38,198,218,0.2); }
        .nav-item .nav-icon { font-size: 17px; width: 22px; text-align: center; flex-shrink: 0; }
        .sidebar-bottom { padding: 16px 12px; border-top: 1px solid rgba(255,255,255,0.07); }
        .btn-logout { display: flex; align-items: center; gap: 10px; width: 100%; padding: 10px 14px; border-radius: 10px; background: rgba(229,57,53,0.12); border: 1px solid rgba(229,57,53,0.2); color: #ef9a9a; font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .btn-logout:hover { background: rgba(229,57,53,0.22); color: #ff8a80; }

        /* ── MAIN ── */
        .main { margin-left: var(--sidebar-w); flex: 1; min-height: 100vh; display: flex; flex-direction: column; }
        .topbar { height: 72px; background: white; border-bottom: 1px solid #e8f4f8; display: flex; align-items: center; justify-content: space-between; padding: 0 36px; position: sticky; top: 0; z-index: 40; box-shadow: var(--shadow-sm); }
        .topbar-title { font-family: 'Montserrat', sans-serif; font-size: 20px; font-weight: 800; color: var(--text-dark); }
        .topbar-greeting { font-size: 14px; color: var(--text-light); font-weight: 600; }
        .topbar-greeting span { color: var(--teal-dark); font-weight: 800; }
        .content { padding: 32px 36px; flex: 1; }

        /* ── BOOKING LAYOUT ── */
        .booking-grid { display: grid; grid-template-columns: 1fr 380px; gap: 28px; align-items: start; }

        /* ── CAREGIVER SUMMARY CARD ── */
        .cg-summary-card {
            background: white; border-radius: var(--radius);
            border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm);
            overflow: hidden; position: sticky; top: 96px;
        }
        .cg-summary-header {
            background: linear-gradient(135deg, var(--blue-dark), var(--teal-dark));
            padding: 22px 24px;
            display: flex; align-items: center; gap: 16px;
            position: relative; overflow: hidden;
        }
        .cg-summary-header::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 80% at 90% 50%, rgba(38,198,218,0.18) 0%, transparent 65%);
        }
        .cg-avatar-lg {
            width: 72px; height: 72px; border-radius: 14px;
            background: var(--teal-pale); display: flex; align-items: center;
            justify-content: center; font-size: 32px;
            border: 2px solid rgba(38,198,218,0.45); flex-shrink: 0;
            position: relative; z-index: 1;
        }
        .cg-summary-info { position: relative; z-index: 1; }
        .cg-summary-name { font-family: 'Montserrat', sans-serif; font-size: 18px; font-weight: 800; color: white; }
        .cg-summary-loc { font-size: 13px; color: rgba(255,255,255,0.65); margin: 2px 0 8px; }
        .cg-avail-badge { display: inline-flex; align-items: center; gap: 6px; background: rgba(38,198,218,0.2); border: 1px solid rgba(38,198,218,0.4); color: var(--teal-light); padding: 3px 12px; border-radius: 50px; font-size: 12px; font-weight: 700; }
        .avail-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--teal-bright); animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.4;transform:scale(1.4);} }

        .cg-summary-body { padding: 20px 24px; }
        .cg-detail-row { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; font-size: 14px; color: var(--text-mid); font-weight: 600; }
        .cg-detail-row .detail-icon { font-size: 16px; width: 20px; text-align: center; flex-shrink: 0; }
        .cg-detail-row .detail-label { color: var(--text-light); font-weight: 600; min-width: 80px; }

        .cg-rate-box { background: var(--teal-pale); border-radius: 12px; padding: 14px 18px; display: flex; align-items: center; justify-content: space-between; border: 1px solid var(--teal-light); margin-top: 6px; }
        .cg-rate-label { font-size: 12px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; color: var(--teal-dark); }
        .cg-rate-value { font-family: 'Montserrat', sans-serif; font-size: 22px; font-weight: 800; color: var(--blue-dark); }

        .service-tags { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 14px; }
        .service-tag { padding: 4px 12px; border-radius: 50px; border: 1.5px solid var(--blue-dark); color: var(--blue-dark); font-size: 11px; font-weight: 700; background: transparent; }

        /* ── BOOKING FORM CARD ── */
        .booking-form-card {
            background: white; border-radius: var(--radius);
            border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm);
            overflow: hidden;
        }
        .form-card-header {
            padding: 24px 28px 18px;
            border-bottom: 1px solid #f0f8fa;
            display: flex; align-items: center; gap: 14px;
        }
        .form-header-icon { font-size: 28px; }
        .form-header-title { font-family: 'Montserrat', sans-serif; font-size: 20px; font-weight: 800; color: var(--text-dark); }
        .form-header-sub { font-size: 13px; color: var(--text-light); margin-top: 2px; }

        .form-card-body { padding: 28px; }

        .form-section { margin-bottom: 28px; }
        .form-section-title {
            font-family: 'Montserrat', sans-serif; font-size: 13px; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1px; color: var(--teal-dark);
            margin-bottom: 16px; padding-bottom: 8px;
            border-bottom: 2px solid var(--teal-pale);
            display: flex; align-items: center; gap: 8px;
        }

        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-label { font-size: 13px; font-weight: 700; color: var(--text-mid); letter-spacing: 0.3px; }
        .form-label .required { color: var(--error); margin-left: 2px; }
        .form-input, .form-select {
            width: 100%; padding: 11px 14px;
            border: 2px solid #e8f4f8; border-radius: 10px;
            font-family: 'Nunito', sans-serif; font-size: 14px;
            color: var(--text-dark); background: #f8fdff;
            outline: none; transition: all 0.25s;
        }
        .form-input:focus, .form-select:focus { border-color: var(--teal-bright); background: white; box-shadow: 0 0 0 4px rgba(38,198,218,0.1); }
        .form-input[readonly] { background: #f0f8fa; cursor: default; color: var(--text-light); }
        .form-select { cursor: pointer; }

        /* Cost preview */
        .cost-preview {
            background: linear-gradient(135deg, #f8fdff, var(--teal-pale));
            border-radius: 12px; border: 1px solid var(--teal-light);
            padding: 20px 22px; margin-bottom: 24px;
        }
        .cost-row { display: flex; justify-content: space-between; align-items: center; font-size: 14px; color: var(--text-mid); font-weight: 600; margin-bottom: 8px; }
        .cost-row:last-child { margin-bottom: 0; }
        .cost-divider { border: none; border-top: 1.5px dashed var(--teal-light); margin: 12px 0; }
        .cost-total { font-family: 'Montserrat', sans-serif; font-size: 18px; font-weight: 800; color: var(--blue-dark); }
        .cost-total-label { font-family: 'Montserrat', sans-serif; font-size: 15px; font-weight: 800; color: var(--blue-dark); }

        /* Buttons */
        .btn-row { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
        .btn-confirm {
            flex: 1; padding: 14px 28px;
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright));
            color: white; border: none; border-radius: 50px;
            font-family: 'Nunito', sans-serif; font-size: 15px; font-weight: 800;
            cursor: pointer; transition: all 0.3s;
            box-shadow: 0 4px 16px rgba(38,198,218,0.35);
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-confirm:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(38,198,218,0.45); }
        .btn-back {
            padding: 14px 24px;
            background: white; color: var(--text-mid);
            border: 2px solid #e8f4f8; border-radius: 50px;
            font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 700;
            cursor: pointer; transition: all 0.2s; text-decoration: none;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-back:hover { border-color: var(--teal-bright); color: var(--teal-dark); }

        /* ── SUCCESS PANEL ── */
        .success-panel { display: none; text-align: center; padding: 48px 32px; }
        .success-panel.show { display: block; }
        .success-icon { font-size: 72px; margin-bottom: 16px; animation: bounceIn 0.6s ease; }
        @keyframes bounceIn { 0%{transform:scale(0.5);opacity:0;} 70%{transform:scale(1.1);} 100%{transform:scale(1);opacity:1;} }
        .success-title { font-family: 'Montserrat', sans-serif; font-size: 26px; font-weight: 800; color: var(--success); margin-bottom: 8px; }
        .success-sub { font-size: 15px; color: var(--text-light); margin-bottom: 8px; }
        .success-booking-id { font-family: 'Montserrat', sans-serif; font-size: 18px; font-weight: 800; color: var(--blue-dark); background: var(--teal-pale); display: inline-block; padding: 6px 22px; border-radius: 50px; margin: 8px 0 28px; border: 1px solid var(--teal-light); }
        .success-details { background: #f8fdff; border-radius: var(--radius); border: 1px solid #e8f4f8; padding: 20px 24px; text-align: left; margin-bottom: 28px; }
        .sdet-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #f0f8fa; font-size: 14px; }
        .sdet-row:last-child { border-bottom: none; }
        .sdet-label { color: var(--text-light); font-weight: 600; }
        .sdet-value { color: var(--text-dark); font-weight: 700; }
        .btn-go-dashboard { padding: 14px 36px; background: var(--blue-dark); color: white; border: none; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 15px; font-weight: 800; cursor: pointer; transition: all 0.25s; text-decoration: none; display: inline-block; }
        .btn-go-dashboard:hover { background: var(--teal-dark); transform: translateY(-1px); }

        /* Error / validation */
        .validation-msg { font-size: 12px; color: var(--error); margin-top: 4px; font-weight: 600; display: none; }
        .form-input.error, .form-select.error { border-color: var(--error); }
        .server-msg { display: block; margin-bottom: 14px; font-size: 14px; font-weight: 700; color: var(--error); }
        .server-msg.ok { color: var(--success); }

        /* Toast */
        .toast { position: fixed; bottom: 28px; right: 28px; background: var(--blue-dark); color: white; padding: 14px 22px; border-radius: 12px; font-size: 14px; font-weight: 700; display: flex; align-items: center; gap: 10px; box-shadow: var(--shadow-md); opacity: 0; transform: translateY(16px); transition: all 0.35s; pointer-events: none; z-index: 999; }
        .toast.show { opacity: 1; transform: translateY(0); }

        @media (max-width: 1024px) { .booking-grid { grid-template-columns: 1fr; } .cg-summary-card { position: static; } }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main { margin-left: 0; } .form-grid-2 { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- ── SIDEBAR ── -->
        <aside class="sidebar">
            <div class="sidebar-logo">
                <img src="<%=ResolveUrl("~/App Data/No_Bg_Logo.png")%>" alt="SwiftCare" />
            </div>
            <div class="sidebar-profile">
                <div class="profile-avatar-sm">👤</div>
                <div class="profile-info-sm">
                    <div class="name"><asp:Label ID="lblSidebarName" runat="server" Text="User" /></div>
                    <div class="role-badge">User</div>
                </div>
            </div>
            <nav class="sidebar-nav">
                <div class="nav-section-label">Main</div>
                <a href="User Dashboard.aspx" class="nav-item">
                    <span class="nav-icon">🔍</span> Browse Caregivers
                </a>
                <a href="User Dashboard.aspx?panel=bookings" class="nav-item">
                    <span class="nav-icon">📅</span> My Bookings
                </a>
                <a href="User Dashboard.aspx?panel=profile" class="nav-item">
                    <span class="nav-icon">👤</span> My Profile
                </a>
                <div class="nav-section-label" style="margin-top:8px;">Current</div>
                <button type="button" class="nav-item active">
                    <span class="nav-icon">📋</span> Book a Caregiver
                </button>
            </nav>
            <div class="sidebar-bottom">
                <asp:Button ID="btnLogout" runat="server" Text="🚪  Log Out"
                    CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </aside>

        <!-- ── MAIN ── -->
        <div class="main">
            <div class="topbar">
                <div class="topbar-title">Book a Caregiver</div>
                <div class="topbar-greeting">
                    Good day, <span><asp:Label ID="lblGreetName" runat="server" Text="User" /></span> 👋
                </div>
            </div>

            <div class="content">

                <!-- ── BOOKING FORM (hidden after success) ── -->
                <asp:Panel ID="pnlBookingForm" runat="server">
                    <div class="booking-grid">

                        <!-- LEFT — FORM -->
                        <div class="booking-form-card">
                            <div class="form-card-header">
                                <div>
                                    <div class="form-header-title">Booking Details</div>
                                    <div class="form-header-sub">Fill in the details below to confirm your booking.</div>
                                </div>
                            </div>
                            <div class="form-card-body">

                                <asp:Label ID="lblBookingMsg" runat="server" CssClass="server-msg" />

                                <!-- SECTION: Caregiver & Service -->
                                <div class="form-section">
                                    <div class="form-section-title">Caregiver &amp; Service</div>
                                    <div class="form-grid-2">
                                        <div class="form-group">
                                            <label class="form-label">Caregiver</label>
                                            <asp:TextBox ID="txtCaregiverName" runat="server" CssClass="form-input" ReadOnly="true" />
                                            <%-- Hidden fields --%>
                                            <asp:HiddenField ID="hfCaregiverID" runat="server" />
                                            <%-- Persists the selected service across postbacks --%>
                                            <asp:HiddenField ID="hfSelectedService" runat="server" />
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Service <span class="required">*</span></label>
                                            <asp:DropDownList ID="ddlService" runat="server" CssClass="form-select"
                                                AutoPostBack="false">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <!-- SECTION: Schedule -->
                                <div class="form-section">
                                    <div class="form-section-title">Schedule</div>
                                    <div class="form-grid-2">
                                        <div class="form-group">
                                            <label class="form-label">Booking Date <span class="required">*</span></label>
                                            <asp:TextBox ID="txtBookingDate" runat="server" CssClass="form-input"
                                                TextMode="Date" />
                                        </div>
                                        <div class="form-group">
                                            <!-- spacer -->
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Start Time <span class="required">*</span></label>
                                            <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-input"
                                                TextMode="Time" />
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">End Time <span class="required">*</span></label>
                                            <asp:TextBox ID="txtEndTime" runat="server" CssClass="form-input"
                                                TextMode="Time" />
                                        </div>
                                    </div>
                                </div>

                                <!-- SECTION: Cost Preview -->
                                <div class="form-section">
                                    <div class="form-section-title">Cost Estimate</div>
                                    <div class="cost-preview">
                                        <div class="cost-row">
                                            <span>Hourly Rate</span>
                                            <span id="previewRate">₱<asp:Label ID="lblHourlyRate" runat="server" Text="0.00" /></span>
                                        </div>
                                        <div class="cost-row">
                                            <span>Duration</span>
                                            <span id="previewDuration">— hrs</span>
                                        </div>
                                        <hr class="cost-divider" />
                                        <div class="cost-row">
                                            <span class="cost-total-label">Estimated Total</span>
                                            <span class="cost-total" id="previewTotal">₱ —</span>
                                        </div>
                                        <div style="font-size:11px;color:var(--text-light);margin-top:8px;">
                                            * Estimate only. Actual charges may vary.
                                        </div>
                                    </div>
                                </div>

                                <!-- BUTTONS -->
                                <div class="btn-row">
                                    <a href="User Dashboard.aspx" class="btn-back">← Back</a>
                                    <asp:Button ID="btnConfirmBooking" runat="server" Text="Confirm Booking"
                                        CssClass="btn-confirm" OnClick="btnConfirmBooking_Click"
                                        OnClientClick="return validateAndConfirm();" />
                                </div>

                            </div>
                        </div>

                        <!-- RIGHT — CAREGIVER SUMMARY -->
                        <div class="cg-summary-card">
                            <div class="cg-summary-header">
                                <div class="cg-avatar-lg">👩</div>
                                <div class="cg-summary-info">
                                    <div class="cg-summary-name">
                                        <asp:Label ID="lblCgName" runat="server" Text="Caregiver" />
                                    </div>
                                    <div class="cg-summary-loc">
                                        <asp:Label ID="lblCgLocation" runat="server" Text="Location" />
                                    </div>
                                    <div class="cg-avail-badge">
                                        <div class="avail-dot"></div>
                                        <asp:Label ID="lblCgAvailability" runat="server" Text="Available" />
                                    </div>
                                </div>
                            </div>
                            <div class="cg-summary-body">
                                <div class="cg-detail-row">
                                    <span class="detail-label">Contact</span>
                                    <asp:Label ID="lblCgContact" runat="server" Text="N/A" />
                                </div>
                                <div class="cg-detail-row">
                                    <span class="detail-label">Address</span>
                                    <asp:Label ID="lblCgAddress" runat="server" Text="N/A" />
                                </div>
                                <div class="cg-rate-box">
                                    <div>
                                        <div class="cg-rate-label">Hourly Rate</div>
                                    </div>
                                    <div class="cg-rate-value">₱<asp:Label ID="lblCgRate" runat="server" Text="0.00" /></div>
                                </div>
                                <div class="service-tags" id="cgServiceTags">
                                    <asp:Literal ID="litServiceTags" runat="server" />
                                </div>
                            </div>
                        </div>

                    </div><!-- /booking-grid -->
                </asp:Panel>

                <!-- ── SUCCESS PANEL ── -->
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                    <div style="max-width:600px;margin:0 auto;">
                        <div class="booking-form-card" style="text-align:center;">
                            <div class="form-card-body">
                                <div class="success-panel show">
                                    <div class="success-title">Booking Confirmed!</div>
                                    <div class="success-sub">Your booking has been submitted successfully.</div>
                                    <div class="success-booking-id">
                                        Booking #<asp:Label ID="lblNewBookingID" runat="server" Text="" />
                                    </div>
                                    <div class="success-details">
                                        <div class="sdet-row">
                                            <span class="sdet-label">Caregiver</span>
                                            <span class="sdet-value"><asp:Label ID="lblSuccessCg" runat="server" /></span>
                                        </div>
                                        <div class="sdet-row">
                                            <span class="sdet-label">Service</span>
                                            <span class="sdet-value"><asp:Label ID="lblSuccessService" runat="server" /></span>
                                        </div>
                                        <div class="sdet-row">
                                            <span class="sdet-label">Date</span>
                                            <span class="sdet-value"><asp:Label ID="lblSuccessDate" runat="server" /></span>
                                        </div>
                                        <div class="sdet-row">
                                            <span class="sdet-label">Time</span>
                                            <span class="sdet-value"><asp:Label ID="lblSuccessTime" runat="server" /></span>
                                        </div>
                                        <div class="sdet-row">
                                            <span class="sdet-label">Status</span>
                                            <span class="sdet-value" style="color:#f57c00;">Pending</span>
                                        </div>
                                    </div>
                                    <a href="User Dashboard.aspx?panel=bookings" class="btn-go-dashboard">
                                        View My Bookings
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

            </div><!-- /content -->
        </div><!-- /main -->

        <!-- Toast -->
        <div class="toast" id="toast">
            <span id="toastMsg">Booking confirmed!</span>
        </div>

        <script>
            // ── Sync selected service to hidden field so it survives postback ──
            document.getElementById('<%= ddlService.ClientID %>').addEventListener('change', function () {
                document.getElementById('<%= hfSelectedService.ClientID %>').value = this.value;
            });

            // ── Cost Estimate Calculator ──
            // RateDecimal is written directly from C# as a plain number string — no HTML tags.
            var rateRaw = parseFloat('<%= RateDecimal %>') || 0;

            var startEl = document.getElementById('<%= txtStartTime.ClientID %>');
            var endEl = document.getElementById('<%= txtEndTime.ClientID %>');

            function recalc() {
                var s = startEl ? startEl.value : '';
                var e = endEl ? endEl.value : '';
                var durEl = document.getElementById('previewDuration');
                var totalEl = document.getElementById('previewTotal');
                if (!s || !e || !durEl || !totalEl) return;

                var startMins = toMins(s);
                var endMins = toMins(e);
                var diff = endMins - startMins;
                if (diff <= 0) { durEl.textContent = '— hrs'; totalEl.textContent = '₱ —'; return; }

                var hours = diff / 60;
                var total = hours * rateRaw;
                durEl.textContent = hours.toFixed(2) + ' hrs';
                totalEl.textContent = '₱ ' + total.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }

            function toMins(t) {
                var parts = t.split(':');
                return parseInt(parts[0]) * 60 + parseInt(parts[1]);
            }

            if (startEl) startEl.addEventListener('change', recalc);
            if (endEl) endEl.addEventListener('change', recalc);

            // ── Validation ──
            function validateBookingForm() {
                var ok = true;
                var svc = document.getElementById('<%= ddlService.ClientID %>');
                var date = document.getElementById('<%= txtBookingDate.ClientID %>');
                var s    = document.getElementById('<%= txtStartTime.ClientID %>');
                var e    = document.getElementById('<%= txtEndTime.ClientID %>');

                [svc, date, s, e].forEach(function(el) { if (el) el.classList.remove('error'); });

                if (svc && !svc.value)  { svc.classList.add('error');  ok = false; }
                if (!date.value)        { date.classList.add('error'); ok = false; }
                if (!s.value)           { s.classList.add('error');    ok = false; }
                if (!e.value)           { e.classList.add('error');    ok = false; }

                if (s.value && e.value) {
                    if (toMins(e.value) <= toMins(s.value)) {
                        e.classList.add('error');
                        alert('End time must be after start time.');
                        ok = false;
                    }
                }
                if (date.value) {
                    var today = new Date(); today.setHours(0,0,0,0);
                    if (new Date(date.value) < today) {
                        date.classList.add('error');
                        alert('Booking date cannot be in the past.');
                        ok = false;
                    }
                }
                return ok;
            }

            // ── Confirm popup then submit ──
            function validateAndConfirm() {
                if (!validateBookingForm()) return false;

                var svc  = document.getElementById('<%= ddlService.ClientID %>');
                var date = document.getElementById('<%= txtBookingDate.ClientID %>');
                var s    = document.getElementById('<%= txtStartTime.ClientID %>');
                var e    = document.getElementById('<%= txtEndTime.ClientID %>');
                var cgEl = document.getElementById('displayCaregiverName');

                var svcText  = svc  ? svc.options[svc.selectedIndex].text : '—';
                var dateText = date ? date.value : '—';
                var sText    = s    ? s.value    : '—';
                var eText    = e    ? e.value    : '—';
                var cgName   = cgEl ? cgEl.value : '—';

                // Calculate total for the popup
                var totalText = document.getElementById('previewTotal')
                                ? document.getElementById('previewTotal').textContent : '—';

                var msg = 'Confirm your booking:\n\n'
                        + '    Caregiver:  ' + cgName   + '\n'
                        + '    Service:    ' + svcText  + '\n'
                        + '    Date:       ' + dateText + '\n'
                        + '    Time:       ' + sText + ' – ' + eText + '\n'
                        + '    Est. Total: ' + totalText + '\n\n'
                        + 'Proceed with this booking?';

                return confirm(msg);
            }

            // ── Toast on success ──
            var serverMsg = '<%= ToastMessage %>';
            if (serverMsg && serverMsg.trim() !== '') {
                window.addEventListener('DOMContentLoaded', function () {
                    var t = document.getElementById('toast');
                    document.getElementById('toastMsg').textContent = serverMsg;
                    t.classList.add('show');
                    setTimeout(function () { t.classList.remove('show'); }, 3500);
                });
            }
        </script>

    </form>
</body>
</html>
