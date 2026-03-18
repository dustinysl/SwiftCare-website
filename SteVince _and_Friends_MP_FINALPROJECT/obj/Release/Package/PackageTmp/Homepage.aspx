<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Homepage.aspx.cs" Inherits="SteVince__and_Friends_MP_FINALPROJECT.Homepage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwiftCare  Trusted Short Term Caregiving</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <style>
        :root {
            --blue-dark:    #0a2a4a;
            --blue-mid:     #1565a0;
            --blue-bright:  #1e88e5;
            --teal-dark:    #006064;
            --teal-mid:     #00838f;
            --teal-bright:  #26c6da;
            --teal-light:   #80deea;
            --teal-pale:    #e0f7fa;
            --white:        #ffffff;
            --off-white:    #f4fbfc;
            --text-dark:    #062035;
            --text-mid:     #1a4a62;
            --text-light:   #4a7a92;
            --shadow-sm:    0 2px 8px rgba(10,42,74,0.08);
            --shadow-md:    0 8px 32px rgba(10,42,74,0.14);
            --shadow-lg:    0 20px 60px rgba(10,42,74,0.18);
            --radius:       16px;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body {
            font-family: 'Nunito', sans-serif;
            background: var(--white);
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* ── NAV ── */
        nav {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 5%; height: 90px;
            background: var(--blue-dark);
            box-shadow: 0 2px 16px rgba(10,42,74,0.35);
        }
        .nav-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-logo img { height: 150px; width: auto; object-fit: contain; }
        .nav-actions { display: flex; align-items: center; gap: 12px; }

        /* Login button style */
        .btn-login {
            background: transparent !important;
            border: 2px solid var(--teal-light) !important;
            color: var(--teal-light) !important;
            font-family: 'Nunito', sans-serif !important;
            font-size: 15px !important; font-weight: 700 !important;
            cursor: pointer; padding: 9px 24px !important;
            border-radius: 50px !important;
            transition: all 0.3s;
        }
        .btn-login:hover {
            background: var(--teal-light) !important;
            color: var(--blue-dark) !important;
        }

        /* Sign Up button style */
        .btn-signin {
            background: linear-gradient(135deg, var(--teal-mid), var(--blue-bright)) !important;
            color: white !important;
            border: none !important;
            font-family: 'Nunito', sans-serif !important;
            font-size: 15px !important; font-weight: 700 !important;
            cursor: pointer; padding: 11px 28px !important;
            border-radius: 50px !important;
            transition: all 0.3s;
            box-shadow: 0 4px 14px rgba(38,198,218,0.35);
        }
        .btn-signin:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(38,198,218,0.5) !important;
        }

        /* ── HERO ── */
        .hero {
            position: relative; width: 100%; height: 100vh;
            min-height: 600px; overflow: hidden;
            display: flex; align-items: center;
            padding-top: 90px;
        }
        .hero-bg {
            position: absolute; inset: 0;
            background:
                linear-gradient(to right, rgba(6,32,53,0.82) 0%, rgba(6,32,53,0.55) 55%, rgba(6,32,53,0.2) 100%),
                url('<%=ResolveUrl("~/App Data/Help.jpg")%>') center/cover no-repeat;
            transform: scale(1.04);
            transition: transform 8s ease;
        }
        .hero-bg.loaded { transform: scale(1); }
        .hero-content {
            position: relative; z-index: 1;
            padding: 0 7%; max-width: 700px;
            animation: heroFadeIn 1s ease forwards; opacity: 0;
        }
        @keyframes heroFadeIn {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 10px;
            background: rgba(38,198,218,0.18);
            border: 1px solid rgba(38,198,218,0.4);
            color: var(--teal-light);
            padding: 12px 26px; border-radius: 50px;
            font-size: 18px; font-weight: 700;
            margin-bottom: 28px; letter-spacing: 0.5px;
        }
        .badge-dot { width: 10px; height: 10px; border-radius: 50%; background: var(--teal-bright); animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.4;transform:scale(1.4);} }
        .hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: clamp(36px, 5vw, 64px); font-weight: 800;
            color: white; line-height: 1.1; letter-spacing: -1px;
            margin-bottom: 20px; text-shadow: 0 2px 24px rgba(0,0,0,0.3);
        }
        .hero h1 span { color: var(--teal-bright); }
        .hero-sub {
            font-size: clamp(15px, 1.6vw, 18px); color: rgba(255,255,255,0.85);
            line-height: 1.75; max-width: 520px; font-weight: 400;
        }

        /* ── SECTIONS ── */
        .section { padding: 90px 7%; }
        .section-alt { background: var(--off-white); }
        .section-header { margin-bottom: 52px; }
        .section-label { display: inline-block; font-size: 18px; font-weight: 800; text-transform: uppercase; letter-spacing: 2.5px; color: var(--teal-mid); margin-bottom: 12px; }
        .section-title { font-family: 'Montserrat', sans-serif; font-size: clamp(26px, 3vw, 42px); font-weight: 800; line-height: 1.15; letter-spacing: -0.5px; color: var(--text-dark); margin-bottom: 14px; }
        .section-sub { font-size: 25px; color: var(--text-mid); max-width: 520px; line-height: 1.75; }

        /* Steps */
        .steps-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 28px; }
        .step-card { background: white; border-radius: var(--radius); padding: 36px 28px; border: 2px solid var(--teal-pale); position: relative; transition: all 0.3s ease; }
        .step-card:hover { border-color: var(--teal-bright); transform: translateY(-6px); box-shadow: var(--shadow-md); }
        .step-number { font-family: 'Montserrat',sans-serif; font-size: 52px; font-weight: 800; color: var(--teal-mid); line-height: 1; margin-bottom: 16px; }

        .step-title { font-size: 30px; font-weight: 800; color: var(--text-dark); margin-bottom: 10px; }
        .step-desc { font-size: 25px; color: var(--text-mid); line-height: 1.75; }
        .step-connector { position: absolute; right: -15px; top: 50%; transform: translateY(-50%); color: var(--teal-light); font-size: 22px; z-index: 1; }

        /* Services */
        .services-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; }
        .service-card { background: white; border-radius: var(--radius); padding: 32px 24px; text-align: center; border: 2px solid var(--teal-pale); }
        .service-icon-wrap { width: 223px; height: 206px; border-radius: 12px; overflow: hidden; margin: 0 auto 18px; }
        .service-icon-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .service-title { font-size: 30px; font-weight: 800; color: var(--text-dark); margin-bottom: 10px; }
        .service-desc { font-size: 25px; color: var(--text-mid); line-height: 1.65; }

        /* CTA Banner */
        .cta-banner { background: linear-gradient(135deg, var(--blue-dark) 0%, var(--teal-dark) 100%); padding: 80px 7%; display: grid; grid-template-columns: 1fr 1fr; gap: 60px; align-items: center; position: relative; overflow: hidden; }
        .cta-banner::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 60% 80% at 80% 50%, rgba(38,198,218,0.12) 0%, transparent 70%); }
        .cta-banner-content { position: relative; z-index: 1; }
        .cta-banner h2 { font-family: 'Montserrat',sans-serif; font-size: clamp(24px,3vw,38px); font-weight: 800; color: white; line-height: 1.2; margin-bottom: 14px; }
        .cta-banner p { font-size: 16px; color: rgba(255,255,255,0.7); line-height: 1.7; margin-bottom: 30px; }
        .cta-banner-btns { display: flex; gap: 14px; flex-wrap: wrap; }
        .btn-white { display: inline-flex; align-items: center; background: white; color: var(--blue-dark); font-family: 'Nunito',sans-serif; font-size: 15px; font-weight: 700; padding: 13px 30px; border-radius: 50px; text-decoration: none; border: none; cursor: pointer; transition: all 0.3s; }
        .btn-white:hover { background: var(--teal-pale); transform: translateY(-1px); }
        .btn-outline-white { display: inline-flex; align-items: center; background: transparent; color: white; font-family: 'Nunito',sans-serif; font-size: 15px; font-weight: 600; padding: 13px 30px; border-radius: 50px; text-decoration: none; border: 2px solid rgba(255,255,255,0.5); cursor: pointer; transition: all 0.3s; }
        .btn-outline-white:hover { border-color: white; background: rgba(255,255,255,0.1); }
        .cta-card { background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.13); border-radius: var(--radius); padding: 28px; position: relative; z-index: 1; }
        .cta-card-title { font-size: 30px; font-weight: 700; color: white; margin-bottom: 20px; }
        .cta-perk { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; }
        .perk-icon { width: 34px; height: 34px; background: var(--teal-mid); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 15px; flex-shrink: 0; }
        .perk-text { font-size: 25px; color: rgba(255,255,255,0.85); }

        /* Testimonials */
        .testimonials-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 24px; }
        .testimonial-card { background: white; border-radius: var(--radius); padding: 32px; border: 2px solid var(--teal-pale); transition: all 0.3s ease; }
        .testimonial-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); border-color: var(--teal-bright); }
        .testimonial-stars { color: #f4a535; font-size: 16px; margin-bottom: 14px; }
        .testimonial-text { font-size: 18px; color: var(--text-mid); line-height: 1.75; margin-bottom: 22px; font-style: italic; }
        .testimonial-author { display: flex; align-items: center; gap: 12px; }
        .author-avatar { width: 44px; height: 44px; border-radius: 50%; background: var(--teal-pale); display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .author-name { font-weight: 700; font-size: 14px; color: var(--text-dark); }
        .author-role { font-size: 20px; color: var(--text-light); }

        /* Footer */
        footer { background: var(--blue-dark); color: rgba(255,255,255,0.6); padding: 60px 7% 28px; }
        .footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; margin-bottom: 44px; }
        .footer-logo { height: 150px; width: auto; object-fit: contain; margin-bottom: 16px; display: block; }
        .footer-brand-desc { font-size: 14px; line-height: 1.7; color: rgba(255,255,255,0.45); }
        .footer-col-title { font-size: 12px; font-weight: 800; text-transform: uppercase; letter-spacing: 1.5px; color: white; margin-bottom: 18px; }
        .footer-links { list-style: none; }
        .footer-links li { margin-bottom: 10px; }
        .footer-links span { font-size: 14px; color: rgba(255,255,255,0.45); cursor: default; }
        .footer-bottom { border-top: 1px solid rgba(255,255,255,0.08); padding-top: 22px; display: flex; justify-content: space-between; align-items: center; }
        .footer-bottom p { font-size: 13px; color: rgba(255,255,255,0.28); }

        /* Responsive */
        @media (max-width: 900px) {
            .steps-grid, .services-grid, .testimonials-grid { grid-template-columns: 1fr 1fr; }
            .cta-banner { grid-template-columns: 1fr; }
            .footer-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 600px) {
            .steps-grid, .services-grid, .testimonials-grid { grid-template-columns: 1fr; }
            .footer-grid { grid-template-columns: 1fr; }
            .hero h1 { font-size: 34px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- NAV -->
        <nav>
            <a href="Homepage.aspx" class="nav-logo">
                <img src="<%=ResolveUrl("~/App Data/No_Bg_Logo.png")%>" alt="SwiftCare Logo" />
            </a>
            <div class="nav-actions">
                <asp:Button ID="btnLogin" runat="server" Text="Log in"
                    CssClass="btn-login"
                    OnClick="btnLogin_Click" />
                <asp:Button ID="btnSignUp" runat="server" Text="Sign Up"
                    CssClass="btn-signin"
                    OnClick="btnSignUp_Click" />
            </div>
        </nav>

        <!-- HERO -->
        <section class="hero">
            <div class="hero-bg" id="heroBg"></div>
            <div class="hero-content">
                <div class="hero-badge">
                    <div class="badge-dot"></div>
                    Verified caregivers, available now
                </div>
                <h1>Connecting families with <span>trusted</span> local caregivers</h1>
                <p class="hero-sub">
                    Find verified caregivers for childcare, elderly care, pet sitting, and more
                    available on short notice, no long contracts required.
                </p>
            </div>
        </section>

        <!-- HOW IT WORKS -->
        <section class="section section-alt">
            <div class="section-header">
                <div class="section-label">How It Works</div>
                <h2 class="section-title">Care in 3 simple steps</h2>
                <p class="section-sub">Getting the right caregiver for your needs has never been easier or faster.</p>
            </div>
            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-number">01</div>
                    <div class="step-title">Create Your Account</div>
                    <div class="step-desc">Sign up in minutes and tell us what kind of care you need childcare, elderly support, pet care, and more.</div>
                    <div class="step-connector">→</div>
                </div>
                <div class="step-card">
                    <div class="step-number">02</div>
                    <div class="step-title">Browse & Choose</div>
                    <div class="step-desc">View detailed caregiver profiles with ratings, reviews, availability, and hourly rates. Pick the perfect fit.</div>
                    <div class="step-connector">→</div>
                </div>
                <div class="step-card">
                    <div class="step-number">03</div>
                    <div class="step-title">Book Instantly</div>
                    <div class="step-desc">Confirm your booking in seconds. Your caregiver arrives ready to help  whether it's today or next week.</div>
                </div>
            </div>
        </section>

        <!-- SERVICES -->
        <section class="section">
            <div class="section-header">
                <div class="section-label">Our Services</div>
                <h2 class="section-title">Every kind of care, all in one place</h2>
                <p class="section-sub">From urgent babysitting to long-term pet sitting, SwiftCare has caregivers ready for every situation.</p>
            </div>
            <div class="services-grid">
                <div class="service-card">
                    <div class="service-icon-wrap"><img src="<%=ResolveUrl("~/App Data/ChildCare.png")%>" alt="Child Care" /></div>
                    <div class="service-title">Child Care</div>
                    <div class="service-desc">Safe, nurturing babysitters and nannies available on short notice.</div>
                </div>
                <div class="service-card">
                    <div class="service-icon-wrap"><img src="<%=ResolveUrl("~/App Data/ElderlyCare.png")%>" alt="Elderly Care" /></div>
                    <div class="service-title">Elderly Care</div>
                    <div class="service-desc">Compassionate companions and assistants for senior family members.</div>
                </div>
                <div class="service-card">
                    <div class="service-icon-wrap"><img src="<%=ResolveUrl("~/App Data/PetCare.png")%>" alt="Pet Care" /></div>
                    <div class="service-title">Pet Care</div>
                    <div class="service-desc">Loving pet sitters and dog walkers who treat your pets like family.</div>
                </div>
                <div class="service-card">
                    <div class="service-icon-wrap"><img src="<%=ResolveUrl("~/App Data/HouseSitting.png")%>" alt="House Sitting" /></div>
                    <div class="service-title">House Sitting</div>
                    <div class="service-desc">Trusted house sitters to keep your home safe while you're away.</div>
                </div>
                <div class="service-card">
                    <div class="service-icon-wrap"><img src="<%=ResolveUrl("~/App Data/SpecialNeeds.png")%>" alt="Special Needs Care" /></div>
                    <div class="service-title">Special Needs Care</div>
                    <div class="service-desc">Trained caregivers who support individuals with disabilities with dignity.</div>
                </div>
            </div>
        </section>

        <!-- TESTIMONIALS -->
        <section class="section section-alt">
            <div class="section-header">
                <div class="section-label">Testimonials</div>
                <h2 class="section-title">Families love SwiftCare</h2>
                <p class="section-sub">Real stories from real families who found the care they needed fast.</p>
            </div>
            <div class="testimonials-grid">
                <div class="testimonial-card">
                    <div class="testimonial-stars">★★★★★</div>
                    <p class="testimonial-text">"I needed a babysitter urgently for a work meeting and found Maria through SwiftCare within 20 minutes. She was wonderful with my kids!"</p>
                    <div class="testimonial-author"><div class="author-avatar">👩</div><div><div class="author-name">Steven Clarks</div><div class="author-role">Parent, Binan City</div></div></div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-stars">★★★★★</div>
                    <p class="testimonial-text">"SwiftCare made it easy to find a trustworthy person for my aging mother. The verification process gave me complete peace of mind."</p>
                    <div class="testimonial-author"><div class="author-avatar">👨</div><div><div class="author-name">Vince Cervantes</div><div class="author-role">Son & Caregiver, Kanto City</div></div></div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-stars">★★★★★</div>
                    <p class="testimonial-text">"As a caregiver, SwiftCare gave me the flexibility to earn extra income on my own schedule. The platform is easy and clients are respectful."</p>
                    <div class="testimonial-author"><div class="author-avatar">👩‍🦰</div><div><div class="author-name">Jc Raymundo</div><div class="author-role">Caregiver, Sulok City</div></div></div>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer>
            <div class="footer-grid">
                <div>
                    <img src="<%=ResolveUrl("~/App Data/No_Bg_Logo.png")%>" alt="SwiftCare" class="footer-logo" />
                    <p class="footer-brand-desc">Connecting families with verified short-term caregivers across the Philippines. Fast, reliable, and trusted.</p>
                </div>
                <div>
                    <div class="footer-col-title">Services</div>
                    <ul class="footer-links">
                        <li><span>Child Care</span></li>
                        <li><span>Elderly Care</span></li>
                        <li><span>Pet Care</span></li>
                        <li><span>House Sitting</span></li>
                        <li><span>Special Needs</span></li>
                    </ul>
                </div>
                <div>
                    <div class="footer-col-title">Company</div>
                    <ul class="footer-links">
                        <li><span>About Us</span></li>
                        <li><span>How It Works</span></li>
                        <li><span>Become a Caregiver</span></li>
                        <li><span>Safety Center</span></li>
                    </ul>
                </div>
                <div>
                    <div class="footer-col-title">Support</div>
                    <ul class="footer-links">
                        <li><span>Help Center</span></li>
                        <li><span>Contact Us</span></li>
                        <li><span>Privacy Policy</span></li>
                        <li><span>Terms of Service</span></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>© 2026 SwiftCare. All rights reserved.</p>
                <p>Made with 💙 for Filipino families</p>
            </div>
        </footer>

        <script>
            const heroBg = document.getElementById('heroBg');
            window.addEventListener('load', () => heroBg.classList.add('loaded'));
        </script>

    </form>
</body>
</html>
