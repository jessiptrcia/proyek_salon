<%@page import="com.mycompany.salon.model.entity.Booking"%>
<%@page import="com.mycompany.salon.model.entity.Katalog"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.salon.model.entity.Pelanggan"%>
<%@page import="com.mycompany.salon.model.entity.Feedback"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Pelanggan p = (Pelanggan) session.getAttribute("user");
    List<Booking> riwayat = (List<Booking>) request.getAttribute("riwayat");
    Map<Integer, Feedback> feedbackMap = (Map<Integer, Feedback>) request.getAttribute("feedbackMap");
    String status = request.getParameter("status");
    
    if (feedbackMap == null) {
        feedbackMap = new HashMap<>();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Booking | Glamora Salon</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* ====== STYLE DARI booking_form.jsp (YANG SUDAH BAGUS) ====== */
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
        
        /* ====== STYLE KHUSUS UNTUK HISTORY ====== */
        .history-wrapper {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding-top: 50px;
            padding-bottom: 80px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 600;
            color: #000;
            margin-bottom: 15px;
        }
        
        .page-header p {
            color: #666;
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* Filter Section */
        .filter-section {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .filter-group {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .filter-label {
            font-weight: 600;
            color: #333;
            white-space: nowrap;
        }
        
        .filter-select {
            padding: 12px 20px;
            border-radius: 15px;
            border: 2px solid #ddd;
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.8);
            cursor: pointer;
            min-width: 180px;
            transition: all 0.3s;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #e1b382;
            box-shadow: 0 0 0 3px rgba(225, 179, 130, 0.2);
        }
        
        /* Booking Card */
        .booking-card {
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }
        
        .booking-card:hover {
            transform: translateY(-5px);
            border-color: rgba(225, 179, 130, 0.5);
        }
        
        /* Booking Header */
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(221, 221, 221, 0.5);
        }
        
        .booking-id {
            font-size: 1.6rem;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .booking-date {
            color: #666;
            font-size: 1.1rem;
            margin-top: 8px;
        }
        
        /* Status Badges */
        .status-badge {
            padding: 10px 25px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1rem;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-pending { 
            background: #fff3cd; 
            color: #856404; 
            border: 2px solid #ffeaa7;
        }
        
        .status-confirmed { 
            background: #d1ecf1; 
            color: #0c5460; 
            border: 2px solid #bee5eb;
        }
        
        .status-completed { 
            background: #d4edda; 
            color: #155724; 
            border: 2px solid #c3e6cb;
        }
        
        .status-cancelled { 
            background: #f8d7da; 
            color: #721c24; 
            border: 2px solid #f5c6cb;
        }
        
        /* Details Grid */
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .detail-item {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.8);
        }
        
        .detail-title {
            font-size: 0.9rem;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
            font-weight: 600;
        }
        
        .detail-content {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        /* Kapster Info */
        .kapster-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .kapster-photo-small {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            overflow: hidden;
            border: 3px solid #e1b382;
            flex-shrink: 0;
        }
        
        .kapster-photo-small img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .kapster-info-text h4 {
            font-size: 1.3rem;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .kapster-info-text p {
            color: #666;
            font-size: 0.95rem;
        }
        
        /* Layanan Section */
        .layanan-section {
            margin-top: 30px;
        }
        
        .layanan-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .layanan-item {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            padding: 20px;
            border-left: 5px solid #e1b382;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }
        
        .layanan-item:hover {
            transform: translateY(-3px);
        }
        
        .layanan-name {
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
            font-size: 1.1rem;
        }
        
        .layanan-price {
            color: #e1b382;
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 5px;
        }
        
        .layanan-duration {
            display: inline-block;
            background: #f0f0f0;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #666;
        }
        
        /* Footer */
        .booking-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 35px;
            padding-top: 25px;
            border-top: 2px solid rgba(221, 221, 221, 0.5);
        }
        
        .total-section {
            text-align: right;
        }
        
        .total-label {
            font-size: 1rem;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .total-amount {
            font-size: 2.2rem;
            font-weight: 800;
            color: #666;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
        }
        
        .btn-action {
            padding: 14px 32px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-cancel {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f8d7da;
        }
        
        .btn-cancel:hover {
            background: #f5c6cb;
            border-color: #f5c6cb;
        }
        
        .btn-feedback {
            background: #e1b382;
            color: white;
            border: 2px solid #e1b382;
        }
        
        .btn-feedback:hover {
            background: #d4a373;
            border-color: #d4a373;
        }
        
        .btn-detail {
            background: white;
            color: #e1b382;
            border: 2px solid #e1b382;
        }
        
        .btn-detail:hover {
            background: #e1b382;
            color: white;
        }
        
        /* No History */
        .no-history {
            text-align: center;
            padding: 80px 40px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(15px);
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.5);
            margin-top: 40px;
        }
        
        .no-history-icon {
            font-size: 5rem;
            margin-bottom: 25px;
            color: #ddd;
            opacity: 0.7;
        }
        
        .no-history h3 {
            font-size: 2rem;
            color: #666;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .no-history p {
            color: #888;
            margin-bottom: 40px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        
        .btn-book-now {
            display: inline-block;
            background: #e1b382;
            color: white;
            padding: 18px 50px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.2rem;
            transition: background 0.3s;
            border: none;
            cursor: pointer;
        }
        
        .btn-book-now:hover {
            background: #d4a373;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(225, 179, 130, 0.3);
        }
        
        /* Alert */
        .alert {
            padding: 20px 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 500;
            font-size: 1.1rem;
            backdrop-filter: blur(15px);
        }
        
        .alert-success {
            background: rgba(40, 167, 69, 0.15);
            color: #155724;
            border: 2px solid rgba(40, 167, 69, 0.3);
        }
        
        /* Promo Badge */
        .promo-badge {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 12px;
            vertical-align: middle;
        }
        
        /* ====== STYLE UNTUK FORM FEEDBACK ====== */
        .feedback-form-container {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 25px;
            margin-top: 15px;
            border: 2px solid rgba(225, 179, 130, 0.3);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            animation: slideDown 0.3s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Star Rating */
        .star-rating {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .star-rating input[type="radio"] {
            display: none;
        }
        
        .star-label {
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            border: 2px solid #ddd;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1.4rem;
            text-align: center;
            color: #ffc107;
            flex: 1;
            min-width: 80px;
        }
        
        .star-label:hover {
            background: rgba(225, 179, 130, 0.1);
            border-color: #e1b382;
            transform: translateY(-2px);
        }
        
        .star-rating input[type="radio"]:checked + .star-label {
            background: rgba(225, 179, 130, 0.2);
            border-color: #e1b382;
            color: #e1b382;
            box-shadow: 0 4px 15px rgba(225, 179, 130, 0.2);
        }
        
        .star-number {
            display: block;
            font-size: 0.9rem;
            color: #666;
            margin-top: 5px;
        }
        
        /* Comment Section */
        .comment-section textarea {
            width: 100%;
            padding: 15px;
            border-radius: 15px;
            border: 2px solid #ddd;
            font-family: 'Poppins', sans-serif;
            resize: vertical;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .comment-section textarea:focus {
            outline: none;
            border-color: #e1b382;
            box-shadow: 0 0 0 3px rgba(225, 179, 130, 0.2);
        }
        
        /* Action Buttons */
        .feedback-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        
        .btn-submit {
            padding: 14px 32px;
            background: #e1b382;
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1rem;
            flex: 1;
        }
        
        .btn-submit:hover {
            background: #d4a373;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(225, 179, 130, 0.3);
        }
        
        .btn-cancel-form {
            padding: 14px 32px;
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f8d7da;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1rem;
            flex: 1;
        }
        
        .btn-cancel-form:hover {
            background: #f5c6cb;
            border-color: #f5c6cb;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .history-wrapper {
                width: 95%;
                padding-top: 30px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .filter-section {
                flex-direction: column;
                align-items: flex-start;
                padding: 25px;
            }
            
            .filter-group {
                width: 100%;
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .filter-select {
                width: 100%;
                min-width: unset;
            }
            
            .booking-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
            }
            
            .booking-footer {
                flex-direction: column;
                align-items: stretch;
                gap: 25px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-action {
                width: 100%;
                justify-content: center;
            }
            
            .total-section {
                text-align: center;
            }
            
            .layanan-list {
                grid-template-columns: 1fr;
            }
            
            .star-rating {
                flex-direction: column;
            }
            
            .star-label {
                width: 100%;
            }
            
            .feedback-actions {
                flex-direction: column;
            }
            
            .btn-submit, .btn-cancel-form {
                width: 100%;
            }
        }
        
        /* Utilities */
        .text-center { text-align: center; }
        .mt-20 { margin-top: 20px; }
        .mb-20 { margin-bottom: 20px; }
        
        /* Debug Panel (bisa di-hide) */
        .debug-panel {
            background: rgba(255, 243, 205, 0.9);
            border: 2px solid #ffc107;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            line-height: 1.6;
            backdrop-filter: blur(10px);
            display: none; /* Sembunyikan saat production */
        }
        
        .debug-panel h4 {
            margin-top: 0;
            color: #856404;
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .debug-toggle {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #e1b382;
            color: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 20px;
            cursor: pointer;
            z-index: 1000;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body style="background-image: url('${pageContext.request.contextPath}/assets/img/bg.jpg'); background-size: cover; background-attachment: fixed;">
    
    <jsp:include page="../components/navbar_pelanggan.jsp" />

    <div class="history-wrapper">
        <div class="page-header">
            <h1>📋 Riwayat Booking</h1>
            <p>Lihat dan kelola semua pemesanan layanan Anda di Glamora Salon</p>
        </div>
        
        <!-- DEBUG TOGGLE BUTTON -->
        <button class="debug-toggle" onclick="toggleDebug()">🔧</button>
        
        <!-- DEBUG PANEL -->
        <div class="debug-panel" id="debugPanel">
            <h4>🔧 Debug Info:</h4>
            <strong>User:</strong> <%= p != null ? p.getNama() : "NULL" %><br>
            <strong>User ID:</strong> <%= p != null ? p.getId() : "NULL" %><br>
            <strong>Riwayat List:</strong> <%= riwayat != null ? "NOT NULL" : "NULL" %><br>
            <strong>Jumlah Booking:</strong> <%= riwayat != null ? riwayat.size() : 0 %><br>
            <strong>Status Parameter:</strong> <%= status != null ? status : "NULL" %><br>
            <hr>
            <small>Data akan tampil rapi dengan styling yang sama seperti booking_form</small>
        </div>
        
        <% if (status != null && status.equals("success")) { %>
        <div class="alert alert-success">
            ✅ Booking berhasil dibuat! Detail booking telah ditambahkan ke riwayat.
        </div>
        <% } else if (status != null && status.equals("feedback_saved")) { %>
        <div class="alert alert-success">
            ✅ Terima kasih atas feedback Anda! Rating telah disimpan.
        </div>
        <% } %>
        
        <% if (riwayat != null && !riwayat.isEmpty()) { %>
            <!-- FILTER SECTION -->
            <div class="filter-section">                
                <div class="filter-group">
                    <span class="filter-label">Filter Waktu:</span>
                    <select id="dateFilter" class="filter-select" onchange="filterHistory()">
                        <option value="all">Semua Waktu</option>
                        <option value="thisMonth">Bulan Ini</option>
                        <option value="lastMonth">Bulan Lalu</option>
                    </select>
                </div>
                
                <div style="font-weight: 600; color: #333; font-size: 1.1rem;">
                    📊 Total: <span id="totalCount"><%= riwayat.size() %></span> Booking
                </div>
            </div>
            
            <!-- BOOKING LIST -->
            <% for (Booking booking : riwayat) { 
                String statusClass = "status-pending";
                String statusText = "Pending";
                
                if (booking.getStatus() != null && !booking.getStatus().isEmpty()) {
                    statusText = booking.getStatus();
                    
                    switch(booking.getStatus().toLowerCase()) {
                        case "pending": statusClass = "status-pending"; break;
                        case "confirmed": statusClass = "status-confirmed"; break;
                        case "completed": statusClass = "status-completed"; break;
                        case "cancelled": statusClass = "status-cancelled"; break;
                        default: statusClass = "status-pending";
                    }
                }
                
                // Ambil feedback untuk booking ini dari map
                Feedback existingFeedback = feedbackMap.get(booking.getId());
                boolean sudahKasihFeedback = (existingFeedback != null);
            %>
            <div class="booking-card" data-status="<%= statusText %>" 
                 data-date="<%= booking.getTanggal().toString() %>">
                
                <div class="booking-header">
                    <div>
                        <div class="booking-id">Booking #<%= String.format("%04d", booking.getId()) %></div>
                        <div class="booking-date">
                            📅 <%= booking.getTanggal().toString().replace("T", " ") %>
                        </div>
                    </div>
                    <div class="status-badge <%= statusClass %>">
                        <%= statusText %>
                    </div>
                </div>
                
                <div class="booking-details">
                    <div class="detail-item">
                        <div class="detail-title">Kapster</div>
                        <div class="detail-content">
                            <div class="kapster-info">
                                <% if (booking.getKapster() != null) { 
                                    String kapsterNama = booking.getKapster().getNama() != null ? 
                                        booking.getKapster().getNama() : "Tidak diketahui";
                                    String spesialisasi = booking.getKapster().getSpesialisasi() != null ? 
                                        booking.getKapster().getSpesialisasi() : "-";
                                    String foto = booking.getKapster().getFoto() != null ? 
                                        booking.getKapster().getFoto() : "default_kapster.jpg";
                                %>
                                <div class="kapster-photo-small">
                                    <img src="${pageContext.request.contextPath}/assets/img/kapster/<%= foto %>" 
                                         alt="<%= kapsterNama %>"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/img/profile_placeholder.png'">
                                </div>
                                <div class="kapster-info-text">
                                    <h4><%= kapsterNama %></h4>
                                    <p><%= spesialisasi %></p>
                                </div>
                                <% } else { %>
                                    <div style="color: #999; padding: 10px;">
                                        <i>Kapster tidak tersedia</i>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-title">Layanan Dipesan</div>
                        <div class="detail-content">
                            <span style="font-size: 1.8rem; color: #e1b382;">
                                <%= booking.getListKatalog() != null ? booking.getListKatalog().size() : 0 %>
                            </span> Item
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-title">Total Harga</div>
                        <div class="detail-content" style="color: #e1b382; font-size: 1.6rem;">
                            Rp <%= String.format("%,.0f", booking.getTotalHarga()) %>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-title">Promo</div>
                        <div class="detail-content">
                            <% if (booking.getPromo() != null) { %>
                                <span style="color: #28a745; font-weight: 600;">✓ Terpasang</span>
                                <span class="promo-badge"><%= booking.getPromo().getKodePromo() %></span>
                            <% } else { %>
                                <span style="color: #888;">Tidak ada</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <% if (booking.getListKatalog() != null && !booking.getListKatalog().isEmpty()) { %>
                <div class="layanan-section">
                    <div class="detail-title" style="margin-bottom: 20px; font-size: 1.1rem;">📋 Detail Layanan</div>
                    <div class="layanan-list">
                        <% for (Katalog layanan : booking.getListKatalog()) { %>
                        <div class="layanan-item">
                            <div class="layanan-name"><%= layanan.getNamaLayanan() %></div>
                            <div class="layanan-price">Rp <%= String.format("%,d", layanan.getHarga()) %></div>
                            <div class="layanan-duration">⏱️ <%= layanan.getDurasiMenit() %> menit</div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <% if (statusText.equalsIgnoreCase("completed")) { %>
                <div style="margin-top: 25px; padding: 15px 0; border-top: 1px dashed rgba(221, 221, 221, 0.8);">
                    <% if (sudahKasihFeedback) { %>
                        <!-- TAMPILAN JIKA SUDAH KASIH FEEDBACK -->
                        <div style="background: rgba(212, 237, 218, 0.3); padding: 20px; border-radius: 15px; border: 1px solid #c3e6cb;">
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                                <span style="font-size: 1.5rem; color: #ffc107;">
                                    <% 
                                        int rating = (int) existingFeedback.getRating();
                                        for (int i = 1; i <= 5; i++) {
                                            if (i <= rating) {
                                    %>
                                        ★
                                    <% } else { %>
                                        ☆
                                    <% }} %>
                                </span>
                                <span style="font-weight: 600; color: #155724;">Anda sudah memberikan rating</span>
                            </div>
                            <% if (existingFeedback.getKomentar() != null && !existingFeedback.getKomentar().isEmpty()) { %>
                                <p style="color: #666; font-style: italic; margin: 10px 0 0 0; padding-left: 25px;">
                                    "<%= existingFeedback.getKomentar() %>"
                                </p>
                            <% } %>
                            <small style="display: block; margin-top: 10px; color: #888;">
                                Dikirim pada: <%= existingFeedback.getTanggal() != null ? 
                                    existingFeedback.getTanggal().toString().replace("T", " ") : "-" %>
                            </small>
                        </div>
                    <% } else { %>
                        
                        <!-- FORM FEEDBACK (Tersembunyi Awalnya) -->
                        <div id="feedbackForm-<%= booking.getId() %>" 
                             class="feedback-form-container"
                             style="display: none;">
                            
                            <h4 style="margin-bottom: 20px; color: #333; font-size: 1.1rem;">
                                ⭐ Berikan Penilaian untuk Layanan Ini
                            </h4>
                            
                            <form action="${pageContext.request.contextPath}/booking/feedback" method="POST" 
                                  class="feedback-form">
                                
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                
                                <!-- Rating dengan bintang -->
                                <div class="rating-section">
                                    <label style="font-weight: 600; display: block; margin-bottom: 15px; color: #333;">
                                        Rating (1-5):
                                    </label>
                                    <div class="star-rating">
                                        <% for (int i = 5; i >= 1; i--) { %>
                                            <input type="radio" id="star<%= booking.getId() %>-<%= i %>" 
                                                   name="rating" value="<%= i %>" required 
                                                   onclick="updateStarDisplay(<%= booking.getId() %>, <%= i %>)">
                                            <label for="star<%= booking.getId() %>-<%= i %>" 
                                                   class="star-label">
                                                <%= "★".repeat(i) %><%= "☆".repeat(5-i) %>
                                                <span class="star-number">(<%= i %>)</span>
                                            </label>
                                        <% } %>
                                    </div>
                                    <div id="selectedRating-<%= booking.getId() %>" 
                                         style="margin-top: 10px; font-size: 1.1rem; color: #e1b382; font-weight: 600;">
                                        Pilih rating di atas
                                    </div>
                                </div>
                                
                                <!-- Komentar -->
                                <div class="comment-section">
                                    <label style="font-weight: 600; display: block; margin-bottom: 10px; color: #333;">
                                        Komentar (opsional):
                                    </label>
                                    <textarea name="komentar" rows="3" 
                                              placeholder="Bagaimana pengalaman Anda dengan layanan ini?"></textarea>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="feedback-actions">
                                    <button type="submit" class="btn-submit">
                                        📤 Kirim Feedback
                                    </button>
                                    <button type="button" 
                                            onclick="hideFeedbackForm(<%= booking.getId() %>)"
                                            class="btn-cancel-form">
                                        ✖ Batal
                                    </button>
                                </div>
                            </form>
                        </div>
                    <% } %>
                </div>
                <% } %>
                
                <div class="booking-footer">
                    <div class="action-buttons">
                        <% if (statusText.equalsIgnoreCase("completed")) { 
                            Feedback fb = feedbackMap.get(booking.getId());
                            if (fb == null) { %>
                            <button class="btn-action btn-feedback" 
                                    onclick="showFeedbackForm(<%= booking.getId() %>)">
                                ⭐ Beri Feedback
                            </button>
                        <% }} %>
                    </div>
                    
                    <div class="total-section">
                        <div class="total-label">Total Pembayaran</div>
                        <div class="total-amount">Rp <%= String.format("%,.0f", booking.getTotalHarga()) %></div>
                    </div>
                </div>
            </div>
            <% } %>
            
        <% } else { %>
        <!-- NO HISTORY SECTION -->
        <div class="no-history">
            <div class="no-history-icon">📭</div>
            <h3>Belum Ada Riwayat Booking</h3>
            <p>Anda belum pernah melakukan pemesanan di Glamora Salon. Mulai booking pertama Anda sekarang!</p>
            <a href="${pageContext.request.contextPath}/booking/form" class="btn-book-now">
                🎯 Booking Sekarang
            </a>
        </div>
        <% } %>
    </div>
    
    <script>
        // ====== FUNGSI UTAMA ======
        
        // Debug panel toggle
        function toggleDebug() {
            const panel = document.getElementById('debugPanel');
            panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
        }
        
        // Filter function
        function filterHistory() {
            const dateFilter = document.getElementById('dateFilter').value;
            const bookingCards = document.querySelectorAll('.booking-card');
            let visibleCount = 0;
            
            bookingCards.forEach(card => {
                const cardStatus = card.dataset.status;
                const cardDate = card.dataset.date;
                let showCard = true;
                
                // Filter by date
                if (showCard && dateFilter !== 'all') {
                    const cardDateObj = new Date(cardDate);
                    const now = new Date();
                    
                    if (dateFilter === 'thisMonth') {
                        if (cardDateObj.getMonth() !== now.getMonth() || 
                            cardDateObj.getFullYear() !== now.getFullYear()) {
                            showCard = false;
                        }
                    } else if (dateFilter === 'lastMonth') {
                        const lastMonth = new Date(now);
                        lastMonth.setMonth(lastMonth.getMonth() - 1);
                        
                        if (cardDateObj.getMonth() !== lastMonth.getMonth() || 
                            cardDateObj.getFullYear() !== lastMonth.getFullYear()) {
                            showCard = false;
                        }
                    }
                }
                
                card.style.display = showCard ? 'block' : 'none';
                if (showCard) visibleCount++;
            });
            
            // Update counter
            document.getElementById('totalCount').textContent = visibleCount;
        }
        
        // ====== FUNGSI UNTUK FEEDBACK FORM ======
        
        // Tampilkan form feedback untuk booking tertentu
        function showFeedbackForm(bookingId) {
            // Sembunyikan semua form feedback lainnya
            document.querySelectorAll('[id^="feedbackForm-"]').forEach(form => {
                form.style.display = 'none';
            });
            
            // Tampilkan form yang dipilih
            const formElement = document.getElementById('feedbackForm-' + bookingId);
            if (formElement) {
                formElement.style.display = 'block';
                
                // Scroll ke form dengan animasi
                formElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
        
        // Sembunyikan form feedback
        function hideFeedbackForm(bookingId) {
            const formElement = document.getElementById('feedbackForm-' + bookingId);
            if (formElement) {
                formElement.style.display = 'none';
            }
        }
        
        
        // Fungsi untuk submit form (validasi sederhana)
        function validateFeedbackForm(formElement) {
            const rating = formElement.querySelector('input[name="rating"]:checked');
            if (!rating) {
                alert('Harap pilih rating terlebih dahulu!');
                return false;
            }
            return true;
        }
        
        // ====== INITIALIZATION ======
        document.addEventListener('DOMContentLoaded', function() {
            // Tambahkan event listener untuk semua form feedback
            document.querySelectorAll('.feedback-form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    if (!validateFeedbackForm(this)) {
                        e.preventDefault();
                    }
                });
            });
            
            // Auto-hide success message
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(() => {
                    successAlert.style.opacity = '0';
                    setTimeout(() => {
                        successAlert.style.display = 'none';
                    }, 300);
                }, 5000);
            }
            
            // Hide debug panel by default
            document.getElementById('debugPanel').style.display = 'none';
        });
        
        // Placeholder functions
        function cancelBooking(bookingId) {
            alert('Fitur pembatalan akan diimplementasikan');
            // window.location = '?cancel=' + bookingId;
        }
    </script>
</body>
</html>