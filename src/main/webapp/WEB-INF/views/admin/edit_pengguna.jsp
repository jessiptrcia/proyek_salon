<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Pelanggan | Glamora Salon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .glass-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            max-width: 500px; margin: 50px auto;
        }
        .input-glass { width: 100%; padding: 12px; margin: 10px 0; border-radius: 10px; border: 1px solid white; background: rgba(255,255,255,0.3); }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover;">
    <div class="glass-card">
        <% 
        Pelanggan p = (Pelanggan) request.getAttribute("pelanggan"); 
        if (p == null) {
            response.sendRedirect("pengguna"); // Jika null, paksa balik ke list
            return;
        }
        %>
        <h2>Edit Data Pelanggan</h2>
        <form action="pengguna" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= p.getId() %>">
            
            <label>Nama Lengkap</label>
            <input type="text" name="nama" class="input-glass" value="<%= p.getNama() %>" required>
            
            <label>Email</label>
            <input type="email" name="email" class="input-glass" value="<%= p.getEmail() %>" required>
            
            <label>No. Telepon</label>
            <input type="text" name="telepon" class="input-glass" value="<%= p.getPhone() %>" required>
            
            <div style="margin-top: 20px;">
                <button type="submit" class="btn-glass" style="background: #28a745; color: white;">Update Data</button>
                <a href="pengguna" class="btn-glass" style="text-decoration: none; color: black; background: #eee;">Batal</a>
            </div>
        </form>
    </div>
</body>
</html>