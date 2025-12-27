<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page import="com.mycompany.salon.model.entity.Booking"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ambil data dari request attribute (dikirim oleh AdminController)
    List<Pelanggan> pelangganList = (List<Pelanggan>) request.getAttribute("pelangganList");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .admin-wrapper {
            width: 95%;
            max-width: 1200px;
            margin: 0 auto;
            padding-top: 50px;
            padding-bottom: 50px;
        }
        
        /* Menu Navigasi Admin Atas */
        .admin-nav-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }

        .nav-card {
            background: rgba(0, 0, 0, 0.8); /* Warna hitam elegan sesuai branding */
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 20px;
            text-align: center;
            color: white;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .nav-card:hover {
            background: #000;
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .glass-panel {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 30px;
        }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid rgba(0,0,0,0.1); color: #000; font-weight: 700; }
        td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.3); color: #333; }
        
        .badge-member { background: #d4af37; color: white; padding: 4px 10px; border-radius: 10px; font-size: 0.8rem; font-weight: bold; }
        
        /* Profile Icon khusus Admin */
        .profile-icon {
            position: fixed;
            top: 40px;
            right: 5%;
            width: 65px;
            height: 65px;
            border-radius: 50%;
            border: 3px solid #000;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            z-index: 1000;
        }
        .profile-icon img { width: 100%; height: 100%; object-fit: cover; }

        .btn-logout {
            background: #d8000c;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .menu-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: transform 0.3s, background 0.3s;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.4);
        }

        .menu-card i {
            font-size: 2rem;
            display: block;
            margin-bottom: 10px;
        }

        .menu-card span {
            font-weight: 600;
            font-size: 1.1rem;
        }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">

    <a href="${pageContext.request.contextPath}/profile">
        <div class="profile-icon">
            <img src="${pageContext.request.contextPath}/assets/img/profile.png" alt="Admin Profile">
        </div>
    </a>

    <div class="admin-wrapper">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700; color: #000;">Admin Management</h1>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">LOGOUT</a>
        </div>

        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/admin/katalog" class="menu-card">
                <span>✂️ Kelola Layanan</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/kapster" class="menu-card">
                <span>💈 Kelola Kapster</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/pengguna" class="menu-card">
                <span>👥 Kelola Pengguna</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/promo" class="menu-card">
                <span>🎟️ Kelola Promo</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/report" class="menu-card" style="background: rgba(255, 255, 255, 0.3); border: 2px solid #000;">
                <span>📊 Laporan </span>
            </a>
        </div>

        <div class="glass-panel">
            <h3 style="margin-bottom: 15px;">Daftar Pelanggan Terdaftar</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nama</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th>Poin</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (pelangganList != null) { 
                        for (Pelanggan plg : pelangganList) { %>
                        <tr>
                            <td><%= plg.getId() %></td>
                            <td><strong><%= plg.getNama() %></strong></td>
                            <td><%= plg.getEmail() %></td>
                            <td>
                                <% if(plg.isMember()) { %>
                                    <span class="badge-member">Member Premium</span>
                                <% } else { %>
                                    <span style="color: #666;">Reguler</span>
                                <% } %>
                            </td>
                            <td><%= plg.getPoinLoyalty() %> pts</td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <div class="glass-panel">
            <h3 style="margin-bottom: 15px;">Permintaan Booking Terbaru</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Pelanggan</th>
                        <th>Kapster</th>
                        <th>Tanggal</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bookings != null) { 
                        for (Booking b : bookings) { %>
                        <tr>
                            <td>#<%= b.getId() %></td>
                            <td><%= b.getPelanggan().getNama() %></td>
                            <td><%= b.getKapster().getNama() %></td>
                            <td><%= b.getTanggal().toString().replace("T", " ") %></td>
                            <td><strong><%= b.getStatus() %></strong></td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>