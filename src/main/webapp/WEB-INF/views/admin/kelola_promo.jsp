<%@page import="com.mycompany.salon.model.entity.Promo"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Promo | Glamora Salon</title>
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
        .btn-delete { color: #d8000c; text-decoration: none; font-weight: 600; margin-left: 10px; }
        
        /* Form Style */
        .form-group { margin-bottom: 15px; display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 5px; font-weight: 600; }
        .input-promo {
            padding: 10px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.5);
            background: rgba(255,255,255,0.3);
            outline: none;
        }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700;">Kelola Promo</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-glass" style="width: auto; padding: 10px 25px; margin-right: 10px;">Kembali</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-glass" style="width: auto; padding: 10px 25px;">Logout</a>
            </div>
        </div>

        <div class="glass-card">
            <h3>Tambah Promo Baru</h3>
            <form action="${pageContext.request.contextPath}/admin/promo" method="POST" style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 20px; align-items: end;">
                <div class="form-group">
                    <label>Kode Promo</label>
                    <input type="text" name="kode_promo" class="input-promo" placeholder="Contoh: GLAM20" required>
                </div>
                <div class="form-group">
                    <label>Diskon (0.0 - 1.0)</label>
                    <input type="number" step="0.01" name="diskon" class="input-promo" placeholder="Contoh: 0.2 untuk 20%" required>
                </div>
                <div class="form-group">
                    <label>Deskripsi</label>
                    <input type="text" name="deskripsi" class="input-promo" placeholder="Keterangan promo">
                </div>
                <button type="submit" class="btn-glass" style="padding: 11px 30px; height: fit-content;">Simpan</button>
            </form>
        </div>

        <div class="glass-card">
            <h3>Daftar Promo Aktif</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Kode Promo</th>
                        <th>Diskon (%)</th>
                        <th>Deskripsi</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Promo> promoList = (List<Promo>) request.getAttribute("promoList");
                        if (promoList != null && !promoList.isEmpty()) {
                            for (Promo pr : promoList) {
                    %>
                    <tr>
                        <td><%= pr.getId() %></td>
                        <td><strong><%= pr.getKodePromo() %></strong></td>
                        <td><%= (int)(pr.getDiskon() * 100) %>%</td>
                        <td><%= pr.getDeskripsi() %></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/promo" method="POST" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= pr.getId() %>">
                                <button type="submit" class="btn-delete" style="background:none; border:none; cursor:pointer;" onclick="return confirm('Hapus promo ini?')">Hapus</button>
                            </form>
                        </td>
                    </tr>
                    <%      } 
                        } else {
                    %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Belum ada data promo.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>