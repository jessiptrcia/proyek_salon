<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Pengguna | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .dashboard-container { padding: 40px; width: 95%; max-width: 1200px; margin: 0 auto; }
        .glass-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            margin-bottom: 30px;
        }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid rgba(0,0,0,0.1); color: #000; }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.2); color: #333; }
        
        /* Style Tambahan untuk Button */
        .btn-edit {
            color: #0d6efd;
            text-decoration: none;
            font-weight: 600;
            margin-right: 15px;
        }
        .btn-edit:hover { text-decoration: underline; }
        
        .btn-delete {
            color: #dc3545;
            background: none;
            border: none;
            font-weight: 600;
            cursor: pointer;
            padding: 0;
            font-family: 'Poppins', sans-serif;
        }
        .btn-delete:hover { text-decoration: underline; }

        .badge-member {
            background: #cfe2ff;
            color: #084298;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
        .badge-reguler {
            background: #e2e3e5;
            color: #41464b;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700;">Daftar Pelanggan</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-glass" style="width: auto; padding: 10px 25px; text-decoration: none; color: #000; background: rgba(255,255,255,0.5); border-radius: 10px;">Kembali</a>
        </div>

        <div class="glass-card">
            <h3>Data Pelanggan Terdaftar</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nama Pelanggan</th>
                        <th>Email</th>
                        <th>No. Telepon</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Pelanggan> listPengguna = (List<Pelanggan>) request.getAttribute("listPengguna");
                        if (listPengguna != null && !listPengguna.isEmpty()) {
                            for (Pelanggan p : listPengguna) {
                    %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td><strong><%= p.getNama() %></strong></td>
                        <td><%= p.getEmail() %></td>
                        <td><%= p.getPhone() %></td> 
                        <td>
                            <% if(p.isMember()) { %>
                                <span class="badge-member">Member</span>
                            <% } else { %>
                                <span class="badge-reguler">Reguler</span>
                            <% } %>
                        </td>
                        <td>
                            <div style="display: flex; align-items: center;">
                                <a href="${pageContext.request.contextPath}/admin/pengguna?action=edit&id=<%= p.getId() %>" class="btn-edit">Edit</a>
                                
                                <form action="${pageContext.request.contextPath}/admin/pengguna" method="POST" style="margin: 0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                    <button type="submit" class="btn-delete" onclick="return confirm('Apakah Anda yakin ingin menghapus pelanggan ini?')">
                                        Hapus
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%      } 
                        } else {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center; color: #666; padding: 30px;">Belum ada pelanggan yang terdaftar.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>