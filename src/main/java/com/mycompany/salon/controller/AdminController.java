package com.mycompany.salon.controller;

import com.mycompany.salon.dao.*;
import com.mycompany.salon.model.entity.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/dashboard", "/admin/katalog", "/admin/kapster", "/admin/booking-action"})
public class AdminController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private KatalogDAO katalogDAO = new KatalogDAO();
    private KapsterDAO kapsterDAO = new KapsterDAO();
    private PelangganDAO pelangganDAO = new PelangganDAO();

    // Helper untuk cek apakah user adalah ADMIN
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String role = (String) session.getAttribute("role");
        return "Admin".equals(role);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                // 2. Ambil daftar pelanggan agar tabel tidak kosong
                List<Pelanggan> allPelanggan = pelangganDAO.findAll();
                // 3. Pastikan Nama Atribut SAMA dengan yang ada di dashboard.jsp
                request.setAttribute("pelangganList", allPelanggan);
                
                // Opsional: Jika Anda juga ingin menampilkan data booking di halaman yang sama
                List<Booking> allBookings = bookingDAO.findAll();
                request.setAttribute("bookings", allBookings);

                request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
                break;

            case "/admin/katalog":
                request.setAttribute("listKatalog", katalogDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/katalog.jsp").forward(request, response);
                break;

            case "/admin/kapster":
                request.setAttribute("listKapster", kapsterDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/kapster.jsp").forward(request, response);
                break;
                
            default:
                response.sendRedirect("dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) return;

        String path = request.getServletPath();
        
        if (path.equals("/admin/booking-action")) {
            // Confirm atau Cancel Booking
            int id = Integer.parseInt(request.getParameter("id"));
            String action = request.getParameter("act"); // 'confirm' atau 'cancel' atau 'complete'
            
            String status = "Pending";
            if ("confirm".equals(action)) status = "Confirmed";
            else if ("cancel".equals(action)) status = "Cancelled";
            else if ("complete".equals(action)) status = "Completed";
            
            bookingDAO.updateStatus(id, status);
            response.sendRedirect("dashboard");
            
        } else if (path.equals("/admin/katalog")) {
            // Tambah Layanan Baru
            String nama = request.getParameter("nama");
            int harga = Integer.parseInt(request.getParameter("harga"));
            String deskripsi = request.getParameter("deskripsi");
            
            Katalog k = new Katalog(nama, harga);
            k.setDeskripsi(deskripsi);
            katalogDAO.save(k);
            
            response.sendRedirect("katalog");
            
        } else if (path.equals("/admin/kapster")) {
            // Tambah Kapster Baru
            String nama = request.getParameter("nama");
            String spesialisasi = request.getParameter("spesialisasi");
            
            Kapster k = new Kapster(nama, spesialisasi);
            kapsterDAO.save(k);
            
            response.sendRedirect("kapster");
        }
    }
}