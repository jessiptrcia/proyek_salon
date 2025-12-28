<%@page import="com.mycompany.salon.model.entity.Kapster"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Kapster | Glamora Salon</title>
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
        .btn-delete { color: #d8000c; text-decoration: none; font-weight: 600; cursor: pointer; background: none; border: none; }
        
        .input-glass-form {
            padding: 12px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.5);
            background: rgba(255,255,255,0.3);
            outline: none;
            width: 100%;
            margin-bottom: 10px;
        }

        .badge-status {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .status-open { background: #d4edda; color: #155724; }
        .status-busy { background: #fff3cd; color: #856404; }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700;">Kelola Kapster</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-glass" style="width: auto; padding: 10px 25px; text-decoration: none; color: #000; background: rgba(255,255,255,0.5); border-radius: 10px;">Kembali</a>
        </div>

        <div class="glass-card">
            <h3>Tambah Kapster Baru</h3>
            <form action="${pageContext.request.contextPath}/admin/kapster" method="POST">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <input type="text" name="nama" class="input-glass-form" placeholder="Nama Lengkap Kapster" required>
                    <input type="text" name="spesialisasi" class="input-glass-form" placeholder="Spesialisasi (ex: Haircut, Styling)" required>
                </div>
                <button type="submit" class="btn-glass" style="margin-top: 10px; padding: 10px 20px; cursor: pointer;">Simpan Kapster</button>
            </form>
        </div>

        <div class="glass-card">
            <h3>Daftar Kapster Aktif</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Foto</th>
                        <th>Nama Kapster</th>
                        <th>Spesialisasi</th>
                        <th>Status</th>
                        <th>Rating</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Kapster> listKapster = (List<Kapster>) request.getAttribute("listKapster");
                        if (listKapster != null && !listKapster.isEmpty()) {
                            for (Kapster k : listKapster) {
                    %>
                    <tr>
                        <td><%= k.getId() %></td>
                        <td>
                            <img src="${pageContext.request.contextPath}/assets/img/<%= k.getFoto() %>" 
                                 style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid white;">
                        </td>
                        <td><strong><%= k.getNama() %></strong></td>
                        <td><%= k.getSpesialisasi() %></td>
                        <td>
                            <span class="badge-status <%= k.getStatus().equalsIgnoreCase("Open") ? "status-open" : "status-busy" %>">
                                <%= k.getStatus() %>
                            </span>
                        </td>
                        <td>⭐ <%= k.getRating() %> (<%= k.getJumlahUlasan() %>)</td>
                        <td>
                             <form action="${pageContext.request.contextPath}/admin/kapster" method="POST" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= k.getId() %>">
                                <button type="submit" class="btn-delete" onclick="return confirm('Hapus kapster ini?')">Hapus</button>
                            </form>
                        </td>
                    </tr>
                    <%      } 
                        } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #666;">Data kapster belum tersedia.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>