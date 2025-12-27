<%@page import="com.mycompany.salon.model.entity.Katalog"%>
<%@page import="com.mycompany.salon.model.entity.Kapster"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Pelanggan p = (Pelanggan) session.getAttribute("user");
    List<Katalog> listLayanan = (List<Katalog>) request.getAttribute("listLayanan");
    List<Kapster> listKapster = (List<Kapster>) request.getAttribute("listKapster");
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Booking | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .form-wrapper {
            width: 90%;
            max-width: 1000px;
            margin: 0 auto;
            padding-top: 50px;
            padding-bottom: 80px;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .form-header h1 {
            font-size: 2.5rem;
            font-weight: 600;
            color: #000;
            margin-bottom: 10px;
        }
        
        .form-header p {
            color: #666;
            font-size: 1.1rem;
        }
        
        .booking-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
        }
        
        .form-section {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 25px;
            padding: 35px;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e1b382;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
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
        
        .form-select {
            width: 100%;
            padding: 14px 20px;
            border-radius: 15px;
            border: 2px solid #ddd;
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.8);
            cursor: pointer;
        }
        
        .kapster-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .kapster-card:hover {
            border-color: #e1b382;
            transform: translateY(-2px);
        }
        
        .kapster-card.selected {
            border-color: #e1b382;
            background: rgba(225, 179, 130, 0.1);
        }
        
        .kapster-photo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid #e1b382;
        }
        
        .kapster-photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .kapster-info h4 {
            margin: 0 0 8px 0;
            font-size: 1.2rem;
            color: #1a1a1a;
        }
        
        .kapster-info p {
            margin: 0 0 5px 0;
            color: #666;
            font-size: 0.9rem;
        }
        
        .rating {
            color: #ffc107;
            font-size: 0.9rem;
        }
        
        .layanan-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .layanan-card:hover {
            border-color: #e1b382;
        }
        
        .layanan-card.selected {
            border-color: #e1b382;
            background: rgba(225, 179, 130, 0.1);
        }
        
        .layanan-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .layanan-header h4 {
            margin: 0;
            font-size: 1.2rem;
            color: #1a1a1a;
        }
        
        .layanan-price {
            font-weight: 600;
            color: #e1b382;
            font-size: 1.1rem;
        }
        
        .layanan-desc {
            color: #666;
            margin-bottom: 10px;
            font-size: 0.9rem;
        }
        
        .layanan-duration {
            display: inline-block;
            background: #f0f0f0;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #666;
        }
        
        .total-section {
            grid-column: span 2;
            background: rgba(225, 179, 130, 0.2);
            border: 2px solid #e1b382;
        }
        
        .total-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .total-label {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .total-amount {
            font-size: 2rem;
            font-weight: 700;
            color: #e1b382;
        }
        
        .btn-submit {
            background: #e1b382;
            color: white;
            border: none;
            padding: 16px 40px;
            border-radius: 30px;
            font-family: 'Poppins', sans-serif;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: background 0.3s;
        }
        
        .btn-submit:hover {
            background: #d4a373;
        }
        
        .alert {
            padding: 15px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
        }
        
        .alert-error {
            background: rgba(255, 0, 0, 0.1);
            color: #d8000c;
            border: 2px solid rgba(255, 0, 0, 0.2);
        }
        
        .alert-success {
            background: rgba(0, 255, 0, 0.1);
            color: #28a745;
            border: 2px solid rgba(0, 255, 0, 0.2);
        }
        
        .promo-section {
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }
        
        .promo-input-group {
            display: flex;
            gap: 10px;
        }
        
        .btn-apply {
            background: #8a7f70;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 15px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
            white-space: nowrap;
        }
        
        .btn-apply:hover {
            background: #7a7164;
        }
        
        .promo-applied {
            margin-top: 15px;
            padding: 12px 20px;
            background: rgba(0, 255, 0, 0.1);
            border-radius: 15px;
            color: #28a745;
            font-weight: 500;
            display: none;
        }
    </style>
    <script>
        let selectedLayanan = [];
        let selectedKapsterId = null;
        let totalHarga = 0;
        let diskon = 0;
        
        function toggleLayanan(layananId, harga) {
            const card = document.getElementById('layanan-' + layananId);
            const index = selectedLayanan.indexOf(layananId);
            
            if (index > -1) {
                // Remove
                selectedLayanan.splice(index, 1);
                totalHarga -= harga;
                card.classList.remove('selected');
            } else {
                // Add
                selectedLayanan.push(layananId);
                totalHarga += harga;
                card.classList.add('selected');
            }
            
            updateTotal();
            updateHiddenInputs();
        }
        
        function selectKapster(kapsterId) {
            // Remove selection from all
            document.querySelectorAll('.kapster-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selection to clicked
            const card = document.getElementById('kapster-' + kapsterId);
            card.classList.add('selected');
            selectedKapsterId = kapsterId;
            
            document.getElementById('kapsterId').value = kapsterId;
        }
        
        function updateTotal() {
            let finalTotal = totalHarga;
            if (diskon > 0) {
                finalTotal = totalHarga * (1 - diskon);
            }
            
            document.getElementById('totalAmount').textContent = 
                'Rp ' + finalTotal.toLocaleString('id-ID');
            document.getElementById('totalHargaInput').value = finalTotal;
        }
        
        // Di booking_form.jsp - perbaiki updateHiddenInputs:
        function updateHiddenInputs() {
            const layananInput = document.getElementById('layananIds');
            layananInput.value = selectedLayanan.join(',');
        }
        
        function applyPromo() {
            const kode = document.getElementById('kodePromo').value;
            const promoMsg = document.getElementById('promoMessage');
            
            // Simulasi check promo (di real app akan AJAX call ke server)
            if (kode === 'SALON10') {
                diskon = 0.1; // 10% discount
                promoMsg.textContent = 'Promo 10% berhasil diterapkan!';
                promoMsg.style.display = 'block';
                updateTotal();
            } else if (kode === 'GLAMORA20') {
                diskon = 0.2; // 20% discount
                promoMsg.textContent = 'Promo 20% berhasil diterapkan!';
                promoMsg.style.display = 'block';
                updateTotal();
            } else if (kode === 'MEMBER50') {
                diskon = 0.5; // 50% discount
                promoMsg.textContent = 'Promo 50% berhasil diterapkan!';
                promoMsg.style.display = 'block';
                updateTotal();
            } else if (kode) {
                diskon = 0;
                promoMsg.textContent = 'Kode promo tidak valid';
                promoMsg.style.display = 'block';
                updateTotal();
            }
        }
        
        function validateForm() {
            if (selectedLayanan.length === 0) {
                alert('Pilih minimal satu layanan');
                return false;
            }
            
            if (!selectedKapsterId) {
                alert('Pilih kapster terlebih dahulu');
                return false;
            }
            
            const tanggal = document.getElementById('tanggal').value;
            if (!tanggal) {
                alert('Pilih tanggal dan waktu booking');
                return false;
            }
            
            return true;
        }
        
        // Set default date/time to tomorrow 10:00
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            const tomorrow = new Date(now);
            tomorrow.setDate(tomorrow.getDate() + 1);
            tomorrow.setHours(10, 0, 0, 0);
            
            // Format to YYYY-MM-DDThh:mm
            const year = tomorrow.getFullYear();
            const month = String(tomorrow.getMonth() + 1).padStart(2, '0');
            const day = String(tomorrow.getDate()).padStart(2, '0');
            const hours = String(tomorrow.getHours()).padStart(2, '0');
            const minutes = String(tomorrow.getMinutes()).padStart(2, '0');
            
            document.getElementById('tanggal').value = 
                `${year}-${month}-${day}T${hours}:${minutes}`;
        });
    </script>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <jsp:include page="../components/navbar_pelanggan.jsp" />
    
    <div class="form-wrapper">
        <div class="form-header">
            <h1>📅 Form Booking Layanan</h1>
            <p>Pilih layanan, kapster, dan waktu yang sesuai untuk Anda</p>
        </div>
        
        <% if (error != null) { %>
        <div class="alert alert-error">
            <% if (error.equals("failed")) { %>
                Gagal membuat booking. Silakan coba lagi.
            <% } else if (error.equals("invalid_input")) { %>
                Data tidak valid. Silakan periksa kembali.
            <% } else { %>
                Terjadi kesalahan. Silakan coba lagi.
            <% } %>
        </div>
        <% } %>
        
        <% if (success != null) { %>
        <div class="alert alert-success">
            Booking berhasil dibuat!
        </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/booking/save" method="POST" onsubmit="return validateForm()" class="booking-form">
            <!-- Kolom Kiri: Pilih Layanan -->
            <div class="form-section">
                <h2 class="section-title">1. Pilih Layanan</h2>
                <p style="color: #666; margin-bottom: 25px;">Pilih satu atau lebih layanan yang Anda inginkan</p>
                
                <% if (listLayanan != null && !listLayanan.isEmpty()) { 
                    for (Katalog layanan : listLayanan) { %>
                    <div class="layanan-card" id="layanan-<%= layanan.getId() %>" 
                         onclick="toggleLayanan(<%= layanan.getId() %>, <%= layanan.getHarga() %>)">
                        <div class="layanan-header">
                            <h4><%= layanan.getNamaLayanan() %></h4>
                            <div class="layanan-price">Rp <%= String.format("%,d", layanan.getHarga()) %></div>
                        </div>
                        <p class="layanan-desc"><%= layanan.getDeskripsi() %></p>
                        <span class="layanan-duration">⏱️ <%= layanan.getDurasiMenit() %> menit</span>
                        <div style="margin-top: 10px; font-size: 0.9rem; color: #ffc107;">
                            ★ <%= String.format("%.1f", layanan.getRating()) %> (<%= layanan.getJumlahUlasan() %> ulasan)
                        </div>
                    </div>
                <% } 
                } else { %>
                    <p style="text-align: center; color: #999; padding: 20px;">Tidak ada layanan tersedia saat ini.</p>
                <% } %>
            </div>
            
            <!-- Kolom Kanan: Pilih Kapster & Waktu -->
            <div class="form-section">
                <h2 class="section-title">2. Pilih Kapster</h2>
                <p style="color: #666; margin-bottom: 25px;">Pilih kapster favorit Anda</p>

                <% if (listKapster != null && !listKapster.isEmpty()) { 
                    for (Kapster kapster : listKapster) { %>
                    <div class="kapster-card" id="kapster-<%= kapster.getId() %>" 
                         onclick="<% if ("Open".equals(kapster.getStatus())) { %>selectKapster(<%= kapster.getId() %>)<% } else { %>alert('Kapster sedang sibuk, pilih kapster lain')<% } %>"
                         style="<% if ("Busy".equals(kapster.getStatus())) { %>opacity: 0.7; cursor: not-allowed;<% } %>">
                        <div class="kapster-photo">
                            <!-- PERBAIKAN 1: Gunakan URL langsung atau path yang benar -->
                            <% if (kapster.getFoto().startsWith("http")) { %>
                                <img src="<%= kapster.getFoto() %>" alt="<%= kapster.getNama() %>">
                            <% } else { %>
                                <img src="${pageContext.request.contextPath}/assets/img/kapster/<%= kapster.getFoto() %>" 
                                     alt="<%= kapster.getNama() %>"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/img/profile_placeholder.png'">
                            <% } %>
                        </div>
                        <div class="kapster-info">
                            <h4><%= kapster.getNama() %></h4>
                            <p>💇 <%= kapster.getSpesialisasi() %></p>
                            <div class="rating">
                                ★ <%= String.format("%.1f", kapster.getRating()) %> 
                                (<%= kapster.getJumlahUlasan() %> ulasan)
                            </div>
                            <!-- PERBAIKAN 2: Tampilkan status -->
                            <% if ("Busy".equals(kapster.getStatus())) { %>
                            <span style="color: #ff6b6b; font-size: 0.9rem; font-weight: 600;">
                                ⏳ Sedang sibuk
                            </span>
                            <% } else { %>
                            <span style="color: #28a745; font-size: 0.9rem; font-weight: 600;">
                                ✅ Tersedia
                            </span>
                            <% } %>
                        </div>
                    </div>
                <% } 
                } else { %>
                    <p style="text-align: center; color: #999; padding: 20px;">Tidak ada kapster tersedia saat ini.</p>
                <% } %>
                
                <h2 class="section-title" style="margin-top: 40px;">3. Pilih Waktu</h2>
                <div class="form-group">
                    <label for="tanggal">📅 Tanggal & Waktu Booking</label>
                    <input type="datetime-local" id="tanggal" name="tanggal" class="form-input" required>
                </div>
                
                <div class="promo-section">
                    <h3 class="section-title" style="font-size: 1.3rem;">4. Kode Promo (Opsional)</h3>
                    <div class="promo-input-group">
                        <input type="text" id="kodePromo" name="kodePromo" class="form-input" 
                               placeholder="Masukkan kode promo" style="flex: 1;">
                        <button type="button" class="btn-apply" onclick="applyPromo()">Terapkan</button>
                    </div>
                    <div id="promoMessage" class="promo-applied"></div>
                </div>
            </div>
            
            <!-- Total & Submit -->
            <div class="form-section total-section">
                <div class="total-info">
                    <div class="total-label">Total Pembayaran:</div>
                    <div class="total-amount" id="totalAmount">Rp 0</div>
                </div>
                
                <button type="submit" class="btn-submit">
                    💳 Konfirmasi Booking
                </button>
                
                <!-- Hidden inputs untuk form submission -->
                <input type="hidden" id="kapsterId" name="kapsterId" value="">
                <input type="hidden" id="layananIds" name="layananIds" value="">
                <input type="hidden" id="totalHargaInput" name="totalHarga" value="0">
                <input type="hidden" name="pelangganId" value="<%= p.getId() %>">
            </div>
        </form>
    </div>
</body>
</html>