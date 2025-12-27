package com.mycompany.salon.controller;

import com.mycompany.salon.dao.*;
import com.mycompany.salon.model.entity.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ProfileController", urlPatterns = {
    "/profile",
    "/profile/update",
    "/profile/password"
})

public class ProfileController extends HttpServlet {

    private PelangganDAO pelangganDAO = new PelangganDAO();
    private AdminDAO adminDAO = new AdminDAO();
    private PenggunaDAO penggunaDAO = new PenggunaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Proteksi Session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("DEBUG: No session or user, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        Pengguna user = (Pengguna) session.getAttribute("user");
        
        System.out.println("DEBUG: User class: " + user.getClass().getName());
        System.out.println("DEBUG: Path: " + path);

        switch (path) {
            case "/profile":
                // Handle halaman profil
                System.out.println("DEBUG: Loading profile page");
                
                // Set data untuk JSP
                request.setAttribute("user", user);
                
                // Tentukan role dan forward ke file yang sesuai
                if (user instanceof Pelanggan) {
                    System.out.println("DEBUG: Forwarding to user/profile.jsp");
                    request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
                } else if (user instanceof Admin) {
                    System.out.println("DEBUG: Forwarding to admin/profile.jsp");
                    request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
                } else {
                    System.out.println("DEBUG: Unknown user type, default to user");
                    request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
                }
                break;
                
            default:
                System.out.println("DEBUG: Default case, redirecting to profile");
                response.sendRedirect(request.getContextPath() + "/profile");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if (path.equals("/profile/update")) {
            handleUpdateProfile(request, response);
        } else if (path.equals("/profile/password")) {
            handleChangePassword(request, response);
        }
    }

    // LOGIKA UPDATE BIODATA (Nama, Email, HP)
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna currentUser = (Pengguna) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        // Ambil data dari form
        String nama = request.getParameter("nama"); // Admin mungkin null di form jika tidak ada input nama
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");

        boolean success = false;

        if ("Pelanggan".equals(role)) {
            // Casting ke Pelanggan
            Pelanggan p = (Pelanggan) currentUser;
            p.setNama(nama);
            p.setEmail(email);
            p.setPhone(phone);
            // Username biasanya tidak boleh diganti sembarangan, tapi jika mau: p.setUsername(username);
            
            success = pelangganDAO.updateProfile(p);
            
            if (success) {
                session.setAttribute("user", p); // Update data di session agar tampilan langsung berubah
            }

        } else if ("Admin".equals(role)) {
            // Casting ke Admin
            Admin a = (Admin) currentUser;
            a.setUsername(username); // Admin biasanya boleh ganti username
            a.setEmail(email);
            a.setPhone(phone);
            
            success = adminDAO.update(a);
            
            if (success) {
                session.setAttribute("user", a);
            }
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/profile?status=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=failed");
        }
    }

    // LOGIKA GANTI PASSWORD
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        Pengguna currentUser = (Pengguna) session.getAttribute("user");
        
        String passLama = request.getParameter("oldPassword");
        String passBaru = request.getParameter("newPassword");
        String passKonfirmasi = request.getParameter("confirmPassword");

        // 1. Validasi Password Lama (Harus sama dengan yang di database/session)
        if (!currentUser.getPassword().equals(passLama)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=wrong_password");
            return;
        }

        // 2. Validasi Password Baru
        if (!passBaru.equals(passKonfirmasi)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=password_mismatch");
            return;
        }

        // 3. Update Password via PenggunaDAO
        // Kita butuh method updatePassword di PenggunaDAO (Jika belum ada, tambahkan logic di bawah)
        boolean success = penggunaDAO.updatePassword(currentUser.getId(), passBaru);
        
        if (success) {
            // Update password di session juga
            currentUser.setPassword(passBaru);
            session.setAttribute("user", currentUser);
            response.sendRedirect(request.getContextPath() + "/profile?status=password_changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=db_error");
        }
    }
}