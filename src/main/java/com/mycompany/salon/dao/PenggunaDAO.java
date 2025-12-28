package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.*; 
import java.sql.*;
import java.time.LocalDateTime;

public class PenggunaDAO {
    public boolean save(Pelanggan p) {
        String sql = "INSERT INTO pengguna (username, password, email, phone, role, created_at, nama, is_member, poin_loyalty) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, p.getUsername());
            pstmt.setString(2, p.getPassword());
            pstmt.setString(3, p.getEmail());
            pstmt.setString(4, p.getPhone());
            pstmt.setString(5, "Pelanggan"); 
            
            if (p.getCreatedAt() != null) {
                pstmt.setTimestamp(6, Timestamp.valueOf(p.getCreatedAt()));
            } else {
                pstmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            }

            pstmt.setString(7, p.getNama());
            pstmt.setBoolean(8, p.isMember());
            pstmt.setInt(9, p.getPoinLoyalty());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Pengguna login(String username, String password) {
        String sql = "SELECT * FROM pengguna WHERE username = ? AND password = ?";
        Pengguna pengguna = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    pengguna = mapResultSetToPengguna(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pengguna;
    }

    private Pengguna mapResultSetToPengguna(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        Pengguna p = null;

        if ("Pelanggan".equalsIgnoreCase(role)) {
            Pelanggan plg = new Pelanggan();
            plg.setNama(rs.getString("nama"));
            plg.setMember(rs.getBoolean("is_member"));
            plg.setPoinLoyalty(rs.getInt("poin_loyalty"));
            p = plg;
        } else {
            p = new Admin(); 
        }

        p.setId(rs.getInt("id"));
        p.setUsername(rs.getString("username"));
        p.setPassword(rs.getString("password"));
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));
        p.setRole(role);
        
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            p.setCreatedAt(ts.toLocalDateTime());
        }

        return p;
    }
    
    // 4a. UPDATE PROFILE (Hanya data diri, TANPA Password)
    public boolean updateProfile(Pengguna p) {
        String sql;
        
        // Cek tipe user untuk menentukan query
        if (p instanceof Pelanggan) {
            sql = "UPDATE pengguna SET email = ?, phone = ?, nama = ? WHERE id = ?";
        } else {
            sql = "UPDATE pengguna SET email = ?, phone = ? WHERE id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, p.getEmail());
            pstmt.setString(2, p.getPhone());
            
            if (p instanceof Pelanggan) {
                pstmt.setString(3, ((Pelanggan) p).getNama());
                pstmt.setInt(4, p.getId());
            } else {
                pstmt.setInt(3, p.getId());
            }
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePassword(int userId, String passwordBaru) {
        String sql = "UPDATE pengguna SET password = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, passwordBaru);
            pstmt.setInt(2, userId);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM pengguna WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}