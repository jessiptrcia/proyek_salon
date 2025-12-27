package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    // Inisialisasi DAO lain karena kita perlu update data mereka
    private BookingDAO bookingDAO = new BookingDAO();
    private KapsterDAO kapsterDAO = new KapsterDAO();
    private KatalogDAO katalogDAO = new KatalogDAO();

    // 1. SAVE (Simpan Feedback + Hitung Rata-rata Kapster & Katalog)
    public boolean save(Feedback fb) {
        String sql = "INSERT INTO feedback (booking_id, komentar, rating, tanggal) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Matikan autocommit untuk Transaksi

            // --- A. Simpan Data Feedback ke Tabel Feedback ---
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, fb.getIdBooking());
            pstmt.setString(2, fb.getKomentar());
            pstmt.setDouble(3, fb.getRating());
            
            // Konversi LocalDateTime ke Timestamp
            if (fb.getTanggal() != null) {
                pstmt.setTimestamp(4, Timestamp.valueOf(fb.getTanggal()));
            } else {
                pstmt.setTimestamp(4, Timestamp.valueOf(java.time.LocalDateTime.now()));
            }
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) throw new SQLException("Gagal menyimpan feedback.");

            // --- B. Logika Update Rating Otomatis ---
            
            // 1. Ambil Data Booking Lengkap (untuk tahu siapa Kapster & Katalog-nya)
            Booking booking = bookingDAO.findById(fb.getIdBooking());
            
            if (booking != null) {
                double ratingBaruDariUser = fb.getRating();

                // === UPDATE RATING KAPSTER ===
                Kapster kapster = booking.getKapster();
                // Pastikan ambil data fresh dari DB agar jumlah ulasan akurat
                kapster = kapsterDAO.findById(kapster.getId()); 
                
                if (kapster != null) {
                    // LOGIKA MATEMATIKA MANUAL (Karena di class Kapster tidak ada method helper)
                    double ratingLama = kapster.getRating();
                    int jumlahLama = kapster.getJumlahUlasan();
                    
                    // Rumus Rata-rata Berjalan
                    double ratingBaruHitungan = ((ratingLama * jumlahLama) + ratingBaruDariUser) / (jumlahLama + 1);
                    
                    // Set nilai baru ke objek
                    kapster.setRating(ratingBaruHitungan);
                    kapster.setJumlahUlasan(jumlahLama + 1);
                    
                    // Simpan ke database
                    kapsterDAO.update(kapster); 
                }

                // === UPDATE RATING KATALOG (LAYANAN) ===
                for (Katalog kSnapshot : booking.getListKatalog()) {
                    // Ambil data live terbaru dari DB (penting!)
                    Katalog liveKatalog = katalogDAO.findById(kSnapshot.getId());
                    
                    if (liveKatalog != null) {
                        // LOGIKA MATEMATIKA (Sama seperti Kapster)
                        double kRatingLama = liveKatalog.getRating();
                        int kJumlahLama = liveKatalog.getJumlahUlasan();
                        
                        double kRatingBaru = ((kRatingLama * kJumlahLama) + ratingBaruDariUser) / (kJumlahLama + 1);
                        
                        liveKatalog.setRating(kRatingBaru);
                        liveKatalog.setJumlahUlasan(kJumlahLama + 1);
                        
                        // Simpan ke database
                        katalogDAO.update(liveKatalog);
                    }
                }
            }

            conn.commit(); // Simpan Permanen (Commit)
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    System.out.println("Terjadi error, rollback transaksi feedback...");
                    conn.rollback(); // Batalkan semua jika error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 2. CEK FEEDBACK BY BOOKING ID (Untuk mencegah user review 2x)
    public Feedback findByBookingId(int bookingId) {
        String sql = "SELECT * FROM feedback WHERE booking_id = ?";
        Feedback fb = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    fb = mapResultSetToFeedback(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fb;
    }

    // 3. READ ALL (Untuk Admin)
    public List<Feedback> findAll() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY tanggal DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Helper Mapping
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setId(rs.getInt("id"));
        fb.setIdBooking(rs.getInt("booking_id"));
        fb.setKomentar(rs.getString("komentar"));
        fb.setRating(rs.getDouble("rating"));
        
        Timestamp ts = rs.getTimestamp("tanggal");
        if (ts != null) {
            fb.setTanggal(ts.toLocalDateTime());
        }
        
        return fb;
    }
}