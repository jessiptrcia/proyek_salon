<%@page import="com.mycompany.salon.model.entity.Pengguna"%>
<%@page import="com.mycompany.salon.model.entity.Admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Pastikan user adalah Admin
    Pengguna user = (Pengguna) session.getAttribute("user");
    Admin admin = null;
    
    if (user instanceof Admin) {
        admin = (Admin) user;
    } else {
        // Jika bukan admin, tendang ke login
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String status = request.getParameter("status");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Admin Profile | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .profile-wrapper { width: 90%; max-width: 800px; margin: 50px auto; }
        .glass-container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .info-group { margin-bottom: 20px; }
        .info-label { display: block; font-weight: 600; color: #000; margin-bottom: 5px; }
        .info-box { 
            padding: 12px 20px; 
            background: rgba(255, 255, 255, 0.4); 
            border-radius: 12px; 
            color: #333;
        }
        .badge-admin { background: #000; color: #fff; padding: 2px 10px; border-radius: 10px; font-size: 0.8rem; }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">

    <div class="profile-wrapper">
        <div class="glass-container">
            <div style="text-align: center; margin-bottom: 30px;">
                <h1 style="font-size: 2.5rem; font-weight: 700;">Admin Settings</h1>
                <p>Kelola kredensial akses sistem Glamora</p>
            </div>

            <% if ("updated".equals(status)) { %>
                <div class="alert-success" style="padding:10px; border-radius:10px; margin-bottom:20px; text-align:center;">
                    ✅ Profil Admin berhasil diperbarui!
                </div>
            <% } %>

            <div class="info-group">
                <span class="info-label">Username</span>
                <div class="info-box"><%= admin.getUsername() %> <span class="badge-admin">Root Access</span></div>
            </div>

            <div class="info-group">
                <span class="info-label">Email Terdaftar</span>
                <div class="info-box"><%= admin.getEmail() %></div>
            </div>

            <div class="info-group">
                <span class="info-label">No. Telepon Support</span>
                <div class="info-box"><%= admin.getPhone() %></div>
            </div>

            <div style="display: flex; gap: 15px; margin-top: 40px;">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-glass" style="width: auto; background: rgba(0,0,0,0.1);">Kembali</a>
                <button onclick="document.getElementById('editSection').style.display='block'" class="btn-glass" style="width: auto;">Update Info</button>
                <button onclick="document.getElementById('passSection').style.display='block'" class="btn-glass" style="width: auto;">Ganti Password</button>
            </div>

            <div id="editSection" style="display:none; margin-top: 30px; border-top: 1px solid rgba(0,0,0,0.1); padding-top: 20px;">
                <h3>Update Profil Admin</h3>
                <form action="${pageContext.request.contextPath}/profile/update" method="POST">
                    <input type="hidden" name="username" value="<%= admin.getUsername() %>">
                    <input type="email" name="email" class="input-glass" value="<%= admin.getEmail() %>" required style="margin: 10px 0;">
                    <input type="text" name="phone" class="input-glass" value="<%= admin.getPhone() %>" required>
                    <button type="submit" class="btn-glass" style="margin-top: 10px;">Simpan Perubahan</button>
                </form>
            </div>
            
            <div id="passSection" style="display:none; margin-top: 30px; border-top: 1px solid rgba(0,0,0,0.1); padding-top: 20px;">
                <h3>Ganti Password Keamanan</h3>
                <form action="${pageContext.request.contextPath}/profile/password" method="POST">
                    <input type="password" name="oldPassword" class="input-glass" placeholder="Password Lama" required style="margin: 10px 0;">
                    <input type="password" name="newPassword" class="input-glass" placeholder="Password Baru" required>
                    <input type="password" name="confirmPassword" class="input-glass" placeholder="Konfirmasi Password Baru" required style="margin: 10px 0;">
                    <button type="submit" class="btn-glass" style="margin-top: 10px;">Update Password</button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>