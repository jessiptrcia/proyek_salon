package com.mycompany.salon.controller;

import com.mycompany.salon.dao.*;
import com.mycompany.salon.model.entity.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookingController", urlPatterns = {
    "/booking",        // Halaman Dashboard Pelanggan
    "/booking/form",   // Halaman Form Pemesanan
    "/booking/save",   // Proses simpan booking
    "/booking/history", // Halaman Riwayat
    "/booking/feedback" // Proses simpan feedback
})
public class BookingController extends HttpServlet {

    private final KatalogDAO katalogDAO = new KatalogDAO();
    private final KapsterDAO kapsterDAO = new KapsterDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PromoDAO promoDAO = new PromoDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
        // Proteksi Session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        Pengguna user = (Pengguna) session.getAttribute("user");

        switch (path) {
            case "/booking":
                // KUNCI: Arahkan ke Dashboard, bukan ke Form!
                // Ambil data untuk kartu dashboard agar tidak kosong
                request.setAttribute("jadwalAktif", bookingDAO.findNextBooking(user.getId()));
                request.setAttribute("riwayatTerakhir", bookingDAO.findLastBooking(user.getId()));

                // Arahkan ke folder /user/ sesuai permintaan Anda
                request.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(request, response);
                break;

            case "/booking/form":
                // Pindahkan rute form ke sini agar terpisah dari dashboard
                request.setAttribute("listLayanan", katalogDAO.findAll());
                request.setAttribute("listKapster", kapsterDAO.findAll());

                // Pastikan file booking_form.jsp juga ada di dalam folder /user/
                request.getRequestDispatcher("/WEB-INF/views/user/booking_form.jsp").forward(request, response);
                break;

            //case "/booking/history":
            //    request.setAttribute("riwayat", bookingDAO.findByPelangganId(user.getId()));
            //    request.getRequestDispatcher("/WEB-INF/views/user/booking_history.jsp").forward(request, response);
            //    break;
                
            case "/booking/history":
                List<Booking> riwayat = bookingDAO.findByPelangganId(user.getId());

                // Ambil data feedback untuk setiap booking
                Map<Integer, Feedback> feedbackMap = new HashMap<>();
                for (Booking booking : riwayat) {
                    Feedback feedback = feedbackDAO.findByBookingId(booking.getId());
                    if (feedback != null) {
                        feedbackMap.put(booking.getId(), feedback);
                    }
                }

                request.setAttribute("riwayat", riwayat);
                request.setAttribute("feedbackMap", feedbackMap); // Kirim map feedback ke JSP
                request.getRequestDispatcher("/WEB-INF/views/user/booking_history.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/booking");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        if (path.equals("/booking/save")) {
            handleSaveBooking(request, response);
        } else if (path.equals("/booking/feedback")) {
            handleSaveFeedback(request, response);
        }
    }

    private void handleSaveBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pelanggan p = (Pelanggan) session.getAttribute("user");
        
        try {
            // Mengambil Data Form
            String strTanggal = request.getParameter("tanggal");
            String idKapster = request.getParameter("kapsterId");
            // String[] idLayanans = request.getParameterValues("layananIds");
            String layananIdsParam = request.getParameter("layananIds");
            List<Integer> idLayanans = new ArrayList<>();
            String kodePromo = request.getParameter("kodePromo");

            Booking b = new Booking();
            b.setPelanggan(p);
            b.setTanggal(LocalDateTime.parse(strTanggal));
            b.setKapster(kapsterDAO.findById(Integer.parseInt(idKapster)));

            // Parsing string ke array
            if (layananIdsParam != null && !layananIdsParam.trim().isEmpty()) {
                String[] idArray = layananIdsParam.split(",");
                for (String idStr : idArray) {
                    if (!idStr.trim().isEmpty()) {
                        try {
                            idLayanans.add(Integer.parseInt(idStr.trim()));
                        } catch (NumberFormatException e) {
                            // Handle error jika bukan angka
                            throw new Exception("ID layanan tidak valid: " + idStr);
                        }
                    }
                }
            }

            // Kemudian loop untuk menambahkan layanan
            for (Integer layananId : idLayanans) {
                Katalog k = katalogDAO.findById(layananId);
                b.addLayanan(k);
            }
            // Input Layanan dan Hitung Harga
//          if (idLayanans != null) {
//              for (String idL : idLayanans) {
//                  Katalog k = katalogDAO.findById(Integer.parseInt(idL));
//                  b.addLayanan(k); 
//              }
//          }

            // Input Promo
            if (kodePromo != null && !kodePromo.isEmpty()) {
                Promo promo = promoDAO.findByKode(kodePromo);
                if (promo != null) {
                    b.setPromo(promo);
                    b.calculateTotal(); 
                }
            }
            
            if (bookingDAO.save(b)) {
                response.sendRedirect(request.getContextPath() + "/booking/history?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking/form?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking/form?error=invalid_input");
        }
    }

    private void handleSaveFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String komentar = request.getParameter("komentar");

        Feedback fb = new Feedback(bookingId, komentar, rating);
        feedbackDAO.save(fb); 

        response.sendRedirect(request.getContextPath() + "/booking/history?status=feedback_saved");
    }
}