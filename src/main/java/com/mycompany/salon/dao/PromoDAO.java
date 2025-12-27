package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.Promo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromoDAO {

    // 1. CREATE (Admin: Tambah Promo Baru)
    public boolean save(Promo p) {
        String sql = "INSERT INTO promo (kode_promo, diskon, deskripsi) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, p.getKodePromo());
            pstmt.setDouble(2, p.getDiskon());
            pstmt.setString(3, p.getDeskripsi());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. READ ALL (Admin: Lihat Daftar Promo)
    public List<Promo> findAll() {
        List<Promo> list = new ArrayList<>();
        String sql = "SELECT * FROM promo";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToPromo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. READ BY KODE (Penting untuk Fitur Booking: Validasi Voucher)
    // Contoh: User input "MERDEKA45", sistem cari apakah ada di DB?
    public Promo findByKode(String kode) {
        String sql = "SELECT * FROM promo WHERE kode_promo = ?";
        Promo p = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, kode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    p = mapResultSetToPromo(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // 4. READ BY ID (Penting untuk BookingDAO: Reconstruct Object)
    public Promo findById(int id) {
        String sql = "SELECT * FROM promo WHERE id = ?";
        Promo p = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    p = mapResultSetToPromo(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // 5. UPDATE (Admin: Edit Promo)
    public boolean update(Promo p) {
        String sql = "UPDATE promo SET kode_promo=?, diskon=?, deskripsi=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, p.getKodePromo());
            pstmt.setDouble(2, p.getDiskon());
            pstmt.setString(3, p.getDeskripsi());
            pstmt.setInt(4, p.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. DELETE (Admin: Hapus Promo)
    public boolean delete(int id) {
        String sql = "DELETE FROM promo WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper: Mapping Database Row ke Java Object
    private Promo mapResultSetToPromo(ResultSet rs) throws SQLException {
        Promo p = new Promo();
        p.setId(rs.getInt("id"));
        p.setKodePromo(rs.getString("kode_promo"));
        p.setDiskon(rs.getDouble("diskon"));
        p.setDeskripsi(rs.getString("deskripsi"));
        return p;
    }
}