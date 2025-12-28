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

@WebServlet(name = "AdminController", urlPatterns = {"/admin/dashboard", "/admin/katalog", "/admin/kapster", "/admin/promo", "/admin/pengguna", "/admin/report", "/admin/booking-action"})
public class AdminController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private KatalogDAO katalogDAO = new KatalogDAO();
    private KapsterDAO kapsterDAO = new KapsterDAO();
    private PelangganDAO pelangganDAO = new PelangganDAO();
    private PromoDAO promoDAO = new PromoDAO();
    
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
                request.setAttribute("pelangganList", pelangganDAO.findAll());
                request.setAttribute("bookings", bookingDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
                break;

            case "/admin/promo":
                request.setAttribute("promoList", promoDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/kelola_promo.jsp").forward(request, response);
                break;
                
            case "/admin/katalog":
                request.setAttribute("listKatalog", katalogDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/kelola_layanan.jsp").forward(request, response);
                break;

            case "/admin/kapster":
                request.setAttribute("listKapster", kapsterDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/kapster.jsp").forward(request, response);
                break;
                
            case "/admin/report":
                String type = request.getParameter("type"); 
                String val = request.getParameter("value");
                List<Booking> reportData;
                if (type != null && val != null && !val.isEmpty()) {
                    reportData = bookingDAO.findReport(type, val);
                } else {
                    reportData = bookingDAO.findReport("all", "");
                }
                request.setAttribute("listReport", reportData);
                request.getRequestDispatcher("/WEB-INF/views/admin/kelola_report.jsp").forward(request, response);
                break;
            
            case "/admin/pengguna":
                String action = request.getParameter("action");
                if ("edit".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Pelanggan p = pelangganDAO.findById(id);
                    if (p != null) {
                        request.setAttribute("pelanggan", p);
                        request.getRequestDispatcher("/WEB-INF/views/admin/edit_pengguna.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("pengguna");
                    }
                } else {
                    request.setAttribute("listPengguna", pelangganDAO.findAll());
                    request.getRequestDispatcher("/WEB-INF/views/admin/kelola_pengguna.jsp").forward(request, response);
                }
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
        String action = request.getParameter("action");
        
        
        if (path.equals("/admin/promo")) {
            if ("delete".equals(action)) {
                promoDAO.delete(Integer.parseInt(request.getParameter("id")));
            } else {
                Promo p = new Promo(request.getParameter("kode_promo"), Double.parseDouble(request.getParameter("diskon")));
                p.setDeskripsi(request.getParameter("deskripsi"));
                promoDAO.save(p);
            }
            response.sendRedirect("promo");
        
        } else if (path.equals("/admin/booking-action")) {
            int id = Integer.parseInt(request.getParameter("id"));
            String act = request.getParameter("act"); 
            String status = "Pending";
            if ("confirm".equals(act)) status = "Confirmed";
            else if ("cancel".equals(act)) status = "Cancelled";
            else if ("complete".equals(act)) status = "Completed";
            bookingDAO.updateStatus(id, status);
            response.sendRedirect("dashboard");
            
        } else if (path.equals("/admin/katalog")) {
            if ("delete".equals(action)) {
                // Tambahkan validasi ID agar tidak error parsing
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    try {
                        // Tampung hasil eksekusi delete (True/False)
                        boolean sukses = katalogDAO.delete(Integer.parseInt(idStr));

                        if (sukses) {
                            // Berhasil hapus (data bersih/belum ada transaksi)
                            response.sendRedirect("katalog?status=deleted");
                        } else {
                            // Gagal hapus (biasanya karena Foreign Key / dipakai di booking)
                            response.sendRedirect("katalog?error=cannot_delete");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        // Jaga-jaga jika ada error lain
                        response.sendRedirect("katalog?error=db_error");
                    }
                }
                return;
            } else {
                // SAVE / UPDATE
                // Cek apakah ini create baru atau update
                String idParam = request.getParameter("id");
                
                Katalog k = new Katalog(request.getParameter("nama"), Integer.parseInt(request.getParameter("harga")));
                k.setDeskripsi(request.getParameter("deskripsi"));
                
                if (idParam != null && !idParam.isEmpty()) {
                    // INI UPDATE
                    k.setId(Integer.parseInt(idParam));
                    katalogDAO.updateInfo(k); // Panggil method baru yang aman untuk rating
                } else {
                    // INI INSERT BARU
                    katalogDAO.save(k);
                }
            }
            response.sendRedirect("katalog");
            
        } else if (path.equals("/admin/kapster")) {
            if ("delete".equals(action)) {
                String idParam = request.getParameter("id");
                if(idParam != null) kapsterDAO.delete(Integer.parseInt(idParam));
            } else {
                Kapster kapster = new Kapster(request.getParameter("nama"), request.getParameter("spesialisasi"));
                // Karena di form kapster tidak ada input ID (hanya create), logika ini mungkin perlu disesuaikan 
                // jika nanti Anda menambahkan fitur Edit Kapster.
                kapsterDAO.save(kapster);
            }
            response.sendRedirect("kapster");
        
        } else if (path.equals("/admin/pengguna")) {
            if ("delete".equals(action)) {
                try {
                    pelangganDAO.delete(Integer.parseInt(request.getParameter("id")));
                } catch (Exception e) {
                    // Cegah error jika id booking masih nyangkut (Constraint DB)
                    e.printStackTrace();
                }
            } else if ("update".equals(action)) {
                Pelanggan p = new Pelanggan();
                p.setId(Integer.parseInt(request.getParameter("id")));
                p.setNama(request.getParameter("nama"));
                p.setEmail(request.getParameter("email"));
                // Perhatikan nama parameter dari JSP edit_pengguna.jsp adalah 'telepon'
                p.setPhone(request.getParameter("telepon")); 
                
                pelangganDAO.update(p);
            }
            response.sendRedirect("pengguna");
        } 
    }
}