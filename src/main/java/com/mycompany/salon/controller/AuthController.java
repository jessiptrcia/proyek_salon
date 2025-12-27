package com.mycompany.salon.controller;

import com.mycompany.salon.dao.PelangganDAO;
import com.mycompany.salon.dao.PenggunaDAO;
import com.mycompany.salon.model.entity.Pelanggan;
import com.mycompany.salon.model.entity.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AuthController", urlPatterns = {
    "/login", 
    "/register", 
    "/logout", 
    "/about_us/login", 
    "/about_us/register", 
    "/services/login",
    "/services/register",
    "/store/login", 
    "/store/register",
    "/help/login",
    "/help/register"   
})
public class AuthController extends HttpServlet {

    // Menginisialisasi kedua DAO yang diperlukan
    private PenggunaDAO penggunaDAO = new PenggunaDAO();
    private PelangganDAO pelangganDAO = new PelangganDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uri = request.getRequestURI();

        // ROUTING: Semua rute login dan register diarahkan ke login.jsp
        if (uri.endsWith("/login") || uri.endsWith("/register") || uri.endsWith("/signup")) {
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } 
        else if (uri.endsWith("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?message=logged_out");
        } 
        else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uri = request.getRequestURI();

        if (uri.endsWith("/login")) {
            handleLogin(request, response);
        } else if (uri.endsWith("/register")) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        // Memanggil logika login dari database
        Pengguna user = penggunaDAO.login(u, p);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Pengalihan berdasarkan Role dari database
            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking");
            }
        } else {
            request.setAttribute("error", "Username atau Password salah!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Mengambil data dari form register di login.jsp
        String nama = request.getParameter("nama");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Membuat objek Pelanggan untuk disimpan ke database
        Pelanggan pelanggan = new Pelanggan(user, pass, email, phone, nama);

        // Memanggil logika save pada PelangganDAO
        if (pelangganDAO.save(pelanggan)) {
            // Jika berhasil, kirim parameter message untuk login.jsp
            response.sendRedirect(request.getContextPath() + "/login?message=registered");
        } else {
            request.setAttribute("error", "Gagal Mendaftar (Username mungkin sudah ada)");
            // Kembali ke login.jsp dengan status signup tetap aktif
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}