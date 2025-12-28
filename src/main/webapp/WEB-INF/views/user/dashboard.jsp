<%@page import="com.mycompany.salon.model.entity.Booking"%>
<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page import="com.mycompany.salon.model.entity.Katalog"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Ambil data pelanggan dari session
    Pelanggan p = (Pelanggan) session.getAttribute("user");
    
    // 2. Ambil data ringkasan dari request attribute
    Booking jadwalAktif = (Booking) request.getAttribute("jadwalAktif");
    Booking riwayatTerakhir = (Booking) request.getAttribute("riwayatTerakhir");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Pelanggan | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .dashboard-wrapper {
            width: 90%;
            max-width: 1100px;
            margin: 0 auto;
            text-align: center;
            padding-top: 50px;
        }
        .welcome-text {
            font-size: 2.8rem;
            font-weight: 600;
            margin-bottom: 50px;
            color: #000;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
        }
        .card-glass {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 25px;
            padding: 35px;
            text-align: left;
            min-height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.3s ease;
        }
        .card-glass:hover { transform: translateY(-5px); }
        .card-glass h3 { font-size: 1.6rem; font-weight: 700; margin-bottom: 15px; color: #1a1a1a; }
        .card-content { font-size: 1rem; color: #444; margin-bottom: 15px; line-height: 1.5; }
        
        /* Tombol warna krem sesuai gambar */
        .btn-action {
            background: #e1b382; 
            color: #fff;
            padding: 12px 25px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            width: fit-content;
            transition: background 0.3s;
        }
        .btn-action:hover { background: #d4a373; }

        .profile-icon {
            position: fixed;
            top: 40px;
            right: 5%;
            width: 65px;
            height: 65px;
            border-radius: 50%;
            border: 3px solid #fff;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .profile-icon img { width: 100%; height: 100%; object-fit: cover; }
        
        .status-badge { font-weight: 600; color: #000; }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <jsp:include page="../components/navbar_pelanggan.jsp" />

    <a href="${pageContext.request.contextPath}/profile">
        <div class="profile-icon">
            <img src="${pageContext.request.contextPath}/assets/img/profile.png" alt="Profile">
        </div>
    </a>
    <div class="dashboard-wrapper">
        <h1 class="welcome-text">Selamat Datang, <%= p.getNama() %>! ✨</h1>

        <div class="dashboard-grid">
            <div class="card-glass">
                <div>
                    <h3>Jadwal Saya</h3>
                    <div class="card-content">
                        <% if (jadwalAktif != null) { %>
                            <strong><%= jadwalAktif.getKapster().getNama() %></strong><br>
                            <span><%= jadwalAktif.getTanggal().toString().replace("T", " ") %></span>
                        <% } else { %>
                            Tidak ada jadwal aktif saat ini.
                        <% } %>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/booking/form" class="btn-action">Booking Sekarang!</a>
            </div>

            <div class="card-glass">
                <div>
                    <h3>Status Member</h3>
                    <div class="card-content">
                        <span style="font-size: 1.5rem; margin-right: 5px;">👑</span> 
                        <span class="status-badge"><%= p.isMember() ? "Member Premium" : "Non-Member" %></span>
                    </div>
                </div>
                <a href="#" class="btn-action">Daftar Member</a>
            </div>

            <div class="card-glass">
                <div>
                    <h3>Riwayat Terakhir</h3>
                    <div class="card-content">
                        <% if (riwayatTerakhir != null) { %>
                            Booking ID #<%= riwayatTerakhir.getId() %><br>
                            Status: <strong><%= riwayatTerakhir.getStatus() %></strong>
                        <% } else { %>
                            Tidak ada riwayat pemesanan.
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="card-glass">
                <div>
                    <h3>Stylist Favorit</h3>
                    <div class="card-content">
                        <% if (riwayatTerakhir != null) { %>
                            <strong><%= riwayatTerakhir.getKapster().getNama() %></strong><br>
                            <span style="font-size: 0.85rem;"><%= riwayatTerakhir.getKapster().getSpesialisasi() %></span>
                        <% } else { %>
                            Tidak ada riwayat pemesanan.
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>