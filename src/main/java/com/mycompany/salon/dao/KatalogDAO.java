package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.Katalog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KatalogDAO {

    // 1. CREATE (Tambah Layanan Baru)
    public boolean save(Katalog k) {
        String sql = "INSERT INTO katalog (nama_layanan, harga, deskripsi, durasi_menit, rating, jumlah_ulasan) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, k.getNamaLayanan());
            pstmt.setInt(2, k.getHarga()); // Sesuai tipe data int
            pstmt.setString(3, k.getDeskripsi());
            pstmt.setInt(4, k.getDurasiMenit());
            
            // Default biasanya 0.0 dan 0 saat baru dibuat
            pstmt.setDouble(5, k.getRating());
            pstmt.setInt(6, k.getJumlahUlasan());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. READ ALL (Lihat Daftar Layanan)
    public List<Katalog> findAll() {
        List<Katalog> list = new ArrayList<>();
        String sql = "SELECT * FROM katalog";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToKatalog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. READ ONE (Penting untuk FeedbackDAO & BookingDAO)
    public Katalog findById(int id) {
        String sql = "SELECT * FROM katalog WHERE id = ?";
        Katalog k = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    k = mapResultSetToKatalog(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    // 4. UPDATE (Penting: Update Data Layanan & Update Rating)
    public boolean update(Katalog k) {
        // Query ini mengupdate semua field, termasuk rating dan jumlah_ulasan yang baru dihitung
        String sql = "UPDATE katalog SET nama_layanan=?, harga=?, deskripsi=?, durasi_menit=?, rating=?, jumlah_ulasan=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, k.getNamaLayanan());
            pstmt.setInt(2, k.getHarga());
            pstmt.setString(3, k.getDeskripsi());
            pstmt.setInt(4, k.getDurasiMenit());
            pstmt.setDouble(5, k.getRating());       // Menyimpan rating terbaru
            pstmt.setInt(6, k.getJumlahUlasan());    // Menyimpan jumlah ulasan terbaru
            pstmt.setInt(7, k.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. DELETE (Hapus Layanan)
    public boolean delete(int id) {
        String sql = "DELETE FROM katalog WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper: Mapping baris database ke Object Java
    private Katalog mapResultSetToKatalog(ResultSet rs) throws SQLException {
        Katalog k = new Katalog();
        k.setId(rs.getInt("id"));
        k.setNamaLayanan(rs.getString("nama_layanan")); // Sesuaikan nama kolom DB (misal: nama_layanan)
        k.setHarga(rs.getInt("harga"));
        k.setDeskripsi(rs.getString("deskripsi"));
        k.setDurasiMenit(rs.getInt("durasi_menit"));
        k.setRating(rs.getDouble("rating"));
        k.setJumlahUlasan(rs.getInt("jumlah_ulasan"));
        return k;
    }
}