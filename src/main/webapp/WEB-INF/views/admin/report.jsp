<%@page import="com.mycompany.salon.model.entity.Booking"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Pendapatan | Glamora Salon</title>
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
        .filter-group { display: flex; gap: 15px; margin-bottom: 20px; align-items: flex-end; }
        .input-report { padding: 10px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.5); background: rgba(255,255,255,0.3); outline: none; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid rgba(0,0,0,0.1); color: #000; }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.2); color: #333; }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700;">Report Transaksi</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-glass" style="width: auto; padding: 10px 25px; text-decoration: none; color: #000; background: rgba(255,255,255,0.5); border-radius: 10px;">Kembali</a>
        </div>
        
        <div class="glass-card">
            <h3>Filter Report</h3>
            <form action="report" method="GET" class="filter-group">
                <div>
                    <label>Jenis Filter:</label><br>
                    <select name="type" class="input-report" id="filterType" onchange="updateInputType()">
                        <option value="all">Semua</option>
                        <option value="harian">Harian</option>
                        <option value="bulanan">Bulanan</option>
                        <option value="tahunan">Tahunan</option>
                    </select>
                </div>
                <div>
                    <label>Pilih Waktu:</label><br>
                    <input type="date" name="value" id="filterValue" class="input-report">
                </div>
                <button type="submit" class="btn-glass" style="padding: 10px 20px; cursor: pointer;">Tampilkan</button>
            </form>
        </div>

        <div class="glass-card">
            <table>
                <thead>
                    <tr>
                        <th>Tanggal</th>
                        <th>Pelanggan</th>
                        <th>Kapster</th>
                        <th>Total Harga</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Booking> listReport = (List<Booking>) request.getAttribute("listReport");
                        long totalPendapatan = 0;
                        if (listReport != null && !listReport.isEmpty()) {
                            for (Booking b : listReport) {
                                totalPendapatan += b.getTotalHarga(); 
                    %>
                    <tr>
                        <td><%= b.getTanggal() %></td>
                        <td><%= b.getPelanggan().getNama() %></td>
                        <td><%= b.getKapster().getNama() %></td>
                        <td><strong>Rp <%= String.format("%,d", (long)b.getTotalHarga()) %></strong></td>
                    </tr>
                    <%      } %>
                    <tr style="background: rgba(255,255,255,0.3); font-weight: bold;">
                        <td colspan="3" style="text-align: right; padding: 15px;">TOTAL PENDAPATAN:</td>
                        <td style="padding: 15px;">Rp <%= String.format("%,d", totalPendapatan) %></td>
                    </tr>
                    <% } else { %>
                    <tr><td colspan="4" style="text-align:center; padding: 20px;">Tidak ada data report ditemukan.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function updateInputType() {
            const type = document.getElementById('filterType').value;
            const input = document.getElementById('filterValue');
            if(type === 'harian') input.type = 'date';
            else if(type === 'bulanan') input.type = 'month';
            else if(type === 'tahunan') { input.type = 'number'; input.placeholder = 'YYYY'; }
            else { input.type = 'hidden'; }
        }
    </script>
</body>
</html>