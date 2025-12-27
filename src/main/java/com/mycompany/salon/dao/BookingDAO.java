package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    // DAO Helper untuk mengambil data relasi saat membaca (Read)
    private KapsterDAO kapsterDAO = new KapsterDAO();
    private PromoDAO promoDAO = new PromoDAO();

    // 1. SAVE (TRANSACTIONAL)
    // Menyimpan Booking Header + Detail Layanan sekaligus
    public boolean save(Booking b) {
        String sqlHeader = "INSERT INTO booking (user_id, kapster_id, promo_id, tanggal_booking, status, total_harga) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO booking_detail (booking_id, katalog_id, harga_snapshot) VALUES (?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmtHeader = null;
        PreparedStatement pstmtDetail = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // --- LANGKAH A: Simpan Header Booking ---
            pstmtHeader = conn.prepareStatement(sqlHeader, Statement.RETURN_GENERATED_KEYS);
            pstmtHeader.setInt(1, b.getPelanggan().getId());
            pstmtHeader.setInt(2, b.getKapster().getId());
            
            if (b.getPromo() != null) {
                pstmtHeader.setInt(3, b.getPromo().getId());
            } else {
                pstmtHeader.setNull(3, Types.INTEGER);
            }
            
            pstmtHeader.setTimestamp(4, Timestamp.valueOf(b.getTanggal()));
            pstmtHeader.setString(5, b.getStatus());
            pstmtHeader.setDouble(6, b.getTotalHarga());
            
            int affectedRows = pstmtHeader.executeUpdate();
            if (affectedRows == 0) throw new SQLException("Gagal menyimpan booking header.");

            // --- LANGKAH B: Ambil ID Booking yang baru saja terbentuk ---
            int bookingId = 0;
            try (ResultSet generatedKeys = pstmtHeader.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    bookingId = generatedKeys.getInt(1);
                    b.setId(bookingId); 
                } else {
                    throw new SQLException("Gagal mengambil ID booking.");
                }
            }

            // --- LANGKAH C: Simpan List Katalog ke Tabel Detail ---
            pstmtDetail = conn.prepareStatement(sqlDetail);
            for (Katalog k : b.getListKatalog()) {
                pstmtDetail.setInt(1, bookingId);
                pstmtDetail.setInt(2, k.getId());
                pstmtDetail.setDouble(3, k.getHarga()); 
                pstmtDetail.addBatch(); 
            }
            
            pstmtDetail.executeBatch(); 

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); 
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (pstmtDetail != null) pstmtDetail.close();
                if (pstmtHeader != null) pstmtHeader.close();
                if (conn != null) {
                    conn.setAutoCommit(true); 
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 2. READ BY PELANGGAN (Untuk History di Dashboard Pelanggan)
    public List<Booking> findByPelangganId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE user_id = ? ORDER BY tanggal_booking DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- TAMBAHAN BARU UNTUK DASHBOARD PELANGGAN ---

    // 2a. FIND NEXT BOOKING (Mengambil jadwal terdekat yang akan datang)
    public Booking findNextBooking(int userId) {
        String sql = "SELECT * FROM booking WHERE user_id = ? AND tanggal_booking >= NOW() " +
                     "AND status NOT IN ('Cancelled', 'Completed') ORDER BY tanggal_booking ASC LIMIT 1";
        Booking b = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    b = mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return b;
    }

    // 2b. FIND LAST BOOKING (Mengambil riwayat pesanan terakhir yang sudah lewat)
    public Booking findLastBooking(int userId) {
        String sql = "SELECT * FROM booking WHERE user_id = ? AND tanggal_booking < NOW() " +
                     "ORDER BY tanggal_booking DESC LIMIT 1";
        Booking b = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    b = mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return b;
    }

    // ------------------------------------------------

    // 3. READ ALL (Untuk Laporan Admin)
    public List<Booking> findAll() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM booking ORDER BY tanggal_booking DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToBooking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. FIND BY ID (Detail Booking)
    public Booking findById(int id) {
        String sql = "SELECT * FROM booking WHERE id = ?";
        Booking b = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    b = mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return b;
    }
    
    // 5. UPDATE STATUS (Admin: Confirm / Cancel / Complete)
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE booking SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- HELPER METHODS ---

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setTanggal(rs.getTimestamp("tanggal_booking").toLocalDateTime());
        b.setStatus(rs.getString("status"));
        b.setTotalHarga(rs.getDouble("total_harga"));

        Pelanggan p = new Pelanggan();
        p.setId(rs.getInt("user_id"));
        b.setPelanggan(p);

        b.setKapster(kapsterDAO.findById(rs.getInt("kapster_id")));
        
        int promoId = rs.getInt("promo_id");
        if (promoId > 0) {
            b.setPromo(promoDAO.findById(promoId));
        }
        
        b.setListKatalog(getLayananByBookingId(b.getId()));
        
        return b;
    }

    private List<Katalog> getLayananByBookingId(int bookingId) {
        List<Katalog> list = new ArrayList<>();
        String sql = "SELECT k.*, bd.harga_snapshot FROM booking_detail bd " +
                     "JOIN katalog k ON bd.katalog_id = k.id " +
                     "WHERE bd.booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Katalog k = new Katalog();
                    k.setId(rs.getInt("id"));
                    k.setNamaLayanan(rs.getString("nama_layanan"));
                    k.setDeskripsi(rs.getString("deskripsi"));
                    k.setDurasiMenit(rs.getInt("durasi_menit"));
                    k.setHarga(rs.getInt("harga_snapshot")); 
                    
                    list.add(k);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}