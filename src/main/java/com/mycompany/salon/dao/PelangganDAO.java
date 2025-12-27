package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.Pelanggan;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

// Menggunakan Inheritance agar bisa menggunakan metode dari PenggunaDAO
public class PelangganDAO extends PenggunaDAO {

    // 1. CREATE / REGISTER
    public boolean save(Pelanggan p) {
        // Query SQL sesuai dengan kolom di tabel pengguna
        String sql = "INSERT INTO pengguna (username, password, email, phone, role, created_at, nama, is_member, poin_loyalty) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, p.getUsername());
            pstmt.setString(2, p.getPassword()); 
            pstmt.setString(3, p.getEmail());
            pstmt.setString(4, p.getPhone());
            pstmt.setString(5, "Pelanggan"); // Role dikunci sebagai Pelanggan
            
            // Pengaturan Timestamp
            if (p.getCreatedAt() != null) {
                pstmt.setTimestamp(6, Timestamp.valueOf(p.getCreatedAt()));
            } else {
                pstmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            }

            // Data spesifik Pelanggan
            pstmt.setString(7, p.getNama());
            pstmt.setBoolean(8, p.isMember());
            pstmt.setInt(9, p.getPoinLoyalty());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. READ ALL (Khusus Pelanggan)
    public List<Pelanggan> findAll() {
        List<Pelanggan> list = new ArrayList<>();
        String sql = "SELECT * FROM pengguna WHERE role = 'Pelanggan' ORDER BY nama ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSetToPelanggan(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. UPDATE MEMBER STATUS
    public boolean updateMemberStatus(int id, boolean isMember) {
        String sql = "UPDATE pengguna SET is_member = ? WHERE id = ? AND role='Pelanggan'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBoolean(1, isMember);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Helper Mapping (Dipindahkan ke sini agar spesifik mengembalikan Pelanggan) ---
    private Pelanggan mapResultSetToPelanggan(ResultSet rs) throws SQLException {
        Pelanggan p = new Pelanggan();
        p.setId(rs.getInt("id"));
        p.setUsername(rs.getString("username"));
        p.setPassword(rs.getString("password"));
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));
        p.setRole(rs.getString("role"));
        p.setNama(rs.getString("nama"));
        p.setMember(rs.getBoolean("is_member"));
        p.setPoinLoyalty(rs.getInt("poin_loyalty"));
        
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            p.setCreatedAt(ts.toLocalDateTime());
        }
        return p;
    }
}