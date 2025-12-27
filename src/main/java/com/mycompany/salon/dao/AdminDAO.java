package com.mycompany.salon.dao;

import com.mycompany.salon.db.DBConnection;
import com.mycompany.salon.model.entity.Admin;
import java.sql.*;

public class AdminDAO {
    public Admin findById(int id) {
        String sql = "SELECT * FROM pengguna WHERE id = ? AND role = 'Admin'";
        Admin a = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    a = new Admin();
                    a.setId(rs.getInt("id"));
                    a.setUsername(rs.getString("username"));
                    a.setPassword(rs.getString("password"));
                    a.setEmail(rs.getString("email"));
                    a.setPhone(rs.getString("phone"));
                    a.setRole("Admin");
                    
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        a.setCreatedAt(ts.toLocalDateTime());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }

    public boolean update(Admin a) {
        String sql = "UPDATE pengguna SET username=?, email=?, phone=? WHERE id=? AND role='Admin'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, a.getUsername());
            pstmt.setString(2, a.getEmail());
            pstmt.setString(3, a.getPhone());
            pstmt.setInt(4, a.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM pengguna WHERE id=? AND role='Admin'";
        
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