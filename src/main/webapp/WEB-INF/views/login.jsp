<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Ambil URI asli dari browser (menangani internal forward)
    String forwardUri = (String) request.getAttribute("javax.servlet.forward.request_uri");
    String uri = (forwardUri != null) ? forwardUri : request.getRequestURI();
    
    // 2. DEKLARASI: Variabel deteksi untuk tiap menu dan mode card
    boolean isAbout    = uri.contains("/about_us");
    boolean isServices = uri.contains("/services");
    boolean isStore    = uri.contains("/store");
    boolean isHelp     = uri.contains("/help");
    
    // Deteksi apakah sedang di halaman register/signup
    boolean isSignup   = uri.contains("/register");
    
    // Tentukan suffix URL berdasarkan mode saat ini agar navigasi "terkunci"
    String authMode = isSignup ? "/register" : "/login";
    
    // Default Content
    String slogan = "Tampil Elegan,<br>Salon Glamor";
    String desc = "Salon & Spa Premium untuk perawatan rambut modern dan relaksasi total. Rasakan sentuhan kemewahan yang membuatmu tampil lebih percaya diri.";
    
    // Judul Tab Browser dinamis
    String currentMenu = isSignup ? "Sign Up" : "Log In";

    // 3. Logika Penggantian Konten Berdasarkan Variabel
    if (isAbout) {
        if(!isSignup) currentMenu = "About Us";
    } else if (isServices) {
        if(!isSignup) currentMenu = "Services";
    } else if (isStore) {
        currentMenu = isSignup ? "Sign Up" : "Store";
    } else if (isHelp) {
        if(!isSignup) currentMenu = "Help";
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= currentMenu %> | Glamora Salon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="components/navbar.jsp">
        <jsp:param name="authMode" value="<%= authMode %>" />
    </jsp:include>

    <section class="hero-container">
        <%-- Class dinamis untuk mengatur layout sisi kiri --%>
        <div class="text-section <%= isServices ? "text-services" : (isStore || isHelp ? "text-store" : "text-login") %>">

            <% if (isServices) { %>
                <%-- GRID SERVICES --%>
                <div class="services-container-grid">
                    <div class="service-item-card">
                        <div class="service-image-placeholder">
                            <img src="${pageContext.request.contextPath}/assets/img/service1.jpg" alt="Hair Cuts">
                        </div>
                        <p>Hair Cuts & Styling</p>
                    </div>
                    <div class="service-item-card">
                        <div class="service-image-placeholder">
                            <img src="${pageContext.request.contextPath}/assets/img/service2.jpg" alt="Coloring">
                        </div>
                        <p>Coloring</p>
                    </div>
                    <div class="service-item-card">
                        <div class="service-image-placeholder">
                            <img src="${pageContext.request.contextPath}/assets/img/service3.jpg" alt="Hair Treatments">
                        </div>
                        <p>Hair Treatments</p>
                    </div>
                    <div class="service-item-card">
                        <div class="service-image-placeholder">
                            <img src="${pageContext.request.contextPath}/assets/img/service4.jpg" alt="Add-ons">
                        </div>
                        <p>Add-ons</p>
                    </div>
                </div>

            <% } else if (isStore) { %>
                <%-- TAMPILAN STORE (Find Us) --%>
                <div class="store-location-container">
                    <h1 class="store-title">Find Us</h1>
                    <div class="city-section">
                        <h3>Jakarta:</h3>
                        <div class="location-item">1. <strong>Glamora Senopati</strong>, <a href="https://maps.google.com" target="_blank">Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan.</a></div>
                        <div class="location-item">2. <strong>Glamora PIK</strong>, <a href="https://maps.google.com" target="_blank">Ruko Golf Island No. 12, Pantai Indah Kapuk, Jakarta Utara.</a></div>
                    </div>
                    <div class="city-section">
                        <h3>Bandung:</h3>
                        <div class="location-item">1. <strong>Glamora Dago Heritage</strong>, <a href="https://maps.google.com" target="_blank">Jl. Ir. H. Juanda (Dago) No. 102, Coblong, Bandung.</a></div>
                        <div class="location-item">2. <strong>Glamora Mantraman</strong>, <a href="https://maps.google.com" target="_blank">Jl. Matraman No. 332, Lengkong, Bandung.</a></div>
                    </div>
                    <div class="city-section">
                        <h3>Medan:</h3>
                        <div class="location-item">1. <strong>Glamora Polonia</strong>, <a href="https://maps.google.com" target="_blank">Jl. Walikota No. 8, Polonia, Kota Medan, Sumatera Utara.</a></div>
                    </div>
                </div>

            <% } else if (isHelp) { %>
                <%-- TAMPILAN HELP (Kontak Admin dengan Link WA) --%>
                <div class="store-location-container help-section">
                    <p class="help-pre-title">Butuh Bantuan Lebih Lanjut?</p>
                    <h1 class="store-title">Hubungi Cabang Segera</h1>
                    <div class="city-section">
                        <div class="location-item">
                            <strong>Kontak Admin Jakarta Selatan:</strong> 
                            <a href="https://wa.me/6283340003003" target="_blank">+62 833 4000 3003</a>
                        </div>
                        <div class="location-item">
                            <strong>Kontak Admin Jakarta Utara:</strong> 
                            <a href="https://wa.me/6283340004003" target="_blank">+62 833 4000 4003</a>
                        </div>
                        <div class="location-item">
                            <strong>Kontak Admin Bandung:</strong> 
                            <a href="https://wa.me/6283340005003" target="_blank">+62 833 4000 5003</a>
                        </div>
                        <div class="location-item">
                            <strong>Kontak Admin Medan:</strong> 
                            <a href="https://wa.me/6283340007003" target="_blank">+62 833 4000 7003</a>
                        </div>
                    </div>
                </div>
            <% } else { %>
                <%-- TAMPILAN DEFAULT --%>
                <h1><%= slogan %></h1>
                <p><%= desc %></p>
            <% } %>

        </div>

        <div class="login-card-glass <%= isSignup ? "card-signup" : "card-login" %>">
            <% if (isSignup) { %>
                <h2>Sign Up</h2>
                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <input type="text" name="nama" class="input-glass" placeholder="Nama Lengkap" required>
                    <input type="text" name="username" class="input-glass" placeholder="Username" required>
                    <input type="email" name="email" class="input-glass" placeholder="Email" required>
                    <input type="password" name="password" class="input-glass" placeholder="Password" required>
                    <button type="submit" class="btn-glass">Daftar Sekarang</button>
                </form>
                <div class="register-link">
                    Sudah punya akun? 
                    <% String loginPath = isAbout ? "/about_us/login" : (isServices ? "/services/login" : (isStore ? "/store/login" : (isHelp ? "/help/login" : "/login"))); %>
                    <a href="${pageContext.request.contextPath}<%= loginPath %>">Masuk sekarang!</a>
                </div>
            <% } else { %>
                <h2>Log In</h2>
                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <input type="text" name="username" class="input-glass" placeholder="Username" required>
                    <input type="password" name="password" class="input-glass" placeholder="Password" required>
                    <button type="submit" class="btn-glass">Sign In</button>
                </form>
                <div class="register-link">
                    Belum punya akun? 
                    <% String regPath = isAbout ? "/about_us/register" : (isServices ? "/services/register" : (isStore ? "/store/register" : (isHelp ? "/help/register" : "/register"))); %>
                    <a href="${pageContext.request.contextPath}<%= regPath %>">Daftar sekarang!</a>
                </div>
            <% } %>
        </div>
    </section>
</body>
</html>