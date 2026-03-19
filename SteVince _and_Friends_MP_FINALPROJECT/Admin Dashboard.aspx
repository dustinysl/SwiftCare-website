f<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin Dashboard.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.Admin_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare — Admin Dashboard</title>
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

        .sidebar { width: var(--sidebar-w); min-height: 100vh; background: var(--blue-dark); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; bottom: 0; z-index: 50; }
        .sidebar-logo { padding: 0 24px; height: 80px; display: flex; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.07); }
        .sidebar-logo img { height: 110px; width: auto; object-fit: contain; }
        .sidebar-profile { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.07); display: flex; align-items: center; gap: 12px; }
        .profile-avatar-sm { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg, #e53935, #b71c1c); display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; border: 2px solid rgba(239,154,154,0.4); }
        .profile-info-sm .name { font-size: 14px; font-weight: 700; color: white; }
        .profile-info-sm .role-badge { display: inline-block; font-size: 11px; font-weight: 700; background: rgba(239,154,154,0.18); border: 1px solid rgba(239,154,154,0.35); color: #ef9a9a; padding: 2px 10px; border-radius: 50px; margin-top: 3px; }
        .sidebar-nav { flex: 1; padding: 16px 12px; }
        .nav-section-label { font-size: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 1.5px; color: rgba(255,255,255,0.3); padding: 10px 10px 6px; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 10px; color: rgba(255,255,255,0.6); font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-bottom: 3px; border: none; background: none; width: 100%; text-align: left; }
        .nav-item:hover { background: rgba(255,255,255,0.07); color: white; }
        .nav-item.active { background: linear-gradient(135deg, rgba(229,57,53,0.25), rgba(21,101,160,0.2)); color: white; border: 1px solid rgba(239,154,154,0.2); }
        .nav-item .nav-icon { font-size: 17px; width: 22px; text-align: center; flex-shrink: 0; }
        .sidebar-bottom { padding: 16px 12px; border-top: 1px solid rgba(255,255,255,0.07); }
        .btn-logout { display: flex; align-items: center; gap: 10px; width: 100%; padding: 10px 14px; border-radius: 10px; background: rgba(229,57,53,0.12); border: 1px solid rgba(229,57,53,0.2); color: #ef9a9a; font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .btn-logout:hover { background: rgba(229,57,53,0.22); color: #ff8a80; }


        .main { margin-left: var(--sidebar-w); flex: 1; min-height: 100vh; display: flex; flex-direction: column; }
        .topbar { height: 72px; background: white; border-bottom: 1px solid #e8f4f8; display: flex; align-items: center; justify-content: space-between; padding: 0 36px; position: sticky; top: 0; z-index: 40; box-shadow: var(--shadow-sm); }
        .topbar-title { font-family: 'Montserrat', sans-serif; font-size: 20px; font-weight: 800; color: var(--text-dark); }
        .topbar-greeting { font-size: 14px; color: var(--text-light); font-weight: 600; }
        .topbar-greeting span { color: #c62828; font-weight: 800; }
        .content { padding: 32px 36px; flex: 1; }


        .panel { display: none; animation: panelIn 0.4s ease; }
        .panel.active { display: block; }
        @keyframes panelIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: white; border-radius: var(--radius); padding: 22px 20px; border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm); display: flex; align-items: center; gap: 16px; }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .stat-icon.teal  { background: var(--teal-pale); }
        .stat-icon.blue  { background: #e3f2fd; }
        .stat-icon.green { background: #e8f5e9; }
        .stat-icon.red   { background: #fdecea; }
        .stat-val { font-family: 'Montserrat', sans-serif; font-size: 26px; font-weight: 800; color: var(--text-dark); line-height: 1; }
        .stat-label { font-size: 12px; color: var(--text-light); font-weight: 600; margin-top: 3px; }


        .section-card { background: white; border-radius: var(--radius); border: 1px solid #e8f4f8; box-shadow: var(--shadow-sm); margin-bottom: 24px; overflow: hidden; }
        .section-card-header { padding: 20px 28px 16px; border-bottom: 1px solid #f0f8fa; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; }
        .section-card-title { font-family: 'Montserrat', sans-serif; font-size: 16px; font-weight: 800; color: var(--text-dark); }


        .filter-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .search-input { padding: 9px 16px; border: 2px solid #e8f4f8; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 14px; outline: none; background: white; min-width: 220px; transition: all 0.25s; }
        .search-input:focus { border-color: var(--teal-bright); box-shadow: 0 0 0 4px rgba(38,198,218,0.1); }
        .search-select { padding: 9px 16px; border: 2px solid #e8f4f8; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 14px; outline: none; background: white; cursor: pointer; }
        .search-select:focus { border-color: var(--teal-bright); }
        .btn-search { padding: 9px 22px; background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright)); color: white; border: none; border-radius: 50px; font-family: 'Nunito', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s; white-space: nowrap; }
        .btn-search:hover { transform: translateY(-1px); }

        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th { text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--text-light); padding: 14px 16px 12px; border-bottom: 2px solid #f0f8fa; }
        .data-table td { padding: 13px 16px; font-size: 14px; color: var(--text-mid); border-bottom: 1px solid #f5fbfc; vertical-align: middle; }
        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background: #fafeff; }
        .user-cell { display: flex; align-items: center; gap: 10px; }
        .user-avatar { width: 34px; height: 34px; border-radius: 50%; background: var(--teal-pale); display: flex; align-items: center; justify-content: center; font-size: 15px; flex-shrink: 0; }
        .user-name { font-weight: 700; color: var(--text-dark); font-size: 14px; }
        .user-email { font-size: 12px; color: var(--text-light); }

 
        .status-pill { display: inline-block; padding: 4px 12px; border-radius: 50px; font-size: 12px; font-weight: 700; }
        .status-pill.active    { background: #e8f5e9; color: #2e7d32; }
        .status-pill.inactive  { background: #fdecea; color: var(--error); }
        .status-pill.pending   { background: #fff8e1; color: #f57c00; }
        .status-pill.confirmed { background: #e0f7fa; color: var(--teal-dark); }
        .status-pill.completed { background: #e8f5e9; color: #2e7d32; }
        .status-pill.cancelled { background: #fdecea; color: var(--error); }

        .role-tag { display: inline-block; padding: 3px 10px; border-radius: 50px; font-size: 11px; font-weight: 800; }
        .role-tag.user      { background: #e3f2fd; color: var(--blue-mid); }
        .role-tag.caregiver { background: var(--teal-pale); color: var(--teal-dark); }


        .action-btns { display: flex; gap: 6px; flex-wrap: wrap; }
        .btn-activate   { padding: 5px 13px; border-radius: 8px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: all 0.2s; background: #e8f5e9; color: #2e7d32; }
        .btn-activate:hover { background: #2e7d32; color: white; }
        .btn-deactivate { padding: 5px 13px; border-radius: 8px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: all 0.2s; background: #fdecea; color: var(--error); }
        .btn-deactivate:hover { background: var(--error); color: white; }
        .btn-confirm  { padding: 5px 13px; border-radius: 8px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: all 0.2s; background: var(--teal-pale); color: var(--teal-dark); }
        .btn-confirm:hover  { background: var(--teal-mid); color: white; }
        .btn-complete { padding: 5px 13px; border-radius: 8px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: all 0.2s; background: #e8f5e9; color: #2e7d32; }
        .btn-complete:hover { background: #2e7d32; color: white; }
        .btn-cancel-bk { padding: 5px 13px; border-radius: 8px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; transition: all 0.2s; background: #fdecea; color: var(--error); }
        .btn-cancel-bk:hover { background: var(--error); color: white; }

     
        .empty-state { text-align: center; padding: 48px 20px; color: var(--text-light); }
        .empty-icon { font-size: 48px; margin-bottom: 12px; opacity: 0.5; }
        .empty-text { font-size: 15px; font-weight: 600; }

        .server-msg { font-size: 13px; font-weight: 700; color: var(--teal-dark); }

        .admin-hero { background: linear-gradient(135deg, #b71c1c 0%, var(--blue-dark) 100%); border-radius: var(--radius); padding: 28px 32px; display: flex; align-items: center; gap: 24px; margin-bottom: 28px; position: relative; overflow: hidden; }
        .admin-hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 60% 80% at 90% 50%, rgba(239,154,154,0.12) 0%, transparent 65%); }
        .admin-hero-avatar { width: 72px; height: 72px; border-radius: 50%; background: rgba(239,154,154,0.2); border: 2px solid rgba(239,154,154,0.4); display: flex; align-items: center; justify-content: center; font-size: 30px; flex-shrink: 0; position: relative; z-index: 1; }
        .admin-hero-info { position: relative; z-index: 1; }
        .admin-hero-title { font-family: 'Montserrat', sans-serif; font-size: 22px; font-weight: 800; color: white; margin-bottom: 4px; }
        .admin-hero-sub { font-size: 14px; color: rgba(255,255,255,0.65); margin-bottom: 10px; }
        .badge-dot { width: 7px; height: 7px; border-radius: 50%; background: #ef9a9a; animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.4;transform:scale(1.4);} }

        .toast { position: fixed; bottom: 28px; right: 28px; background: var(--blue-dark); color: white; padding: 14px 22px; border-radius: 12px; font-size: 14px; font-weight: 600; box-shadow: var(--shadow-lg); display: flex; align-items: center; gap: 10px; transform: translateY(80px); opacity: 0; transition: all 0.4s cubic-bezier(0.34,1.56,0.64,1); z-index: 999; }
        .toast.show { transform: translateY(0); opacity: 1; }

        @media (max-width: 1024px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main { margin-left: 0; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <aside class="sidebar">
            <div class="sidebar-logo">
                <img src="<%=ResolveUrl("~/App Data/No_Bg_Logo.png")%>" alt="SwiftCare" />
            </div>
            <div class="sidebar-profile">
                <div class="profile-avatar-sm">🛡️</div>
                <div class="profile-info-sm">
                    <div class="name"><asp:Label ID="lblSidebarName" runat="server" Text="Admin" /></div>
                    <div class="role-badge">Administrator</div>
                </div>
            </div>
            <nav class="sidebar-nav">
                <div class="nav-section-label">Dashboard</div>
                <button type="button" class="nav-item active" onclick="showPanel('overview')">
                    <span class="nav-icon">🏠</span> Overview
                </button>
                <div class="nav-section-label">Manage</div>
                <button type="button" class="nav-item" onclick="showPanel('bookings')">
                    <span class="nav-icon">📅</span> Bookings
                </button>
                <button type="button" class="nav-item" onclick="showPanel('users')">
                    <span class="nav-icon">👥</span> Users
                </button>
                <button type="button" class="nav-item" onclick="showPanel('caregivers')">
                    <span class="nav-icon">🧑‍⚕️</span> Caregivers
                </button>
            </nav>
            <div class="sidebar-bottom">
                <asp:Label ID="lblAdminMsg" runat="server" CssClass="server-msg" style="display:block;padding:8px 12px;margin-bottom:8px;" />
                <asp:Button ID="btnLogout" runat="server" Text="Log Out"
                    CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </aside>


        <div class="main">
            <div class="topbar">
                <div class="topbar-title" id="topbarTitle">Overview</div>
                <div class="topbar-greeting">
                    Good day, <span><asp:Label ID="lblGreetName" runat="server" Text="Admin" /></span>
                </div>
            </div>

            <div class="content">

                <div class="panel active" id="panel-overview">
                    <div class="admin-hero">
                        <div class="admin-hero-avatar">🛡️</div>
                        <div class="admin-hero-info">
                            <div class="admin-hero-title">Admin Control Panel</div>
                            <div class="admin-hero-sub">Manage all bookings, users, and caregivers from here.</div>
                        </div>
                    </div>
                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-icon blue">👥</div>
                            <div>
                                <div class="stat-val"><asp:Label ID="lblTotalUsers" runat="server" Text="0" /></div>
                                <div class="stat-label">Total Users</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon teal">🧑‍⚕️</div>
                            <div>
                                <div class="stat-val"><asp:Label ID="lblTotalCaregivers" runat="server" Text="0" /></div>
                                <div class="stat-label">Caregivers</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon green">📅</div>
                            <div>
                                <div class="stat-val"><asp:Label ID="lblTotalBookings" runat="server" Text="0" /></div>
                                <div class="stat-label">Total Bookings</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon red">⏳</div>
                            <div>
                                <div class="stat-val"><asp:Label ID="lblPendingBookings" runat="server" Text="0" /></div>
                                <div class="stat-label">Pending Bookings</div>
                            </div>
                        </div>
                    </div>
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">Quick Actions</div>
                        </div>
                        <div style="padding:20px 28px;display:flex;gap:12px;flex-wrap:wrap;">
                            <button type="button" class="btn-search" onclick="showPanel('bookings')">📅 Manage Bookings</button>
                            <button type="button" class="btn-search" onclick="showPanel('users')">👥 Manage Users</button>
                            <button type="button" class="btn-search" onclick="showPanel('caregivers')">🧑‍⚕️ Manage Caregivers</button>
                        </div>
                    </div>
                </div>

      
                <div class="panel" id="panel-bookings">
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">All Bookings</div>
                            <div class="filter-bar">
                                <asp:DropDownList ID="ddlBookingFilter" runat="server" CssClass="search-select">
                                    <asp:ListItem Value="" Text="All Statuses" />
                                    <asp:ListItem Value="Pending" Text="Pending" />
                                    <asp:ListItem Value="Confirmed" Text="Confirmed" />
                                    <asp:ListItem Value="Completed" Text="Completed" />
                                    <asp:ListItem Value="Cancelled" Text="Cancelled" />
                                </asp:DropDownList>
                                <asp:Button ID="btnFilterBookings" runat="server" Text="Filter"
                                    CssClass="btn-search" OnClick="btnFilterBookings_Click" />
                            </div>
                        </div>
                        <div style="padding:0;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="padding:14px 16px 12px;">#</th>
                                        <th style="padding:14px 16px 12px;">Client</th>
                                        <th style="padding:14px 16px 12px;">Caregiver</th>
                                        <th style="padding:14px 16px 12px;">Service</th>
                                        <th style="padding:14px 16px 12px;">Date &amp; Time</th>
                                        <th style="padding:14px 16px 12px;">Status</th>
                                        <th style="padding:14px 16px 12px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptBookings" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-weight:700;color:var(--text-light);">#<%# Eval("BookingID") %></td>
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-avatar">👤</div>
                                                        <div class="user-name"><%# Eval("ClientName") %></div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-avatar">🧑‍⚕️</div>
                                                        <div class="user-name"><%# Eval("CaregiverName") %></div>
                                                    </div>
                                                </td>
                                                <td><%# Eval("ServiceName") %></td>
                                                <td><%# Eval("BookingDate") %><br /><small style="color:var(--text-light);"><%# Eval("StartTime") %> – <%# Eval("EndTime") %></small></td>
                                                <td><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("Status") %></span></td>
                                                <td>
                                                    <div class="action-btns">
                                                        <asp:LinkButton ID="lbConfirm" runat="server"
                                                            CssClass="btn-confirm"
                                                            CommandName="Confirmed"
                                                            CommandArgument='<%# Eval("BookingID") %>'
                                                            OnCommand="BookingAction_Command"
                                                            Visible='<%# Eval("StatusClass").ToString() == "pending" %>'>Confirm</asp:LinkButton>
                                                        <asp:LinkButton ID="lbComplete" runat="server"
                                                            CssClass="btn-complete"
                                                            CommandName="Completed"
                                                            CommandArgument='<%# Eval("BookingID") %>'
                                                            OnCommand="BookingAction_Command"
                                                            Visible='<%# Eval("StatusClass").ToString() == "confirmed" %>'>Complete</asp:LinkButton>
                                                        <asp:LinkButton ID="lbCancel" runat="server"
                                                            CssClass="btn-cancel-bk"
                                                            CommandName="Cancelled"
                                                            CommandArgument='<%# Eval("BookingID") %>'
                                                            OnCommand="BookingAction_Command"
                                                            Visible='<%# Eval("StatusClass").ToString() == "pending" || Eval("StatusClass").ToString() == "confirmed" %>'>Cancel</asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoBookings" runat="server" Visible="false">
                                <div class="empty-state"><div class="empty-icon">📭</div><div class="empty-text">No bookings found.</div></div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <div class="panel" id="panel-users">
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">All Users</div>
                            <div class="filter-bar">
                                <asp:TextBox ID="txtSearchUsers" runat="server" CssClass="search-input" placeholder="Search by name or email..." />
                                <asp:Button ID="btnSearchUsers" runat="server" Text="Search"
                                    CssClass="btn-search" OnClick="btnSearchUsers_Click" />
                            </div>
                        </div>
                        <div style="padding:0;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="padding:14px 16px 12px;">User</th>
                                        <th style="padding:14px 16px 12px;">Contact</th>
                                        <th style="padding:14px 16px 12px;">Address</th>
                                        <th style="padding:14px 16px 12px;">Role</th>
                                        <th style="padding:14px 16px 12px;">Status</th>
                                        <th style="padding:14px 16px 12px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptUsers" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-avatar">👤</div>
                                                        <div>
                                                            <div class="user-name"><%# Eval("FullName") %></div>
                                                            <div class="user-email"><%# Eval("Email") %></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%# Eval("ContactNo") %></td>
                                                <td><%# Eval("Address") %></td>
                                                <td><span class="role-tag <%# Eval("Role").ToString().ToLower() %>"><%# Eval("Role") %></span></td>
                                                <td><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("AccountStatus") %></span></td>
                                                <td>
                                                    <div class="action-btns">
                                                        <asp:LinkButton ID="lbActivate" runat="server"
                                                            CssClass="btn-activate"
                                                            CommandName="Activate"
                                                            CommandArgument='<%# Eval("UserID") %>'
                                                            OnCommand="AccountAction_Command"
                                                            Visible='<%# Eval("AccountStatus").ToString() == "Inactive" %>'>Activate</asp:LinkButton>
                                                        <asp:LinkButton ID="lbDeactivate" runat="server"
                                                            CssClass="btn-deactivate"
                                                            CommandName="Deactivate"
                                                            CommandArgument='<%# Eval("UserID") %>'
                                                            OnCommand="AccountAction_Command"
                                                            Visible='<%# Eval("AccountStatus").ToString() == "Active" %>'>Deactivate</asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoUsers" runat="server" Visible="false">
                                <div class="empty-state"><div class="empty-icon">👥</div><div class="empty-text">No users found.</div></div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

   
                <div class="panel" id="panel-caregivers">
                    <div class="section-card">
                        <div class="section-card-header">
                            <div class="section-card-title">All Caregivers</div>
                            <div class="filter-bar">
                                <asp:TextBox ID="txtSearchCaregivers" runat="server" CssClass="search-input" placeholder="Search by name or email..." />
                                <asp:Button ID="btnSearchCaregivers" runat="server" Text="Search"
                                    CssClass="btn-search" OnClick="btnSearchCaregivers_Click" />
                            </div>
                        </div>
                        <div style="padding:0;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="padding:14px 16px 12px;">Caregiver</th>
                                        <th style="padding:14px 16px 12px;">Contact</th>
                                        <th style="padding:14px 16px 12px;">Services</th>
                                        <th style="padding:14px 16px 12px;">Rate/hr</th>
                                        <th style="padding:14px 16px 12px;">Bookings</th>
                                        <th style="padding:14px 16px 12px;">Availability</th>
                                        <th style="padding:14px 16px 12px;">Account</th>
                                        <th style="padding:14px 16px 12px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptCaregivers" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-avatar">🧑‍⚕️</div>
                                                        <div>
                                                            <div class="user-name"><%# Eval("FullName") %></div>
                                                            <div class="user-email"><%# Eval("Email") %></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><%# Eval("ContactNo") %></td>
                                                <td style="max-width:160px;font-size:13px;"><%# Eval("ServicesOffered") %></td>
                                                <td style="font-weight:700;">₱<%# String.Format("{0:N2}", Eval("HourlyRate")) %></td>
                                                <td style="text-align:center;font-weight:700;"><%# Eval("TotalBookings") %></td>
                                                <td>
                                                    <span class="status-pill <%# Eval("AvailabilityStatus").ToString().ToLower() == "available" ? "completed" : "cancelled" %>">
                                                        <%# Eval("AvailabilityStatus") %>
                                                    </span>
                                                </td>
                                                <td><span class="status-pill <%# Eval("StatusClass") %>"><%# Eval("AccountStatus") %></span></td>
                                                <td>
                                                    <div class="action-btns">
                                                        <asp:LinkButton ID="lbActivateCg" runat="server"
                                                            CssClass="btn-activate"
                                                            CommandName="Activate"
                                                            CommandArgument='<%# Eval("UserID") %>'
                                                            OnCommand="AccountAction_Command"
                                                            Visible='<%# Eval("AccountStatus").ToString() == "Inactive" %>'>Activate</asp:LinkButton>
                                                        <asp:LinkButton ID="lbDeactivateCg" runat="server"
                                                            CssClass="btn-deactivate"
                                                            CommandName="Deactivate"
                                                            CommandArgument='<%# Eval("UserID") %>'
                                                            OnCommand="AccountAction_Command"
                                                            Visible='<%# Eval("AccountStatus").ToString() == "Active" %>'>Deactivate</asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoCaregivers" runat="server" Visible="false">
                                <div class="empty-state"><div class="empty-icon">🧑‍⚕️</div><div class="empty-text">No caregivers found.</div></div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="toast" id="toast">
            <span>✅</span>
            <span id="toastMsg">Done!</span>
        </div>

        <script>
            function showPanel(name) {
                document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                document.getElementById('panel-' + name).classList.add('active');
                var labels = { overview: 'Overview', bookings: 'Manage Bookings', users: 'Manage Users', caregivers: 'Manage Caregivers' };
                document.getElementById('topbarTitle').textContent = labels[name] || name;
                document.querySelectorAll('.nav-item').forEach(function (el) {
                    if (el.getAttribute('onclick') && el.getAttribute('onclick').includes("'" + name + "'"))
                        el.classList.add('active');
                });
            }

            function showToast(msg) {
                var t = document.getElementById('toast');
                document.getElementById('toastMsg').textContent = msg;
                t.classList.add('show');
                setTimeout(function () { t.classList.remove('show'); }, 3000);
            }

            var serverMsg = '<%= lblAdminMsg.Text %>';
            if (serverMsg && serverMsg.trim() !== '') {
                window.addEventListener('DOMContentLoaded', function () { showToast(serverMsg); });
            }
        </script>

    </form>
</body>
</html>
