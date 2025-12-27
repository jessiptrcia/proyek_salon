package com.mycompany.salon;

import com.mycompany.salon.dao.*;
import com.mycompany.salon.model.entity.*;
import java.time.LocalDateTime;
import java.util.List;

public class MainTest {
    
    public static void main(String[] args) {
        System.out.println("=== MULAI TESTING SISTEM SALON ===");

        // 1. Inisialisasi DAO
        KatalogDAO katalogDAO = new KatalogDAO();
        KapsterDAO kapsterDAO = new KapsterDAO();
        PelangganDAO pelangganDAO = new PelangganDAO();
        PenggunaDAO penggunaDAO = new PenggunaDAO();
        BookingDAO bookingDAO = new BookingDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        try {
            // --- SKENARIO 1: ADMIN INPUT DATA MASTER ---
            System.out.println("\n[1] Menambahkan Data Master (Layanan & Kapster)...");
            
            // Tambah Katalog Layanan
            Katalog layananBaru = new Katalog("Potong Rambut Premium", 50000);
            layananBaru.setDeskripsi("Potong rambut + pijat kepala");
            if (katalogDAO.save(layananBaru)) {
                System.out.println("   -> Sukses tambah layanan: " + layananBaru.getNamaLayanan());
            }

            // Tambah Kapster
            Kapster kapsterBaru = new Kapster("Budi Barber", "Spesialis Fade");
            if (kapsterDAO.save(kapsterBaru)) {
                System.out.println("   -> Sukses tambah kapster: " + kapsterBaru.getNama());
            }

            // --- SKENARIO 2: PELANGGAN REGISTRASI ---
            System.out.println("\n[2] Pelanggan Mendaftar...");
            String usernameUnik = "user" + System.currentTimeMillis(); // Biar tidak error duplicate entry saat ditest berkali-kali
            Pelanggan p = new Pelanggan(usernameUnik, "pass123", "user@test.com", "08123456789", "Asep Customer");
            
            if (pelangganDAO.save(p)) {
                System.out.println("   -> Registrasi sukses: " + p.getNama());
            }

            // --- SKENARIO 3: LOGIN & PERSIAPAN BOOKING ---
            System.out.println("\n[3] Login & Ambil Data ID...");
            
            // Login untuk dapatkan Object Pelanggan lengkap (termasuk ID)
            Pengguna hasilLogin = penggunaDAO.login(usernameUnik, "pass123");
            Pelanggan customerLogged = (Pelanggan) hasilLogin;
            System.out.println("   -> Login sebagai ID: " + customerLogged.getId());

            // Ambil ID Kapster & Katalog terakhir yang baru kita input
            // (Dalam aplikasi asli, user memilih dari List)
            List<Kapster> listKapster = kapsterDAO.findAll();
            Kapster kapsterPilihan = listKapster.get(listKapster.size() - 1); // Ambil yang paling baru
            
            List<Katalog> listKatalog = katalogDAO.findAll();
            Katalog layananPilihan = listKatalog.get(listKatalog.size() - 1); // Ambil yang paling baru

            // --- SKENARIO 4: PROSES BOOKING ---
            System.out.println("\n[4] Membuat Booking...");
            
            Booking booking = new Booking();
            booking.setPelanggan(customerLogged);
            booking.setKapster(kapsterPilihan);
            booking.setTanggal(LocalDateTime.now().plusDays(1)); // Booking untuk besok
            booking.addLayanan(layananPilihan); // Tambah layanan ke list
            // booking.setPromo(null); // Tidak pakai promo
            
            if (bookingDAO.save(booking)) {
                System.out.println("   -> Booking Berhasil Disimpan!");
                System.out.println("   -> ID Booking: " + booking.getId());
                System.out.println("   -> Total Harga: Rp " + booking.getTotalHarga());
            } else {
                System.out.println("   -> GAGAL Booking!");
                return; // Stop jika gagal
            }

            // --- SKENARIO 5: MEMBERI FEEDBACK ---
            System.out.println("\n[5] Memberi Rating Bintang 5...");
            
            // User memberi rating 5.0
            Feedback ulasan = new Feedback(booking.getId(), "Pelayanan sangat memuaskan, cukuran rapi!", 5);
            
            if (feedbackDAO.save(ulasan)) {
                System.out.println("   -> Feedback tersimpan.");
            }

            // --- SKENARIO 6: VERIFIKASI UPDATE RATING OTOMATIS ---
            System.out.println("\n[6] Cek Update Rating Kapster & Katalog...");
            
            // Ambil data terbaru dari database
            Kapster kapsterUpdated = kapsterDAO.findById(kapsterPilihan.getId());
            Katalog katalogUpdated = katalogDAO.findById(layananPilihan.getId());
            
            System.out.println("   -> Rating Kapster (" + kapsterUpdated.getNama() + ") sekarang: " + kapsterUpdated.getRating() + " (Jlh Ulasan: " + kapsterUpdated.getJumlahUlasan() + ")");
            System.out.println("   -> Rating Layanan (" + katalogUpdated.getNamaLayanan() + ") sekarang: " + katalogUpdated.getRating() + " (Jlh Ulasan: " + katalogUpdated.getJumlahUlasan() + ")");

            System.out.println("\n=== TESTING SELESAI & SUKSES ===");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("\n!!! ADA ERROR SAAT TESTING !!!");
        }
    }
}