<%@page import="com.mycompany.salon.model.entity.Pengguna"%>
<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page import="com.mycompany.salon.model.entity.Admin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Pengguna user = (Pengguna) session.getAttribute("user");
    
    String nama = "";
    String username = "";
    String email = "";
    String phone = "";
    String role = "";
    
    if (user != null) {
        username = user.getUsername() != null ? user.getUsername() : "";
        email = user.getEmail() != null ? user.getEmail() : "";
        phone = user.getPhone() != null ? user.getPhone() : "";
        role = user.getRole() != null ? user.getRole() : "";
        
        if (user instanceof Pelanggan) {
            Pelanggan pelanggan = (Pelanggan) user;
            nama = pelanggan.getNama() != null ? pelanggan.getNama() : username;
        } else if (user instanceof Admin) {
            Admin admin = (Admin) user;
            nama = username; // Admin pakai username sebagai nama
        }
    }
    
    String status = request.getParameter("status");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg');
            background-size: cover;
            background-attachment: fixed;
            min-height: 100vh;
        }
        
        .profile-wrapper {
            width: 90%;
            max-width: 850px;
            margin: 0 auto;
            padding-top: 50px;
            padding-bottom: 80px;
        }
        
        .profile-container {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .profile-header h1 {
            font-size: 2.2rem;
            color: #000;
            margin-bottom: 10px;
        }
        
        .profile-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .profile-info {
            margin-bottom: 40px;
        }
        
        .info-item {
            margin-bottom: 25px;
        }
        
        .info-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
            font-size: 1.1rem;
        }
        
        .info-value {
            display: block;
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            border: 2px solid #ddd;
            font-size: 1rem;
            color: #333;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
        }
        
        .form-input {
            width: 100%;
            padding: 14px 20px;
            border-radius: 15px;
            border: 2px solid #ddd;
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
            transition: all 0.3s;
            background: rgba(255, 255, 255, 0.8);
        }
        
        .form-input:focus {
            outline: none;
            border-color: #e1b382;
            box-shadow: 0 0 0 3px rgba(225, 179, 130, 0.2);
        }
        
        .btn {
            padding: 16px 40px;
            border-radius: 30px;
            border: none;
            font-family: 'Poppins', sans-serif;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-block;
            text-decoration: none;
            text-align: center;
        }
        
        .btn-primary {
            background: #e1b382;
            color: white;
        }
        
        .btn-primary:hover {
            background: #d4a373;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #8a7f70;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7a7164;
        }
        
        .alert {
            padding: 15px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
        }
        
        .alert-success {
            background: rgba(0, 255, 0, 0.1);
            color: #28a745;
            border: 2px solid rgba(0, 255, 0, 0.2);
        }
        
        .alert-error {
            background: rgba(255, 0, 0, 0.1);
            color: #d8000c;
            border: 2px solid rgba(255, 0, 0, 0.2);
        }
        
        .role-badge {
            display: inline-block;
            padding: 5px 15px;
            background: #e1b382;
            color: white;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        @media (max-width: 768px) {
            .profile-wrapper {
                width: 95%;
                padding-top: 30px;
            }
            
            .profile-container {
                padding: 25px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <jsp:include page="../components/navbar_pelanggan.jsp" />
    
    <div class="profile-wrapper">
        <div class="profile-container">
            <div class="profile-header">
                <h1>👤 Profil Pengguna</h1>
                <p>Kelola informasi akun Anda</p>
            </div>
            
            <% if (status != null) { %>
            <div class="alert alert-success">
                <% 
                    switch(status) {
                        case "updated":
                            out.print("✅ Profil berhasil diperbarui!");
                            break;
                        case "password_changed":
                            out.print("✅ Password berhasil diubah!");
                            break;
                        default:
                            out.print("✅ Operasi berhasil!");
                    }
                %>
            </div>
            <% } %>
            
            <% if (error != null) { %>
            <div class="alert alert-error">
                <% 
                    switch(error) {
                        case "failed":
                            out.print("❌ Gagal memperbarui profil.");
                            break;
                        case "wrong_password":
                            out.print("❌ Password lama salah.");
                            break;
                        case "password_mismatch":
                            out.print("❌ Password baru tidak cocok.");
                            break;
                        default:
                            out.print("❌ Terjadi kesalahan.");
                    }
                %>
            </div>
            <% } %>
            
            <div class="profile-info">
                <div class="info-item">
                    <span class="info-label">Nama Lengkap</span>
                    <span class="info-value"><%= nama %></span>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Username</span>
                    <span class="info-value"><%= username %></span>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Email</span>
                    <span class="info-value"><%= email.isEmpty() ? "Belum diatur" : email %></span>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Nomor Telepon</span>
                    <span class="info-value"><%= phone.isEmpty() ? "Belum diatur" : phone %></span>
                </div>
                
                <div class="info-item">
                    <span class="info-label">Role</span>
                    <span class="info-value">
                        <%= role.isEmpty() ? "Pelanggan" : role %>
                        <span class="role-badge"><%= role.isEmpty() ? "PELANGGAN" : role.toUpperCase() %></span>
                    </span>
                </div>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/booking" class="btn btn-secondary">
                    ←  Kembali ke Dashboard
                </a>
                
                <button type="button" onclick="showEditForm()" class="btn btn-primary">
                    Edit Profil
                </button>
                
                <button type="button" onclick="showPasswordForm()" class="btn btn-primary">
                    Ganti Password
                </button>
            </div>
            
            <!-- Edit Profile Form (Hidden by Default) -->
            <div id="editForm" style="display: none; margin-top: 40px; padding-top: 30px; border-top: 2px solid #eee;">
                <h3 style="margin-bottom: 20px; color: #333;">Edit Data Profil</h3>
                <form action="${pageContext.request.contextPath}/profile/update" method="POST">
                    <div class="form-group">
                        <label class="form-label">Nama Lengkap</label>
                        <input type="text" name="nama" class="form-input" value="<%= nama %>" 
                               <%= user instanceof Admin ? "readonly" : "" %>>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-input" value="<%= email %>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Nomor Telepon</label>
                        <input type="text" name="phone" class="form-input" value="<%= phone %>">
                    </div>
                    
                    <div style="display: flex; gap: 15px; margin-top: 30px;">
                        <button type="button" onclick="hideEditForm()" class="btn btn-secondary" style="flex: 1;">
                            Batal
                        </button>
                        <button type="submit" class="btn btn-primary" style="flex: 1;">
                            Simpan Perubahan
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Change Password Form (Hidden by Default) -->
            <div id="passwordForm" style="display: none; margin-top: 40px; padding-top: 30px; border-top: 2px solid #eee;">
                <h3 style="margin-bottom: 20px; color: #333;">Ganti Password</h3>
                <form action="${pageContext.request.contextPath}/profile/password" method="POST">
                    <div class="form-group">
                        <label class="form-label">Password Lama</label>
                        <input type="password" name="oldPassword" class="form-input" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Password Baru</label>
                        <input type="password" name="newPassword" class="form-input" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Konfirmasi Password Baru</label>
                        <input type="password" name="confirmPassword" class="form-input" required>
                    </div>
                    
                    <div style="display: flex; gap: 15px; margin-top: 30px;">
                        <button type="button" onclick="hidePasswordForm()" class="btn btn-secondary" style="flex: 1;">
                            Batal
                        </button>
                        <button type="submit" class="btn btn-primary" style="flex: 1;">
                            Ganti Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function showEditForm() {
            document.getElementById('editForm').style.display = 'block';
            document.getElementById('passwordForm').style.display = 'none';
        }
        
        function hideEditForm() {
            document.getElementById('editForm').style.display = 'none';
        }
        
        function showPasswordForm() {
            document.getElementById('passwordForm').style.display = 'block';
            document.getElementById('editForm').style.display = 'none';
        }
        
        function hidePasswordForm() {
            document.getElementById('passwordForm').style.display = 'none';
        }
        
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.style.display = 'none';
                    }, 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>