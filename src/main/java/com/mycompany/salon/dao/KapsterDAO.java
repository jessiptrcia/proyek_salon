package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.Kapster;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KapsterDAO {

    // 1. CREATE
    public boolean save(Kapster k) {
        String sql = "INSERT INTO kapster (nama, spesialisasi, status, rating, jumlah_ulasan, foto) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, k.getNama());
            pstmt.setString(2, k.getSpesialisasi());
            pstmt.setString(3, k.getStatus());
            pstmt.setDouble(4, k.getRating());
            pstmt.setInt(5, k.getJumlahUlasan()); // Simpan jumlah ulasan (biasanya 0 saat baru)
            pstmt.setString(6, k.getFoto());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. READ ALL
    public List<Kapster> findAll() {
        List<Kapster> list = new ArrayList<>();
        String sql = "SELECT * FROM kapster";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToKapster(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 3. READ BY STATUS
    public List<Kapster> findByStatus(String status) {
        List<Kapster> list = new ArrayList<>();
        String sql = "SELECT * FROM kapster WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToKapster(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. READ ONE
    public Kapster findById(int id) {
        String sql = "SELECT * FROM kapster WHERE id = ?";
        Kapster k = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    k = mapResultSetToKapster(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    // 5. UPDATE (Penting: Update Rating & Jumlah Ulasan)
    public boolean updateInfo(Kapster k) {
        // Kita hapus 'rating' dan 'jumlah_ulasan' dari query ini
        String sql = "UPDATE kapster SET nama=?, spesialisasi=?, status=?, foto=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, k.getNama());
            pstmt.setString(2, k.getSpesialisasi());
            pstmt.setString(3, k.getStatus());
            pstmt.setString(4, k.getFoto());
            pstmt.setInt(5, k.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateRating(Kapster k) {
        String sql = "UPDATE kapster SET rating=?, jumlah_ulasan=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, k.getRating());
            pstmt.setInt(2, k.getJumlahUlasan());
            pstmt.setInt(3, k.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. DELETE
    public boolean delete(int id) {
        String sql = "DELETE FROM kapster WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // HELPER MAPPING
    private Kapster mapResultSetToKapster(ResultSet rs) throws SQLException {
        Kapster k = new Kapster();
        k.setId(rs.getInt("id"));
        k.setNama(rs.getString("nama"));
        k.setSpesialisasi(rs.getString("spesialisasi"));
        k.setStatus(rs.getString("status"));
        k.setRating(rs.getDouble("rating"));
        
        // Ambil data jumlah ulasan dari DB
        k.setJumlahUlasan(rs.getInt("jumlah_ulasan"));
        
        k.setFoto(rs.getString("foto"));
        return k;
    }
}