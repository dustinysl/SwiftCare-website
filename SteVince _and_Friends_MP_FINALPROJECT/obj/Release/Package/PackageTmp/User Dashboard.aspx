<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="User Dashboard.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.User_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare — User Dashboard</title>
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
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 10px; color: rgba(255,255,255,0.6); font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-bottom: 3px; border: none; background: none; width: 100%; text-align: left; }
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

        /* Panels */
        .panel { display: none; animation: panelIn 0.4s ease; }
        .panel.active { display: block; }
        @keyframes panelIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        /* ── BROWSE — SEARCH BAR ── */
        .search-bar { display: flex; gap: 12px; margin-bottom: 24px; flex-wrap: wrap; }
        .search-input { flex: 1; min-width: 200px; padding: 11px 16px; border: 2px solid #e8f4f8; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 14px; outline: none; background: white; transition: all 0.25s; }
        .search-input:focus { border-color: var(--teal-bright); box-shadow: 0 0 0 4px rgba(38,198,218,0.1); }
        .search-select { padding: 11px 16px; border: 2px solid #e8f4f8; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 14px; outline: none; background: white; cursor: pointer; }
        .search-select:focus { border-color: var(--teal-bright); }
        .btn-search { padding: 11px 28px; background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright)); color: white; border: none; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 14px rgba(38,198,218,0.3); }
        .btn-search:hover { transform: translateY(-1px); }

        /* ── CAREGIVER LIST CARDS (Image 1 style) ── */
        .cg-list { display: flex; flex-direction: column; gap: 16px; }
        .cg-list-card {
            background: white; border-radius: var(--radius);
            border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm);
            padding: 20px 24px;
            transition: all 0.25s;
        }
        .cg-list-card:hover { box-shadow: var(--shadow-md); border-color: var(--teal-light); }

        .cg-list-top { display: flex; align-items: flex-start; gap: 18px; margin-bottom: 14px; }
        .cg-list-avatar {
            width: 80px; height: 80px; border-radius: 12px;
            background: var(--teal-pale); flex-shrink: 0;
            overflow: hidden; display: flex; align-items: center; justify-content: center;
            font-size: 36px; border: 2px solid var(--teal-light);
        }
        .cg-list-avatar img { width: 100%; height: 100%; object-fit: cover; }

        .cg-list-info { flex: 1; }
        .cg-list-name { font-family: 'Montserrat', sans-serif; font-size: 22px; font-weight: 800; color: var(--blue-dark); margin-bottom: 2px; }
        .cg-list-location { font-size: 14px; color: var(--teal-mid); font-weight: 600; margin-bottom: 6px; }
        .cg-list-stars { color: #f4a535; font-size: 18px; }

        .cg-list-rate { font-family: 'Montserrat', sans-serif; font-size: 20px; font-weight: 800; color: var(--blue-dark); white-space: nowrap; }

        .cg-list-bottom { display: flex; align-items: center; justify-content: space-between; padding-top: 12px; border-top: 1px solid #f0f8fa; }
        .cg-list-bio { font-size: 14px; color: var(--text-light); font-style: italic; flex: 1; }
        .cg-list-review { display: flex; align-items: center; gap: 10px; flex: 1; }
        .cg-review-avatar { width: 32px; height: 32px; border-radius: 50%; background: var(--teal-pale); display: flex; align-items: center; justify-content: center; font-size: 14px; flex-shrink: 0; border: 2px solid var(--teal-light); }
        .cg-review-text { font-size: 13px; color: var(--text-mid); font-style: italic; }

        .btn-contact {
            padding: 11px 28px; border-radius: 50px;
            background: var(--blue-dark); color: white;
            font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 700;
            border: none; cursor: pointer; transition: all 0.25s;
            white-space: nowrap; margin-left: 16px;
        }
        .btn-contact:hover { background: var(--teal-dark); transform: translateY(-1px); box-shadow: 0 4px 14px rgba(10,42,74,0.3); }

        /* ── CAREGIVER DETAIL MODAL (Image 2 style) ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(6,32,53,0.55); z-index: 200;
            align-items: center; justify-content: center;
            backdrop-filter: blur(4px);
        }
        .modal-overlay.open { display: flex; }

        .modal-box {
            background: var(--off-white); border-radius: 20px;
            width: 90%; max-width: 860px; max-height: 90vh;
            overflow-y: auto; box-shadow: var(--shadow-lg);
            animation: modalIn 0.35s ease;
        }
        @keyframes modalIn { from { opacity:0; transform:scale(0.96) translateY(16px); } to { opacity:1; transform:scale(1) translateY(0); } }

        .modal-header { display: flex; justify-content: flex-end; padding: 16px 20px 0; }
        .modal-close { background: none; border: none; font-size: 22px; cursor: pointer; color: var(--text-light); transition: color 0.2s; }
        .modal-close:hover { color: var(--error); }

        .modal-body { padding: 0 28px 32px; display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }

        /* Left column */
        .modal-left {}
        .modal-profile-card { background: white; border-radius: var(--radius); padding: 22px; border: 1px solid #e8f4f8; margin-bottom: 16px; }
        .modal-profile-top { display: flex; align-items: center; gap: 16px; margin-bottom: 16px; }
        .modal-avatar { width: 80px; height: 80px; border-radius: 12px; background: var(--teal-pale); overflow: hidden; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 36px; }
        .modal-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .modal-name { font-family: 'Montserrat', sans-serif; font-size: 22px; font-weight: 800; color: var(--blue-dark); }
        .modal-location { font-size: 14px; color: var(--teal-mid); font-weight: 600; margin: 2px 0; }
        .modal-phone { font-size: 14px; color: var(--text-mid); font-weight: 600; display: flex; align-items: center; gap: 6px; }

        .modal-services { display: flex; flex-wrap: wrap; gap: 8px; margin: 14px 0; }
        .service-tag { padding: 5px 14px; border-radius: 50px; border: 1.5px solid var(--blue-dark); color: var(--blue-dark); font-size: 12px; font-weight: 700; background: transparent; }

        .modal-rate-row { display: flex; align-items: center; gap: 16px; margin-top: 14px; }
        .modal-rate { font-family: 'Montserrat', sans-serif; font-size: 26px; font-weight: 800; color: var(--blue-dark); }
        .btn-book-now { padding: 13px 32px; background: var(--blue-dark); color: white; border: none; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 15px; font-weight: 800; cursor: pointer; transition: all 0.25s; }
        .btn-book-now:hover { background: var(--teal-dark); transform: translateY(-1px); }

        /* Calendar */
        .modal-calendar-card { background: white; border-radius: var(--radius); overflow: hidden; border: 1px solid #e8f4f8; }
        .cal-header { background: var(--blue-dark); display: grid; grid-template-columns: repeat(7, 1fr); }
        .cal-day-label { text-align: center; padding: 10px 4px; font-size: 11px; font-weight: 800; color: white; text-transform: uppercase; }
        .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; padding: 8px; background: white; }
        .cal-cell { aspect-ratio: 1; display: flex; align-items: center; justify-content: center; border-radius: 8px; font-size: 12px; font-weight: 600; color: var(--text-light); }
        .cal-cell.available { background: #4caf50; color: white; font-weight: 800; }
        .cal-cell.empty { background: transparent; }

        /* Right column */
        .modal-right {}
        .modal-section-card { background: white; border-radius: var(--radius); padding: 22px; border: 1px solid #e8f4f8; margin-bottom: 16px; }
        .modal-section-title { font-family: 'Montserrat', sans-serif; font-size: 18px; font-weight: 800; color: var(--blue-dark); margin-bottom: 10px; }
        .modal-about-text { font-size: 14px; color: var(--text-mid); line-height: 1.75; }

        .modal-credentials { display: grid; grid-template-columns: 1fr auto; gap: 16px; align-items: start; }
        .cred-list { list-style: none; }
        .cred-list li { font-size: 13px; color: var(--text-mid); font-weight: 600; padding: 3px 0; display: flex; align-items: center; gap: 8px; }
        .cred-list li::before { content: '•'; color: var(--teal-mid); font-size: 16px; }

        .often-rehired { background: #fff3f3; border-radius: 10px; padding: 12px 14px; text-align: center; border: 1px solid #ffd0d0; }
        .rehired-heart { font-size: 22px; }
        .rehired-label { font-size: 12px; font-weight: 800; color: #c62828; margin: 4px 0 2px; }
        .rehired-sub { font-size: 11px; color: #c62828; }

        /* Reviews */
        .modal-rating-row { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; }
        .modal-rating-num { font-family: 'Montserrat', sans-serif; font-size: 40px; font-weight: 800; color: var(--blue-dark); }
        .modal-rating-stars { color: #f4a535; font-size: 22px; }

        .review-item { display: flex; gap: 12px; margin-bottom: 14px; padding-bottom: 14px; border-bottom: 1px solid #f0f8fa; }
        .review-item:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .review-user-icon { width: 36px; height: 36px; border-radius: 50%; background: var(--teal-pale); display: flex; align-items: center; justify-content: center; font-size: 16px; flex-shrink: 0; border: 2px solid var(--teal-light); }
        .review-comment { font-size: 13px; color: var(--text-mid); line-height: 1.6; }

        /* Empty state */
        .empty-state { text-align: center; padding: 48px 20px; color: var(--text-light); }
        .empty-icon { font-size: 48px; margin-bottom: 12px; opacity: 0.5; }
        .empty-text { font-size: 15px; font-weight: 600; }

        /* ── BOOKINGS ── */
        .bookings-filter { display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap; }
        .filter-pill { padding: 7px 18px; border-radius: 50px; border: 2px solid #e8f4f8; background: white; font-family: 'Nunito', sans-serif; font-size: 13px; font-weight: 700; color: var(--text-light); cursor: pointer; transition: all 0.2s; }
        .filter-pill.active, .filter-pill:hover { border-color: var(--teal-mid); background: var(--teal-pale); color: var(--teal-dark); }
        .section-card { background: white; border-radius: var(--radius); border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm); margin-bottom: 24px; overflow: hidden; }
        .booking-table { width: 100%; border-collapse: collapse; }
        .booking-table th { text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--text-light); padding: 0 16px 12px; border-bottom: 2px solid #f0f8fa; }
        .booking-table td { padding: 14px 16px; font-size: 14px; color: var(--text-mid); border-bottom: 1px solid #f5fbfc; }
        .booking-table tr:last-child td { border-bottom: none; }
        .booking-table tr:hover td { background: #fafeff; }
        .client-cell { display: flex; align-items: center; gap: 10px; }
        .client-avatar { width: 34px; height: 34px; border-radius: 50%; background: var(--teal-pale); display: flex; align-items: center; justify-content: center; font-size: 15px; flex-shrink: 0; }
        .client-name { font-weight: 700; color: var(--text-dark); font-size: 14px; }
        .client-loc { font-size: 12px; color: var(--text-light); }
        .status-pill { display: inline-block; padding: 4px 12px; border-radius: 50px; font-size: 12px; font-weight: 700; }
        .status-pill.pending   { background: #fff8e1; color: #f57c00; }
        .status-pill.confirmed { background: #e0f7fa; color: var(--teal-dark); }
        .status-pill.completed { background: #e8f5e9; color: #2e7d32; }
        .status-pill.cancelled { background: #fdecea; color: var(--error); }

        /* ── PROFILE ── */
        .profile-hero { background: linear-gradient(135deg, var(--blue-dark) 0%, var(--teal-dark) 100%); border-radius: var(--radius); padding: 32px 28px; display: flex; align-items: center; gap: 28px; margin-bottom: 24px; position: relative; overflow: hidden; }
        .profile-hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 60% 80% at 90% 50%, rgba(38,198,218,0.15) 0%, transparent 65%); }
        .profile-avatar-lg { width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright)); display: flex; align-items: center; justify-content: center; font-size: 42px; flex-shrink: 0; border: 3px solid rgba(38,198,218,0.5); position: relative; z-index: 1; }
        .profile-hero-info { position: relative; z-index: 1; }
        .profile-hero-name { font-family: 'Montserrat', sans-serif; font-size: 24px; font-weight: 800; color: white; margin-bottom: 4px; }
        .profile-hero-sub { font-size: 14px; color: rgba(255,255,255,0.65); margin-bottom: 12px; }
        .profile-status-badge { display: inline-flex; align-items: center; gap: 7px; background: rgba(38,198,218,0.2); border: 1px solid rgba(38,198,218,0.4); color: var(--teal-light); padding: 5px 14px; border-radius: 50px; font-size: 13px; font-weight: 700; }
        .status-dot { width: 7px; height: 7px; border-radius: 50%; background: var(--teal-bright); animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.4;transform:scale(1.4);} }
        .section-card-header { padding: 20px 28px 16px; border-bottom: 1px solid #f0f8fa; display: flex; align-items: center; justify-content: space-between; }
        .section-card-title { font-family: 'Montserrat', sans-serif; font-size: 16px; font-weight: 800; color: var(--text-dark); }
        .section-card-body { padding: 24px 28px; }
        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-label { font-size: 13px; font-weight: 700; color: var(--text-mid); letter-spacing: 0.3px; }
        .form-input { width: 100%; padding: 11px 14px; border: 2px solid #e8f4f8; border-radius: 10px; font-family: 'Nunito', sans-serif; font-size: 14px; color: var(--text-dark); background: #f8fdff; outline: none; transition: all 0.25s; }
        .form-input:focus { border-color: var(--teal-bright); background: white; box-shadow: 0 0 0 4px rgba(38,198,218,0.1); }
        .form-input[readonly] { background: var(--off-white); cursor: default; }
        .btn-save { display: inline-flex; align-items: center; gap: 8px; background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright)); color: white; border: none; border-radius: 10px; font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 800; padding: 12px 28px; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 14px rgba(38,198,218,0.3); }
        .btn-save:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(38,198,218,0.45); }
        .server-msg { font-size: 13px; font-weight: 700; color: var(--teal-dark); margin-left: 14px; }

        /* Toast */
        .toast { position: fixed; bottom: 28px; right: 28px; background: var(--blue-dark); color: white; padding: 14px 22px; border-radius: 12px; font-size: 14px; font-weight: 600; box-shadow: var(--shadow-lg); display: flex; align-items: center; gap: 10px; transform: translateY(80px); opacity: 0; transition: all 0.4s cubic-bezier(0.34,1.56,0.64,1); z-index: 999; }
        .toast.show { transform: translateY(0); opacity: 1; }

        @media (max-width: 900px) { .modal-body { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main { margin-left: 0; } .form-grid-2 { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- SIDEBAR -->
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
                <button type="button" class="nav-item active" onclick="showPanel('browse')">
                    <span class="nav-icon">🔍</span> Browse Caregivers
                </button>
                <button type="button" class="nav-item" onclick="showPanel('bookings')">
                    <span class="nav-icon">📅</span> My Bookings
                </button>
                <button type="button" class="nav-item" onclick="showPanel('profile')">
                    <span class="nav-icon">👤</span> My Profile
                </button>
            </nav>
            <div class="sidebar-bottom">
                <asp:Button ID="btnLogout" runat="server" Text="🚪  Log Out"
                    CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </aside>

        <!-- MAIN -->
        <div class="main">
            <div class="topbar">
                <div class="topbar-title" id="topbarTitle">Browse Caregivers</div>
                <div class="topbar-greeting">
                    Good day, <span><asp:Label ID="lblGreetName" runat="server" Text="User" /></span> 👋
                </div>
            </div>

            <div class="content">

                <!-- ── BROWSE CAREGIVERS PANEL ── -->
                <div class="panel active" id="panel-browse">
                    <div class="search-bar">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search by name..." />
                        <asp:DropDownList ID="ddlService" runat="server" CssClass="search-select">
                            <asp:ListItem Value="" Text="All Services" />
                            <asp:ListItem Value="Child Care" Text="Child Care" />
                            <asp:ListItem Value="Elderly Care" Text="Elderly Care" />
                            <asp:ListItem Value="Pet Care" Text="Pet Care" />
                            <asp:ListItem Value="House Sitting" Text="House Sitting" />
                            <asp:ListItem Value="Special Needs Care" Text="Special Needs Care" />
                        </asp:DropDownList>
                        <asp:Button ID="btnSearch" runat="server" Text="Search"
                            CssClass="btn-search" OnClick="btnSearch_Click" />
                    </div>

                    <!-- Caregiver List -->
                    <div class="cg-list">
                        <asp:Repeater ID="rptCaregivers" runat="server">
                            <ItemTemplate>
                                <div class="cg-list-card">
                                    <div class="cg-list-top">
                                        <div class="cg-list-avatar">👩</div>
                                        <div class="cg-list-info">
                                            <div class="cg-list-name"><%# Eval("FullName") %></div>
                                            <div class="cg-list-location"><%# Eval("Address") %></div>
                                            <div class="cg-list-stars">★★★★★</div>
                                        </div>
                                        <div class="cg-list-rate">₱<%# String.Format("{0:N2}", Eval("HourlyRate")) %>/Hour</div>
                                    </div>
                                    <div class="cg-list-bottom">
                                        <div class="cg-list-bio"><%# Eval("ShortBio") %></div>
                                        <button type="button" class="btn-contact"
                                            onclick="openModal(
                                                '<%# Eval("CaregiverID") %>',
                                                '<%# Eval("FullName") %>',
                                                '<%# Eval("Address") %>',
                                                '<%# Eval("ContactNo") %>',
                                                '<%# Eval("ServicesOffered") %>',
                                                '<%# String.Format("{0:N2}", Eval("HourlyRate")) %>',
                                                '<%# Eval("Bio") %>',
                                                '<%# Eval("AvailabilityStatus") %>',
                                                '<%# Eval("AvailableDays") %>'
                                            )">
                                            Contact
                                        </button>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <asp:Panel ID="pnlNoCaregivers" runat="server" Visible="false">
                        <div class="empty-state">
                            <div class="empty-icon">🔍</div>
                            <div class="empty-text">No caregivers found. Try a different search.</div>
                        </div>
                    </asp:Panel>
                </div>

                <!-- ── MY BOOKINGS PANEL ── -->
                <div class="panel" id="panel-bookings">
                    <div class="bookings-filter">
                        <button type="button" class="filter-pill active" onclick="filterBookings(this,'all')">All</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'pending')">Pending</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'confirmed')">Confirmed</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'completed')">Completed</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'cancelled')">Cancelled</button>
                    </div>
                    <div class="section-card">
                        <div style="padding:0;">
                            <table class="booking-table">
                                <thead>
                                    <tr>
                                        <th style="padding:16px 16px 12px;">Caregiver</th>
                                        <th style="padding:16px 16px 12px;">Service</th>
                                        <th style="padding:16px 16px 12px;">Date &amp; Time</th>
                                        <th style="padding:16px 16px 12px;">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptBookings" runat="server">
                                        <ItemTemplate>
                                            <tr class="booking-row" data-status="<%# Eval("StatusClass") %>">
                                                <td>
                                                    <div class="client-cell">
                                                        <div class="client-avatar">👩</div>
                                                        <div>
                                                            <div class="client-name"><%# Eval("CaregiverName") %></div>
                                                            <div class="client-loc"><%# Eval("ServiceName") %></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%# Eval("ServiceName") %></td>
                                                <td><%# Eval("BookingDate") %><br /><small><%# Eval("StartTime") %> – <%# Eval("EndTime") %></small></td>
                                                <td><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("Status") %></span></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoBookings" runat="server" Visible="true">
                                <div class="empty-state">
                                    <div class="empty-icon">📭</div>
                                    <div class="empty-text">No bookings found.</div>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- ── MY PROFILE PANEL ── -->
                <div class="panel" id="panel-profile">
                    <div class="profile-hero">
                        <div class="profile-avatar-lg">👤</div>
                        <div class="profile-hero-info">
                            <div class="profile-hero-name"><asp:Label ID="lblProfileName" runat="server" Text="Your Name" /></div>
                            <div class="profile-hero-sub">User · SwiftCare</div>
                            <div class="profile-status-badge"><div class="status-dot"></div> Active Account</div>
                        </div>
                    </div>
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">Personal Information</div>
                        </div>
                        <div class="section-card-body">
                            <div class="form-grid-2" style="margin-bottom:18px;">
                                <div class="form-group">
                                    <label class="form-label">First Name</label>
                                    <asp:TextBox ID="txtProfileFirstName" runat="server" CssClass="form-input" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Last Name</label>
                                    <asp:TextBox ID="txtProfileLastName" runat="server" CssClass="form-input" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Email Address</label>
                                    <asp:TextBox ID="txtProfileEmail" runat="server" CssClass="form-input" TextMode="Email" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Contact Number</label>
                                    <asp:TextBox ID="txtProfileContact" runat="server" CssClass="form-input" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Gender</label>
                                    <asp:TextBox ID="txtProfileGender" runat="server" CssClass="form-input" ReadOnly="true" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Birthdate</label>
                                    <asp:TextBox ID="txtProfileBirthdate" runat="server" CssClass="form-input" ReadOnly="true" />
                                </div>
                                <div class="form-group full">
                                    <label class="form-label">Address</label>
                                    <asp:TextBox ID="txtProfileAddress" runat="server" CssClass="form-input" />
                                </div>
                            </div>
                            <asp:Button ID="btnSaveProfile" runat="server" Text="💾  Save Profile"
                                CssClass="btn-save" OnClick="btnSaveProfile_Click" />
                            <asp:Label ID="lblProfileMsg" runat="server" CssClass="server-msg" />
                        </div>
                    </div>
                </div>

            </div><!-- /content -->
        </div><!-- /main -->

        <!-- ── CAREGIVER DETAIL MODAL ── -->
        <div class="modal-overlay" id="cgModal">
            <div class="modal-box">
                <div class="modal-header">
                    <button type="button" class="modal-close" onclick="closeModal()">✕</button>
                </div>
                <div class="modal-body">

                    <!-- LEFT -->
                    <div class="modal-left">
                        <div class="modal-profile-card">
                            <div class="modal-profile-top">
                                <div class="modal-avatar">👩</div>
                                <div>
                                    <div class="modal-name" id="mdName"></div>
                                    <div class="modal-location" id="mdLocation"></div>
                                    <div class="modal-phone">📞 <span id="mdPhone"></span></div>
                                </div>
                            </div>
                            <div class="modal-services" id="mdServices"></div>
                            <div class="modal-rate-row">
                                <div class="modal-rate" id="mdRate"></div>
                                <button type="button" class="btn-book-now" onclick="goToBooking()">Book Now</button>
                            </div>
                        </div>

                        <!-- Availability Calendar -->
                        <div class="modal-calendar-card">
                            <div class="cal-header">
                                <div class="cal-day-label">M</div>
                                <div class="cal-day-label">T</div>
                                <div class="cal-day-label">W</div>
                                <div class="cal-day-label">Th</div>
                                <div class="cal-day-label">F</div>
                                <div class="cal-day-label">S</div>
                                <div class="cal-day-label">Sun</div>
                            </div>
                            <div class="cal-grid" id="mdCalendar"></div>
                        </div>
                    </div>

                    <!-- RIGHT -->
                    <div class="modal-right">
                        <div class="modal-section-card">
                            <div class="modal-section-title">About Me</div>
                            <div class="modal-about-text" id="mdAbout"></div>
                        </div>

                        <div class="modal-section-card">
                            <div class="modal-section-title">Services Offered</div>
                            <div class="modal-credentials">
                                <ul class="cred-list" id="mdCredList"></ul>
                                <div class="often-rehired" id="mdRehired" style="display:none;">
                                    <div class="rehired-heart">❤️</div>
                                    <div class="rehired-label">Often Rehired</div>
                                    <div class="rehired-sub" id="mdRehiredSub"></div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-section-card">
                            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                                <div class="modal-section-title" style="margin-bottom:0;">Reviews</div>
                            </div>
                            <div class="modal-rating-row">
                                <div class="modal-rating-num" id="mdRatingNum">—</div>
                                <div class="modal-rating-stars">★★★★★</div>
                            </div>
                            <div id="mdReviews"></div>
                        </div>

                    </div>

                </div>
            </div>
        </div>

        <!-- Toast -->
        <div class="toast" id="toast">
            <span>✅</span>
            <span id="toastMsg">Saved!</span>
        </div>

        <script>
            function goToBooking() {
                var cgID = document.getElementById('cgModal').dataset.cgId;
                window.location.href = 'Bookings.aspx?cgID=' + cgID;
            }
            // Panel switching
            function showPanel(name) {
                document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                document.getElementById('panel-' + name).classList.add('active');
                var labels = { browse: 'Browse Caregivers', bookings: 'My Bookings', profile: 'My Profile' };
                document.getElementById('topbarTitle').textContent = labels[name] || name;
                document.querySelectorAll('.nav-item').forEach(function (el) {
                    if (el.getAttribute('onclick') && el.getAttribute('onclick').includes("'" + name + "'"))
                        el.classList.add('active');
                });
            }

            // Filter bookings
            function filterBookings(btn, status) {
                document.querySelectorAll('.bookings-filter .filter-pill').forEach(p => p.classList.remove('active'));
                btn.classList.add('active');
                document.querySelectorAll('.booking-row').forEach(function (row) {
                    row.style.display = (status === 'all' || row.dataset.status === status) ? '' : 'none';
                });
            }

            // Open caregiver detail modal
            function openModal(id, name, location, phone, services, rate, bio, availStatus, availDays) {
                document.getElementById('mdName').textContent = name;
                document.getElementById('mdLocation').textContent = location;
                document.getElementById('mdPhone').textContent = phone;
                document.getElementById('mdRate').textContent = '₱' + parseFloat(rate).toFixed(2) + '/Hour';

                // About Me — from Bio column
                document.getElementById('mdAbout').textContent = (bio && bio.trim() !== '') ? bio : 'No bio provided yet.';

                // Services as tags
                var svcWrap = document.getElementById('mdServices');
                svcWrap.innerHTML = '';
                (services || '').split(',').forEach(function (s) {
                    if (s.trim()) {
                        var tag = document.createElement('span');
                        tag.className = 'service-tag';
                        tag.textContent = s.trim();
                        svcWrap.appendChild(tag);
                    }
                });

                // Services in credentials list
                var credList = document.getElementById('mdCredList');
                credList.innerHTML = '';
                (services || '').split(',').forEach(function (s) {
                    if (s.trim()) {
                        var li = document.createElement('li');
                        li.textContent = s.trim();
                        credList.appendChild(li);
                    }
                });

                // Availability status
                var rehired = document.getElementById('mdRehired');
                if (availStatus === 'Available') {
                    rehired.style.display = 'none';
                } else {
                    rehired.style.display = 'block';
                    document.getElementById('mdRehiredSub').textContent = 'Currently ' + availStatus;
                }

                // Build calendar using actual available days
                buildCalendar(availDays);

                // Reviews placeholder
                document.getElementById('mdRatingNum').textContent = '—';
                document.getElementById('mdReviews').innerHTML =
                    '<div class="review-item"><div class="review-user-icon">👤</div><div class="review-comment">No reviews yet.</div></div>';

                document.getElementById('cgModal').classList.add('open');
                document.getElementById('cgModal').dataset.cgId = id;
            }

            function closeModal() {
                document.getElementById('cgModal').classList.remove('open');
            }

            // Close modal on overlay click
            document.getElementById('cgModal').addEventListener('click', function (e) {
                if (e.target === this) closeModal();
            });

            // Build calendar — availDays is a comma-separated string of day numbers
            // Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6, Sun=0 (JS getDay())
            function buildCalendar(availDays) {
                var cal = document.getElementById('mdCalendar');
                cal.innerHTML = '';
                var now = new Date();
                var year = now.getFullYear();
                var month = now.getMonth();
                var firstDay = new Date(year, month, 1).getDay(); // 0=Sun
                var startOffset = (firstDay === 0) ? 6 : firstDay - 1;
                var daysInMonth = new Date(year, month + 1, 0).getDate();

                // Parse available days — e.g. "1,3,4,0" = Mon,Wed,Thu,Sun
                var dayNums = [];
                if (availDays) {
                    availDays.toString().split(',').forEach(function(d) {
                        var n = parseInt(d.trim());
                        if (!isNaN(n)) dayNums.push(n);
                    });
                }

                // Empty offset cells
                for (var i = 0; i < startOffset; i++) {
                    var empty = document.createElement('div');
                    empty.className = 'cal-cell empty';
                    cal.appendChild(empty);
                }

                for (var d = 1; d <= daysInMonth; d++) {
                    var cell = document.createElement('div');
                    cell.className = 'cal-cell';
                    cell.textContent = d;
                    // Get day of week for this date (0=Sun,1=Mon,...6=Sat)
                    var dayOfWeek = new Date(year, month, d).getDay();
                    if (dayNums.length === 0 || dayNums.indexOf(dayOfWeek) !== -1) {
                        cell.classList.add('available');
                    }
                    cal.appendChild(cell);
                }
            }

            // Toast
            function showToast(msg) {
                var t = document.getElementById('toast');
                document.getElementById('toastMsg').textContent = msg;
                t.classList.add('show');
                setTimeout(function () { t.classList.remove('show'); }, 3000);
            }

            var serverMsg = '<%= lblProfileMsg.Text %>';
            if (serverMsg && serverMsg.trim() !== '') {
                window.addEventListener('DOMContentLoaded', function () { showToast(serverMsg); });
            }
        </script>

    </form>
</body>
</html>
