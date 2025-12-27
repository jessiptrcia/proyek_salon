<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .dashboard-container { padding: 40px; width: 95%; max-width: 1200px; margin: 0 auto; }
        .glass-table-container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid rgba(0,0,0,0.1); color: #000; }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.2); color: #333; }
        .badge-member { background: #d4af37; color: white; padding: 4px 10px; border-radius: 10px; font-size: 0.8rem; }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover;">
    
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700;">Admin Dashboard</h1>
            <a href="${pageContext.request.contextPath}/logout" class="btn-glass" style="width: auto; padding: 10px 25px;">Logout</a>
        </div>

        <div class="glass-table-container">
            <h3>Daftar Pelanggan Terdaftar</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nama</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Poin</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Pelanggan> list = (List<Pelanggan>) request.getAttribute("pelangganList");
                        if (list != null) {
                            for (Pelanggan p : list) { // Menggunakan atribut dari class Pelanggan
                    %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td><strong><%= p.getNama() %></strong></td>
                        <td><%= p.getUsername() %></td>
                        <td><%= p.getEmail() %></td>
                        <td><%= p.getPhone() %></td>
                        <td>
                            <% if(p.isMember()) { %>
                                <span class="badge-member">Member</span>
                            <% } else { %>
                                <span style="color: #777;">Reguler</span>
                            <% } %>
                        </td>
                        <td><%= p.getPoinLoyalty() %> pts</td>
                    </tr>
                    <%      } 
                        } 
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
