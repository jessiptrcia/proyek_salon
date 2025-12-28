<%@page import="com.mycompany.salon.model.entity.Katalog"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kelola Layanan | Glamora Salon</title>
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
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <div class="dashboard-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1 style="font-size: 2.5rem; font-weight: 700;">Kelola Layanan</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-glass" style="width: auto; padding: 10px 25 path: 25px;">Kembali</a>
        </div>

        <div class="glass-card">
            <h3 id="formTitle">Tambah Layanan Baru</h3>

            <form action="${pageContext.request.contextPath}/admin/katalog" method="POST">

                <input type="hidden" name="id" id="inputId"> 

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <input type="text" name="nama" id="inputNama" class="input-glass-form" placeholder="Nama Layanan (ex: Hair Spa)" required>

                    <input type="number" name="harga" id="inputHarga" class="input-glass-form" placeholder="Harga (ex: 150000)" required>
                </div>

                <textarea name="deskripsi" id="inputDeskripsi" class="input-glass-form" placeholder="Deskripsi Singkat Layanan" rows="2"></textarea>

                <div style="margin-top: 10px;">
                    <button type="submit" class="btn-glass">Simpan Layanan</button>
                    <button type="button" onclick="resetForm()" class="btn-glass" style="background: rgba(255,0,0,0.2); margin-left: 10px;">Batal</button>
                </div>
            </form>
        </div>

        <div class="glass-card">
            <h3>Daftar Layanan Aktif</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Layanan</th>
                        <th>Harga</th>
                        <th>Rating</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Katalog> listKatalog = (List<Katalog>) request.getAttribute("listKatalog");
                        if (listKatalog != null) {
                            for (Katalog k : listKatalog) {
                    %>
                    <tr>
                        <td><%= k.getId() %></td>
                        <td><strong><%= k.getNamaLayanan() %></strong></td>
                        <td>Rp <%= String.format("%,d", k.getHarga()) %></td>
                        <td>⭐ <%= k.getRating() %> (<%= k.getJumlahUlasan() %>)</td>
                        <td>
                            <button type="button" 
                                    onclick="editLayanan('<%= k.getId() %>', '<%= k.getNamaLayanan().replace("'", "\\'") %>', '<%= k.getHarga() %>', '<%= k.getDeskripsi().replace("'", "\\'").replace("\n", " ") %>')"
                                    style="color: #0d6efd; background: none; border: none; font-weight: 600; cursor: pointer; margin-right: 10px;">
                               Edit
                            </button>

                            <form action="${pageContext.request.contextPath}/admin/katalog" method="POST" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= k.getId() %>">
                                <button type="submit" class="btn-delete" onclick="return confirm('Hapus layanan ini?')">Hapus</button>
                            </form>
                        </td>
                    </tr>
                    <%      } 
                        } 
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <script>
        function editLayanan(id, nama, harga, deskripsi) {
            // 1. Ubah Judul Form
            document.getElementById('formTitle').innerText = "Edit Layanan";

            // 2. Isi Input dengan Data dari Tabel
            document.getElementById('inputId').value = id;
            document.getElementById('inputNama').value = nama;
            document.getElementById('inputHarga').value = harga;
            document.getElementById('inputDeskripsi').value = deskripsi;

            // 3. Scroll ke atas agar admin melihat formnya
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function resetForm() {
            // Balikkan ke Mode Tambah Baru
            document.getElementById('formTitle').innerText = "Tambah Layanan Baru";
            document.getElementById('inputId').value = ""; // Kosongkan ID
            document.getElementById('inputNama').value = "";
            document.getElementById('inputHarga').value = "";
            document.getElementById('inputDeskripsi').value = "";
        }
        
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            const status = urlParams.get('status');

            // Skenario Gagal
            if (error === 'cannot_delete') {
                alert("⚠️ TIDAK BISA DIHAPUS!\n\nLayanan ini sudah pernah dipesan oleh pelanggan. Menghapusnya akan merusak data laporan keuangan.\n\nSolusi: Edit namanya atau biarkan saja.");
                // Bersihkan URL
                window.history.replaceState(null, null, window.location.pathname);
            }

            // Skenario Sukses
            if (status === 'deleted') {
                alert("✅ Data berhasil dihapus.");
                window.history.replaceState(null, null, window.location.pathname);
            }
        });
    </script>
</body>
</html>