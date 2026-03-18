<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Caregiver Dashboard.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.Caregiver_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare — Caregiver Dashboard</title>
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
            --success:     #00838f;
            --warn:        #f57c00;
            --radius:      14px;
            --sidebar-w:   260px;
            --shadow-sm:   0 2px 8px rgba(10,42,74,0.08);
            --shadow-md:   0 8px 32px rgba(10,42,74,0.13);
            --shadow-lg:   0 20px 60px rgba(10,42,74,0.18);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body {
            font-family: 'Nunito', sans-serif;
            background: var(--off-white);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
        }

        /* ── SIDEBAR ── */
        .sidebar {
            width: var(--sidebar-w);
            min-height: 100vh;
            background: var(--blue-dark);
            display: flex; flex-direction: column;
            position: fixed; top: 0; left: 0; bottom: 0;
            z-index: 50;
            transition: transform 0.3s ease;
        }
        .sidebar-logo {
            padding: 0 24px;
            height: 80px;
            display: flex; align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-logo img { height: 110px; width: auto; object-fit: contain; }

        .sidebar-profile {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
            display: flex; align-items: center; gap: 12px;
        }
        .profile-avatar-sm {
            width: 46px; height: 46px; border-radius: 50%;
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright));
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; flex-shrink: 0;
            border: 2px solid rgba(38,198,218,0.4);
            overflow: hidden;
        }
        .profile-avatar-sm img { width: 100%; height: 100%; object-fit: cover; }
        .profile-info-sm .name { font-size: 14px; font-weight: 700; color: white; }
        .profile-info-sm .role-badge {
            display: inline-block;
            font-size: 11px; font-weight: 700;
            background: rgba(38,198,218,0.18);
            border: 1px solid rgba(38,198,218,0.35);
            color: var(--teal-light);
            padding: 2px 10px; border-radius: 50px;
            margin-top: 3px;
        }

        .sidebar-nav { flex: 1; padding: 16px 12px; }
        .nav-section-label {
            font-size: 10px; font-weight: 800; text-transform: uppercase;
            letter-spacing: 1.5px; color: rgba(255,255,255,0.3);
            padding: 10px 10px 6px;
        }
        .nav-item {
            display: flex; align-items: center; gap: 12px;
            padding: 11px 14px; border-radius: 10px;
            color: rgba(255,255,255,0.6);
            font-size: 14px; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
            margin-bottom: 3px; border: none;
            background: none; width: 100%; text-align: left;
            text-decoration: none;
        }
        .nav-item:hover { background: rgba(255,255,255,0.07); color: white; }
        .nav-item.active {
            background: linear-gradient(135deg, rgba(0,131,143,0.35), rgba(21,101,160,0.25));
            color: white;
            border: 1px solid rgba(38,198,218,0.2);
        }
        .nav-item .nav-icon { font-size: 17px; width: 22px; text-align: center; flex-shrink: 0; }

        .sidebar-bottom {
            padding: 16px 12px;
            border-top: 1px solid rgba(255,255,255,0.07);
        }
        .btn-logout {
            display: flex; align-items: center; gap: 10px;
            width: 100%; padding: 10px 14px; border-radius: 10px;
            background: rgba(229,57,53,0.12); border: 1px solid rgba(229,57,53,0.2);
            color: #ef9a9a; font-family: 'Nunito', sans-serif;
            font-size: 14px; font-weight: 700; cursor: pointer;
            transition: all 0.2s;
        }
        .btn-logout:hover { background: rgba(229,57,53,0.22); color: #ff8a80; }

        /* ── MAIN CONTENT ── */
        .main {
            margin-left: var(--sidebar-w);
            flex: 1; min-height: 100vh;
            display: flex; flex-direction: column;
        }

        /* Top bar */
        .topbar {
            height: 72px; background: white;
            border-bottom: 1px solid #e8f4f8;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 36px;
            position: sticky; top: 0; z-index: 40;
            box-shadow: var(--shadow-sm);
        }
        .topbar-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 20px; font-weight: 800; color: var(--text-dark);
        }
        .topbar-right { display: flex; align-items: center; gap: 14px; }
        .topbar-notif {
            width: 38px; height: 38px; border-radius: 10px;
            background: var(--off-white); border: 1px solid #e8f4f8;
            display: flex; align-items: center; justify-content: center;
            font-size: 17px; cursor: pointer; transition: all 0.2s; position: relative;
        }
        .topbar-notif:hover { background: var(--teal-pale); }
        .notif-dot {
            position: absolute; top: 6px; right: 6px;
            width: 8px; height: 8px; border-radius: 50%;
            background: var(--teal-bright); border: 2px solid white;
        }
        .topbar-greeting { font-size: 14px; color: var(--text-light); font-weight: 600; }
        .topbar-greeting span { color: var(--teal-dark); font-weight: 800; }

        /* Page content */
        .content { padding: 32px 36px; flex: 1; display: flex; flex-direction: column; align-items: center; }

        /* Panels — only one visible at a time */
        .panel { display: none; animation: panelIn 0.4s ease; width: 100%; max-width: 900px; }
        .panel.active { display: block; }
        @keyframes panelIn {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── STATS ROW ── */
        .stats-row {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 18px; margin-bottom: 28px; width: 100%;
        }
        .stat-card {
            background: white; border-radius: var(--radius);
            padding: 22px 20px;
            border: 1px solid #e8f4f8;
            box-shadow: var(--shadow-sm);
            display: flex; align-items: center; gap: 16px;
        }
        .stat-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; flex-shrink: 0;
        }
        .stat-icon.teal  { background: var(--teal-pale); }
        .stat-icon.blue  { background: #e3f2fd; }
        .stat-icon.green { background: #e8f5e9; }
        .stat-icon.amber { background: #fff8e1; }
        .stat-val { font-family: 'Montserrat', sans-serif; font-size: 26px; font-weight: 800; color: var(--text-dark); line-height: 1; }
        .stat-label { font-size: 12px; color: var(--text-light); font-weight: 600; margin-top: 3px; }

        /* ── SECTION CARDS ── */
        .section-card {
            background: white; border-radius: var(--radius);
            border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm);
            margin-bottom: 24px; overflow: hidden;
        }
        .section-card-header {
            padding: 20px 28px 16px;
            border-bottom: 1px solid #f0f8fa;
            display: flex; align-items: center; justify-content: space-between;
        }
        .section-card-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 16px; font-weight: 800; color: var(--text-dark);
        }
        .section-card-body { padding: 24px 28px; }

        /* ── PROFILE PANEL ── */
        .profile-hero {
            background: linear-gradient(135deg, var(--blue-dark) 0%, var(--teal-dark) 100%);
            border-radius: var(--radius); padding: 32px 28px;
            display: flex; align-items: center; gap: 28px;
            margin-bottom: 24px; position: relative; overflow: hidden;
        }
        .profile-hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 80% at 90% 50%, rgba(38,198,218,0.15) 0%, transparent 65%);
        }
        .profile-avatar-lg {
            width: 100px; height: 100px; border-radius: 50%;
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright));
            display: flex; align-items: center; justify-content: center;
            font-size: 42px; flex-shrink: 0;
            border: 3px solid rgba(38,198,218,0.5);
            position: relative; z-index: 1; overflow: hidden;
        }
        .profile-avatar-lg img { width: 100%; height: 100%; object-fit: cover; }
        .profile-hero-info { position: relative; z-index: 1; }
        .profile-hero-name {
            font-family: 'Montserrat', sans-serif;
            font-size: 24px; font-weight: 800; color: white; margin-bottom: 4px;
        }
        .profile-hero-sub { font-size: 14px; color: rgba(255,255,255,0.65); margin-bottom: 12px; }
        .profile-status-badge {
            display: inline-flex; align-items: center; gap: 7px;
            background: rgba(38,198,218,0.2); border: 1px solid rgba(38,198,218,0.4);
            color: var(--teal-light); padding: 5px 14px; border-radius: 50px;
            font-size: 13px; font-weight: 700;
        }
        .status-dot { width: 7px; height: 7px; border-radius: 50%; background: var(--teal-bright); animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.4;transform:scale(1.4);} }

        /* Form grid */
        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-label { font-size: 13px; font-weight: 700; color: var(--text-mid); letter-spacing: 0.3px; }
        .form-input, .form-select, .form-textarea {
            width: 100%; padding: 11px 14px;
            border: 2px solid #e8f4f8; border-radius: 10px;
            font-family: 'Nunito', sans-serif; font-size: 14px; color: var(--text-dark);
            background: #f8fdff; outline: none; transition: all 0.25s;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: var(--teal-bright); background: white;
            box-shadow: 0 0 0 4px rgba(38,198,218,0.1);
        }
        .form-textarea { resize: vertical; min-height: 90px; }
        .form-select { cursor: pointer; }

        /* Services checkboxes */
        .services-grid {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px;
        }
        .service-check {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 14px; border-radius: 10px;
            border: 2px solid #e8f4f8; background: #f8fdff;
            cursor: pointer; transition: all 0.2s; user-select: none;
        }
        .service-check .check-box {
            width: 20px; height: 20px; border-radius: 6px;
            border: 2px solid #c5d8e0; background: white;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 12px; transition: all 0.2s;
            color: transparent;
        }
        .service-check.checked { border-color: var(--teal-mid); background: var(--teal-pale); }
        .service-check.checked .check-box { background: var(--teal-mid); border-color: var(--teal-mid); color: white; }
        .service-check-label { font-size: 13px; font-weight: 700; color: var(--text-mid); }
        .service-check.checked .service-check-label { color: var(--teal-dark); }
        .service-emoji { font-size: 16px; }

        /* Save button */
        .btn-save {
            display: inline-flex; align-items: center; gap: 8px;
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright));
            color: white; border: none; border-radius: 10px;
            font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 800;
            padding: 12px 28px; cursor: pointer; transition: all 0.3s;
            box-shadow: 0 4px 14px rgba(38,198,218,0.3);
        }
        .btn-save:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(38,198,218,0.45); }

        /* ── BOOKINGS PANEL ── */
        .bookings-filter {
            display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap;
        }
        .filter-pill {
            padding: 7px 18px; border-radius: 50px;
            border: 2px solid #e8f4f8; background: white;
            font-family: 'Nunito', sans-serif; font-size: 13px; font-weight: 700;
            color: var(--text-light); cursor: pointer; transition: all 0.2s;
        }
        .filter-pill.active, .filter-pill:hover {
            border-color: var(--teal-mid); background: var(--teal-pale); color: var(--teal-dark);
        }

        .booking-table { width: 100%; border-collapse: collapse; }
        .booking-table th {
            text-align: left; font-size: 11px; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--text-light); padding: 16px 16px;
            border-bottom: 2px solid #f0f8fa;
            vertical-align: middle;
        }
        .booking-table td {
            padding: 14px 18px; font-size: 14px; color: var(--text-mid);
            border-bottom: 1px solid #f5fbfc;
        }
        .booking-table tr:last-child td { border-bottom: none; }
        .booking-table tr:hover td { background: #fafeff; }

        .client-cell { display: flex; align-items: center; gap: 10px; }
        .client-avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: var(--teal-pale);
            display: flex; align-items: center; justify-content: center;
            font-size: 15px; flex-shrink: 0;
        }
        .client-name { font-weight: 700; color: var(--text-dark); font-size: 14px; }
        .client-loc { font-size: 12px; color: var(--text-light); }

        .status-pill {
            display: inline-block; padding: 4px 12px; border-radius: 50px;
            font-size: 12px; font-weight: 700;
        }
        .status-pill.pending  { background: #fff8e1; color: #f57c00; }
        .status-pill.confirmed { background: #e0f7fa; color: var(--teal-dark); }
        .status-pill.completed { background: #e8f5e9; color: #2e7d32; }
        .status-pill.cancelled { background: #fdecea; color: var(--error); }

        .action-btns { display: flex; gap: 6px; }
        .btn-accept {
            padding: 5px 14px; border-radius: 8px; font-size: 12px; font-weight: 700;
            border: none; cursor: pointer; transition: all 0.2s;
            background: var(--teal-pale); color: var(--teal-dark);
        }
        .btn-accept:hover { background: var(--teal-mid); color: white; }
        .btn-decline {
            padding: 5px 14px; border-radius: 8px; font-size: 12px; font-weight: 700;
            border: none; cursor: pointer; transition: all 0.2s;
            background: #fdecea; color: var(--error);
        }
        .btn-decline:hover { background: var(--error); color: white; }
        .btn-complete {
            padding: 4px 26px; border-radius: 8px; font-size: 12px; font-weight: 700;
            border: none; cursor: pointer; transition: all 0.2s;
            background: #e8f5e9; color: #2e7d32;
        }
        .btn-complete:hover { background: #2e7d32; color: white; }

        /* ── AVAILABILITY PANEL ── */
        .availability-grid {
            display: grid; grid-template-columns: repeat(7, 1fr); gap: 10px;
            margin-bottom: 24px;
        }
        .day-card {
            border-radius: 12px; border: 2px solid #e8f4f8;
            background: #f8fdff; overflow: hidden;
            transition: all 0.2s;
        }
        .day-card.available { border-color: var(--teal-mid); background: var(--teal-pale); }
        .day-header {
            padding: 10px 8px; text-align: center;
            border-bottom: 1px solid #e8f4f8;
        }
        .day-card.available .day-header { border-bottom-color: rgba(0,131,143,0.2); }
        .day-name { font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--text-light); }
        .day-card.available .day-name { color: var(--teal-dark); }
        .day-toggle {
            padding: 10px 8px; text-align: center; cursor: pointer;
        }
        .day-toggle-btn {
            width: 32px; height: 18px; border-radius: 9px; position: relative;
            background: #d0e8ee; border: none; cursor: pointer;
            transition: background 0.3s; margin: 0 auto; display: block;
        }
        .day-card.available .day-toggle-btn { background: var(--teal-mid); }
        .day-toggle-btn::after {
            content: ''; position: absolute;
            width: 12px; height: 12px; border-radius: 50%;
            background: white; top: 3px; left: 3px;
            transition: left 0.3s;
        }
        .day-card.available .day-toggle-btn::after { left: 17px; }

        .time-slots { display: flex; flex-direction: column; gap: 10px; }
        .time-slot-row { display: flex; align-items: center; gap: 14px; }
        .time-slot-label { font-size: 13px; font-weight: 700; color: var(--text-mid); width: 80px; }
        .time-inputs { display: flex; align-items: center; gap: 8px; flex: 1; }
        .time-input {
            padding: 9px 12px; border: 2px solid #e8f4f8; border-radius: 8px;
            font-family: 'Nunito', sans-serif; font-size: 13px; color: var(--text-dark);
            background: #f8fdff; outline: none; transition: all 0.25s;
        }
        .time-input:focus { border-color: var(--teal-bright); background: white; }
        .time-sep { font-size: 13px; color: var(--text-light); font-weight: 700; }

        /* ── REVIEWS PANEL ── */
        .rating-summary {
            display: flex; align-items: center; gap: 32px;
            padding: 24px; background: linear-gradient(135deg, var(--blue-dark), var(--teal-dark));
            border-radius: var(--radius); margin-bottom: 24px;
        }
        .rating-big { text-align: center; }
        .rating-num {
            font-family: 'Montserrat', sans-serif;
            font-size: 56px; font-weight: 800; color: white; line-height: 1;
        }
        .rating-stars-big { font-size: 22px; color: #ffd54f; margin: 4px 0; }
        .rating-count { font-size: 13px; color: rgba(255,255,255,0.6); }
        .rating-bars { flex: 1; }
        .rating-bar-row {
            display: flex; align-items: center; gap: 10px; margin-bottom: 8px;
        }
        .rating-bar-label { font-size: 12px; font-weight: 700; color: rgba(255,255,255,0.7); width: 40px; }
        .rating-bar-track { flex: 1; height: 7px; background: rgba(255,255,255,0.12); border-radius: 4px; overflow: hidden; }
        .rating-bar-fill { height: 100%; background: var(--teal-bright); border-radius: 4px; }
        .rating-bar-count { font-size: 12px; color: rgba(255,255,255,0.5); width: 24px; text-align: right; }

        .review-card {
            background: white; border: 1px solid #e8f4f8;
            border-radius: var(--radius); padding: 20px 22px;
            margin-bottom: 14px; transition: all 0.2s;
        }
        .review-card:hover { box-shadow: var(--shadow-sm); border-color: var(--teal-light); }
        .review-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
        .reviewer { display: flex; align-items: center; gap: 10px; }
        .reviewer-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: var(--teal-pale); display: flex; align-items: center; justify-content: center;
            font-size: 16px;
        }
        .reviewer-name { font-weight: 700; font-size: 14px; color: var(--text-dark); }
        .reviewer-date { font-size: 12px; color: var(--text-light); }
        .review-stars { color: #ffd54f; font-size: 14px; }
        .review-text { font-size: 14px; color: var(--text-mid); line-height: 1.7; }
        .review-service-tag {
            display: inline-block; margin-top: 10px;
            padding: 3px 12px; border-radius: 50px;
            background: var(--teal-pale); color: var(--teal-dark);
            font-size: 12px; font-weight: 700;
        }

        /* Empty state */
        .empty-state {
            text-align: center; padding: 48px 20px;
            color: var(--text-light);
        }
        .empty-icon { font-size: 48px; margin-bottom: 12px; opacity: 0.5; }
        .empty-text { font-size: 15px; font-weight: 600; }

        /* Toast */
        .toast {
            position: fixed; bottom: 28px; right: 28px;
            background: var(--blue-dark); color: white;
            padding: 14px 22px; border-radius: 12px;
            font-size: 14px; font-weight: 600;
            box-shadow: var(--shadow-lg);
            display: flex; align-items: center; gap: 10px;
            transform: translateY(80px); opacity: 0;
            transition: all 0.4s cubic-bezier(0.34,1.56,0.64,1);
            z-index: 999;
        }
        .toast.show { transform: translateY(0); opacity: 1; }
        .toast-icon { font-size: 18px; }

        /* Responsive */
        @media (max-width: 1024px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .availability-grid { grid-template-columns: repeat(4, 1fr); }
        }
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .main { margin-left: 0; }
            .form-grid-2, .form-grid-3 { grid-template-columns: 1fr; }
            .services-grid { grid-template-columns: 1fr 1fr; }
            .availability-grid { grid-template-columns: repeat(3, 1fr); }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Hidden fields to track active panel and available days across postbacks -->
        <asp:HiddenField ID="hdnActivePanel" runat="server" Value="overview" />
        <input type="hidden" name="hdnAvailableDays" id="hdnAvailableDays" value="" />

        <!-- SIDEBAR -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-logo">
                <img src="<%=ResolveUrl("~/App Data/No_Bg_Logo.png")%>" alt="SwiftCare" />
            </div>

            <div class="sidebar-profile">
                <div class="profile-avatar-sm" id="sideAvatarWrap">
                    <span id="sideAvatarEmoji">🧑‍⚕️</span>
                </div>
                <div class="profile-info-sm">
                    <div class="name" id="sidebarName">
                        <asp:Label ID="lblSidebarName" runat="server" Text="Caregiver" />
                    </div>
                    <div class="role-badge">Caregiver</div>
                </div>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-section-label">Main</div>
                <button type="button" class="nav-item active" onclick="showPanel('overview')">
                    <span class="nav-icon">🏠</span> Overview
                </button>
                <button type="button" class="nav-item" onclick="showPanel('profile')">
                    <span class="nav-icon">👤</span> My Profile
                </button>
                <button type="button" class="nav-item" onclick="showPanel('bookings')">
                    <span class="nav-icon">📅</span> Bookings
                </button>
                <button type="button" class="nav-item" onclick="showPanel('availability')">
                    <span class="nav-icon">🕐</span> Availability
                </button>
                <button type="button" class="nav-item" onclick="showPanel('reviews')">
                    <span class="nav-icon">⭐</span> Reviews
                </button>
            </nav>

            <div class="sidebar-bottom">
                <asp:Button ID="btnLogout" runat="server" Text="🚪  Log Out"
                    CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </aside>

        <!-- MAIN -->
        <div class="main">

            <!-- TOPBAR -->
            <div class="topbar">
                <div class="topbar-title" id="topbarTitle">Overview</div>
                <div class="topbar-right">
                    <div class="topbar-greeting">
                        Good day, <span><asp:Label ID="lblGreetName" runat="server" Text="Caregiver" /></span> 👋
                    </div>
                </div>
            </div>

            <div class="content">

                <!-- ── OVERVIEW PANEL ── -->
                <div class="panel active" id="panel-overview">
                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-icon teal">📅</div>
                            <div>
                                <div class="stat-val">
                                    <asp:Label ID="lblTotalBookings" runat="server" Text="0" />
                                </div>
                                <div class="stat-label">Total Bookings</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon blue">⏳</div>
                            <div>
                                <div class="stat-val">
                                    <asp:Label ID="lblPendingBookings" runat="server" Text="0" />
                                </div>
                                <div class="stat-label">Pending</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon green">✅</div>
                            <div>
                                <div class="stat-val">
                                    <asp:Label ID="lblCompletedBookings" runat="server" Text="0" />
                                </div>
                                <div class="stat-label">Completed</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon amber">⭐</div>
                            <div>
                                <div class="stat-val">
                                    <asp:Label ID="lblAvgRating" runat="server" Text="—" />
                                </div>
                                <div class="stat-label">Avg. Rating</div>
                            </div>
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">Recent Bookings</div>
                            <button type="button" class="filter-pill active" onclick="showPanel('bookings')">View All</button>
                        </div>
                        <div class="section-card-body" style="padding:0;">
                            <table class="booking-table">
                                <thead>
                                    <tr>
                                        <th>Client</th>
                                        <th>Service</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptRecentBookings" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div class="client-cell">
                                                        <div class="client-avatar">👤</div>
                                                        <div>
                                                            <div class="client-name"><%# Eval("ClientName") %></div>
                                                            <div class="client-loc"><%# Eval("Location") %></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%# Eval("Service") %></td>
                                                <td><%# Eval("BookingDate") %></td>
                                                <td><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("Status") %></span></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoBookings" runat="server" Visible="true">
                                <div class="empty-state">
                                    <div class="empty-icon">📭</div>
                                    <div class="empty-text">No bookings yet. Complete your profile to get started!</div>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- ── PROFILE PANEL ── -->
                <div class="panel" id="panel-profile">

                    <div class="profile-hero">
                        <div class="profile-avatar-lg" id="profileAvatarLg">
                            <span id="profileAvatarEmoji">🧑‍⚕️</span>
                        </div>
                        <div class="profile-hero-info">
                            <div class="profile-hero-name" id="profileHeroName">
                                <asp:Label ID="lblProfileName" runat="server" Text="Your Name" />
                            </div>
                            <div class="profile-hero-sub">Caregiver · SwiftCare</div>
                            <div class="profile-status-badge">
                                <div class="status-dot"></div> Available for bookings
                            </div>
                        </div>
                    </div>

                    <!-- Personal Info -->
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">Personal Information</div>
                        </div>
                        <div class="section-card-body">
                            <div class="form-grid-2" style="margin-bottom:18px;">
                                <div class="form-group">
                                    <label class="form-label">Full Name</label>
                                    <asp:TextBox ID="txtProfileName" runat="server" CssClass="form-input" placeholder="Your full name" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Phone Number</label>
                                    <asp:TextBox ID="txtProfilePhone" runat="server" CssClass="form-input" placeholder="09XX XXX XXXX" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">City / Location</label>
                                    <asp:TextBox ID="txtProfileCity" runat="server" CssClass="form-input" placeholder="e.g. Biñan, Laguna" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Hourly Rate (₱)</label>
                                    <asp:TextBox ID="txtProfileRate" runat="server" CssClass="form-input" placeholder="e.g. 150" TextMode="Number" />
                                </div>
                            </div>
                            <div class="form-group full" style="margin-bottom:18px;">
                                <label class="form-label">Bio / About Me <span id="bioCount" style="font-weight:400;color:var(--text-light);">(0/150)</span></label>
                                <asp:TextBox ID="txtProfileBio" runat="server" CssClass="form-textarea" TextMode="MultiLine"
                                    MaxLength="150"
                                    placeholder="Tell families about yourself, your experience, and why you love caregiving..."
                                    style="resize:none; height:90px;"
                                    onkeyup="updateBioCount(this)" oninput="updateBioCount(this)" />
                            </div>

                        </div>
                    </div>

                    <!-- Services Offered -->
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">Services I Offer</div>
                        </div>
                        <div class="section-card-body">
                            <div class="services-grid">
                                <div class="service-check" id="svc-childcare" onclick="toggleService(this, 'chkChildCare')">
                                    <input type="checkbox" id="chkChildCare" runat="server" style="display:none;" />
                                    <div class="check-box">✓</div>
                                    <span class="service-emoji">👶</span>
                                    <span class="service-check-label">Child Care</span>
                                </div>
                                <div class="service-check" id="svc-elderly" onclick="toggleService(this, 'chkElderlyCare')">
                                    <input type="checkbox" id="chkElderlyCare" runat="server" style="display:none;" />
                                    <div class="check-box">✓</div>
                                    <span class="service-emoji">👴</span>
                                    <span class="service-check-label">Elderly Care</span>
                                </div>
                                <div class="service-check" id="svc-pet" onclick="toggleService(this, 'chkPetCare')">
                                    <input type="checkbox" id="chkPetCare" runat="server" style="display:none;" />
                                    <div class="check-box">✓</div>
                                    <span class="service-emoji">🐾</span>
                                    <span class="service-check-label">Pet Care</span>
                                </div>
                                <div class="service-check" id="svc-house" onclick="toggleService(this, 'chkHouseSitting')">
                                    <input type="checkbox" id="chkHouseSitting" runat="server" style="display:none;" />
                                    <div class="check-box">✓</div>
                                    <span class="service-emoji">🏠</span>
                                    <span class="service-check-label">House Sitting</span>
                                </div>
                                <div class="service-check" id="svc-special" onclick="toggleService(this, 'chkSpecialNeeds')">
                                    <input type="checkbox" id="chkSpecialNeeds" runat="server" style="display:none;" />
                                    <div class="check-box">✓</div>
                                    <span class="service-emoji">♿</span>
                                    <span class="service-check-label">Special Needs</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <asp:Button ID="btnSaveProfile" runat="server" Text="💾  Save Profile"
                        CssClass="btn-save" OnClick="btnSaveProfile_Click" />
                    <asp:Label ID="lblProfileMsg" runat="server" CssClass="server-msg" style="margin-left:14px;" />
                </div><!-- /panel-profile -->

                <!-- ── BOOKINGS PANEL ── -->
                <div class="panel" id="panel-bookings">
                    <div class="bookings-filter">
                        <button type="button" class="filter-pill active" onclick="filterBookings(this,'all')">All</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'pending')">Pending</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'confirmed')">Confirmed</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'completed')">Completed</button>
                        <button type="button" class="filter-pill" onclick="filterBookings(this,'cancelled')">Cancelled</button>
                    </div>

                    <div class="section-card">
                        <div class="section-card-body" style="padding:0;">
                            <table class="booking-table">
                                <thead>
                                    <tr>
                                        <th>Client</th>
                                        <th>Service</th>
                                        <th>Date & Time</th>
                                        <th>Rate</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptAllBookings" runat="server">
                                        <ItemTemplate>
                                            <tr class="booking-row" data-status="<%# Eval("StatusClass") %>">
                                                <td>
                                                    <div class="client-cell">
                                                        <div class="client-avatar">👤</div>
                                                        <div>
                                                            <div class="client-name"><%# Eval("ClientName") %></div>
                                                            <div class="client-loc"><%# Eval("Location") %></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%# Eval("Service") %></td>
                                                <td><%# Eval("BookingDate") %></td>
                                                <td>₱<%# String.Format("{0:N2}", Eval("Rate")) %>/hr</td>
                                                <td style="font-weight:800;color:var(--teal-dark);">₱<%# String.Format("{0:N2}", Eval("EstTotal")) %></td>
                                                <td><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("Status") %></span></td>
                                                <td>
                                                    <div class="action-btns">
                                                        <asp:LinkButton ID="lbAccept" runat="server"
                                                            CssClass="btn-accept"
                                                            CommandName="Accept"
                                                            CommandArgument='<%# Eval("BookingID") %>'
                                                            OnCommand="BookingAction_Command"
                                                            Visible='<%# Eval("StatusClass").ToString() == "pending" %>'>
                                                            ✓ Accept
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lbDecline" runat="server"
                                                            CssClass="btn-decline"
                                                            CommandName="Decline"
                                                            CommandArgument='<%# Eval("BookingID") %>'
                                                            OnCommand="BookingAction_Command"
                                                            Visible='<%# Eval("StatusClass").ToString() == "pending" %>'>
                                                            ✕ Decline
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lbComplete" runat="server"
                                                            CssClass="btn-complete"
                                                            CommandName="Complete"
                                                            CommandArgument='<%# Eval("BookingID") %>'
                                                            OnCommand="BookingAction_Command"
                                                            OnClientClick='<%# "return showCompleteModal(\"" + Eval("ClientName") + "\",\"" + Eval("Service") + "\",\"" + String.Format("{0:N2}", Eval("EstTotal")) + "\",this);" %>'
                                                            Visible='<%# Eval("StatusClass").ToString() == "confirmed" %>'>Mark Complete
                                                        </asp:LinkButton>
                                                        <span style="font-size:13px;color:var(--text-light);font-style:italic;"
                                                            <%# Eval("StatusClass").ToString() == "completed" || Eval("StatusClass").ToString() == "cancelled" ? "" : "hidden" %>>
                                                            <%# Eval("StatusClass").ToString() == "completed" ? "✅ Done" : "❌ Cancelled" %>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoAllBookings" runat="server" Visible="true">
                                <div class="empty-state">
                                    <div class="empty-icon">📭</div>
                                    <div class="empty-text">No bookings found.</div>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <!-- ── AVAILABILITY PANEL ── -->
                <div class="panel" id="panel-availability">
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">Weekly Availability</div>
                        </div>
                        <div class="section-card-body">
                            <div class="availability-grid">
                                <% string[] days = {"Mon","Tue","Wed","Thu","Fri","Sat","Sun"}; %>
                                <div class="day-card" id="day-Mon">
                                    <div class="day-header"><div class="day-name">Mon</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Mon')"></button></div>
                                </div>
                                <div class="day-card" id="day-Tue">
                                    <div class="day-header"><div class="day-name">Tue</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Tue')"></button></div>
                                </div>
                                <div class="day-card" id="day-Wed">
                                    <div class="day-header"><div class="day-name">Wed</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Wed')"></button></div>
                                </div>
                                <div class="day-card" id="day-Thu">
                                    <div class="day-header"><div class="day-name">Thu</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Thu')"></button></div>
                                </div>
                                <div class="day-card" id="day-Fri">
                                    <div class="day-header"><div class="day-name">Fri</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Fri')"></button></div>
                                </div>
                                <div class="day-card" id="day-Sat">
                                    <div class="day-header"><div class="day-name">Sat</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Sat')"></button></div>
                                </div>
                                <div class="day-card" id="day-Sun">
                                    <div class="day-header"><div class="day-name">Sun</div></div>
                                    <div class="day-toggle"><button type="button" class="day-toggle-btn" onclick="toggleDay('day-Sun')"></button></div>
                                </div>
                            </div>

                            <div class="time-slots">
                                <div class="time-slot-row">
                                    <span class="time-slot-label">Available From</span>
                                    <div class="time-inputs">
                                        <asp:TextBox ID="txtDayStart" runat="server" CssClass="time-input" TextMode="Time" Text="08:00" />
                                        <span class="time-sep">to</span>
                                        <asp:TextBox ID="txtDayEnd" runat="server" CssClass="time-input" TextMode="Time" Text="17:00" />
                                    </div>
                                </div>
                            </div>

                            <div style="margin-top:24px;">
                                <asp:Button ID="btnSaveAvailability" runat="server" Text="💾  Save Availability"
                                    CssClass="btn-save" OnClick="btnSaveAvailability_Click" />
                                <asp:Label ID="lblAvailMsg" runat="server" CssClass="server-msg" style="margin-left:14px;" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ── REVIEWS PANEL ── -->
                <div class="panel" id="panel-reviews">
                    <div class="rating-summary">
                        <div class="rating-big">
                            <div class="rating-num">
                                <asp:Label ID="lblRatingNum" runat="server" Text="—" />
                            </div>
                            <div class="rating-stars-big">★★★★★</div>
                            <div class="rating-count">
                                <asp:Label ID="lblReviewCount" runat="server" Text="0 reviews" />
                            </div>
                        </div>
                        <div class="rating-bars">
                            <div class="rating-bar-row">
                                <span class="rating-bar-label">5 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width:0%;" id="bar5"></div></div>
                                <span class="rating-bar-count" id="cnt5">0</span>
                            </div>
                            <div class="rating-bar-row">
                                <span class="rating-bar-label">4 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width:0%;" id="bar4"></div></div>
                                <span class="rating-bar-count" id="cnt4">0</span>
                            </div>
                            <div class="rating-bar-row">
                                <span class="rating-bar-label">3 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width:0%;" id="bar3"></div></div>
                                <span class="rating-bar-count" id="cnt3">0</span>
                            </div>
                            <div class="rating-bar-row">
                                <span class="rating-bar-label">2 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width:0%;" id="bar2"></div></div>
                                <span class="rating-bar-count" id="cnt2">0</span>
                            </div>
                            <div class="rating-bar-row">
                                <span class="rating-bar-label">1 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width:0%;" id="bar1"></div></div>
                                <span class="rating-bar-count" id="cnt1">0</span>
                            </div>
                        </div>
                    </div>

                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div class="review-card">
                                <div class="review-header">
                                    <div class="reviewer">
                                        <div class="reviewer-avatar">👤</div>
                                        <div>
                                            <div class="reviewer-name"><%# Eval("ClientName") %></div>
                                            <div class="reviewer-date"><%# Eval("ReviewDate") %></div>
                                        </div>
                                    </div>
                                    <div class="review-stars"><%# Eval("Stars") %></div>
                                </div>
                                <div class="review-text"><%# Eval("ReviewText") %></div>
                                <span class="review-service-tag"><%# Eval("Service") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoReviews" runat="server" Visible="true">
                        <div class="empty-state">
                            <div class="empty-icon">⭐</div>
                            <div class="empty-text">No reviews yet. Complete bookings to earn reviews!</div>
                        </div>
                    </asp:Panel>
                </div>

            </div><!-- /content -->
        </div><!-- /main -->

        <!-- Toast notification -->
        <div class="toast" id="toast">
            <span class="toast-icon">✅</span>
            <span id="toastMsg">Saved successfully!</span>
        </div>

        <script>
            // Panel switching — saves active panel to hidden field so it survives postback
            function showPanel(name) {
                document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                document.getElementById('panel-' + name).classList.add('active');
                var labels = { overview:'Overview', profile:'My Profile', bookings:'Bookings', availability:'Availability', reviews:'Reviews' };
                document.getElementById('topbarTitle').textContent = labels[name] || name;
                document.querySelectorAll('.nav-item').forEach(function(el) {
                    if (el.getAttribute('onclick') && el.getAttribute('onclick').includes("'" + name + "'")) {
                        el.classList.add('active');
                    }
                });
                // Save to hidden field so postback remembers active panel
                var hdn = document.getElementById('<%= hdnActivePanel.ClientID %>');
                if (hdn) hdn.value = name;
            }

            // Bio character counter
            function updateBioCount(el) {
                var count = el.value.length;
                var span = document.getElementById('bioCount');
                if (span) {
                    span.textContent = '(' + count + '/150)';
                    span.style.color = count >= 140 ? '#e53935' : '#4a7a92';
                }
            }
            // Init counter on load
            window.addEventListener('DOMContentLoaded', function() {
                var bio = document.getElementById('<%= txtProfileBio.ClientID %>');
                if (bio) updateBioCount(bio);
            });

            // Service checkbox toggle — syncs CSS class AND the hidden server checkbox
            function toggleService(el, cbId) {
                el.classList.toggle('checked');
                var cb = document.getElementById(cbId);
                if (cb) cb.checked = el.classList.contains('checked');
            }

            // Day availability toggle — also updates hidden field
            function toggleDay(id) {
                document.getElementById(id).classList.toggle('available');
                updateAvailableDays();
            }

            // Collect all toggled days into hidden field
            // Day mapping: Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6, Sun=0
            function updateAvailableDays() {
                var dayMap = { 'day-Mon':1, 'day-Tue':2, 'day-Wed':3, 'day-Thu':4, 'day-Fri':5, 'day-Sat':6, 'day-Sun':0 };
                var selected = [];
                Object.keys(dayMap).forEach(function(id) {
                    if (document.getElementById(id) && document.getElementById(id).classList.contains('available')) {
                        selected.push(dayMap[id]);
                    }
                });
                document.getElementById('hdnAvailableDays').value = selected.join(',');
            }

            // Load saved days from DB on page load
            function loadSavedDays(daysStr) {
                var dayMap = { 1:'day-Mon', 2:'day-Tue', 3:'day-Wed', 4:'day-Thu', 5:'day-Fri', 6:'day-Sat', 0:'day-Sun' };
                daysStr.split(',').forEach(function(d) {
                    var n = parseInt(d.trim());
                    if (!isNaN(n) && dayMap[n]) {
                        var el = document.getElementById(dayMap[n]);
                        if (el) el.classList.add('available');
                    }
                });
                updateAvailableDays();
            }

            // Booking filter
            function filterBookings(btn, status) {
                document.querySelectorAll('.bookings-filter .filter-pill').forEach(p => p.classList.remove('active'));
                btn.classList.add('active');
                document.querySelectorAll('.booking-row').forEach(function(row) {
                    if (status === 'all' || row.dataset.status === status) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            // Toast
            function showToast(msg) {
                var t = document.getElementById('toast');
                document.getElementById('toastMsg').textContent = msg;
                t.classList.add('show');
                setTimeout(function() { t.classList.remove('show'); }, 3000);
            }

            // On page load: restore active panel + bio counter + toast
            window.addEventListener('DOMContentLoaded', function () {
                // Restore active panel
                var hdn = document.getElementById('<%= hdnActivePanel.ClientID %>');
                var activePanel = hdn ? hdn.value : 'overview';
                if (activePanel && activePanel !== 'overview') {
                    showPanel(activePanel);
                }

                // Restore bio counter
                var bio = document.getElementById('<%= txtProfileBio.ClientID %>');
                if (bio) updateBioCount(bio);

                // Show toast from profile save
                var profileMsg = '<%= lblProfileMsg.Text %>';
                if (profileMsg && profileMsg.trim() !== '') showToast(profileMsg);

                // Show toast from availability save
                var availMsg = '<%= lblAvailMsg.Text %>';
                if (availMsg && availMsg.trim() !== '') showToast(availMsg);
            });
        </script>

        <!-- ── MARK COMPLETE MODAL ── -->
        <div id="completeModal" style="display:none;position:fixed;inset:0;background:rgba(6,32,53,0.55);z-index:300;align-items:center;justify-content:center;backdrop-filter:blur(4px);">
            <div style="background:white;border-radius:20px;width:90%;max-width:420px;box-shadow:0 20px 60px rgba(10,42,74,0.25);overflow:hidden;">
                <div style="background:linear-gradient(135deg,#0a2a4a,#006064);padding:22px 26px;display:flex;align-items:center;gap:14px;">
                    <div style="font-size:32px;">✅</div>
                    <div>
                        <div style="font-family:'Montserrat',sans-serif;font-size:17px;font-weight:800;color:white;">Mark as Completed</div>
                        <div style="font-size:12px;color:rgba(255,255,255,0.65);margin-top:2px;">This action cannot be undone</div>
                    </div>
                </div>
                <div style="padding:22px 26px;">
                    <div style="display:flex;flex-direction:column;gap:10px;margin-bottom:20px;">
                        <div style="display:flex;justify-content:space-between;padding:10px 14px;background:#f4fbfc;border-radius:10px;">
                            <span style="font-size:13px;font-weight:700;color:#1a4a62;">Client</span>
                            <span id="mdClientName" style="font-size:13px;font-weight:800;color:#062035;"></span>
                        </div>
                        <div style="display:flex;justify-content:space-between;padding:10px 14px;background:#f4fbfc;border-radius:10px;">
                            <span style="font-size:13px;font-weight:700;color:#1a4a62;">Service</span>
                            <span id="mdServiceName" style="font-size:13px;font-weight:800;color:#062035;"></span>
                        </div>
                        <div style="display:flex;justify-content:space-between;padding:10px 14px;background:#e0f7fa;border-radius:10px;">
                            <span style="font-size:13px;font-weight:700;color:#006064;">Total</span>
                            <span id="mdEstTotal" style="font-size:14px;font-weight:800;color:#006064;"></span>
                        </div>
                    </div>
                    <div style="display:flex;gap:10px;">
                        <button type="button" onclick="closeCompleteModal()" style="flex:1;padding:12px;border-radius:10px;border:2px solid #e8f4f8;background:white;font-family:'Nunito',sans-serif;font-size:14px;font-weight:700;color:#4a7a92;cursor:pointer;">Cancel</button>
                        <button type="button" id="btnModalComplete" style="flex:2;padding:12px;border-radius:10px;border:none;background:linear-gradient(135deg,#2e7d32,#00838f);color:white;font-family:'Nunito',sans-serif;font-size:14px;font-weight:800;cursor:pointer;">✔ Confirm Complete</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showCompleteModal(clientName, service, estTotal, btn) {
                document.getElementById('mdClientName').textContent = clientName;
                document.getElementById('mdServiceName').textContent = service;
                document.getElementById('mdEstTotal').textContent = '₱' + estTotal;
                // Wire confirm to actually trigger the server LinkButton
                document.getElementById('btnModalComplete').onclick = function () {
                    closeCompleteModal();
                    btn.click();
                };
                document.getElementById('completeModal').style.display = 'flex';
                return false; // prevent immediate postback
            }
            function closeCompleteModal() {
                document.getElementById('completeModal').style.display = 'none';
            }
            document.getElementById('completeModal').addEventListener('click', function (e) {
                if (e.target === this) closeCompleteModal();
            });
        </script>

    </form>
</body>
</html>
