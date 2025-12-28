package com.mycompany.salon.model.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Booking {
    private int id;
    private Pelanggan pelanggan; 
    private Kapster kapster;
    private List<Katalog> listKatalog = new ArrayList<>();
    private LocalDateTime tanggal;
    private String status;
    private double totalHarga;
    private Promo promo;

    public Booking() {}
    
    public Booking(Pelanggan pelanggan, Kapster kapster, LocalDateTime tanggal, Promo promo) {
        this.pelanggan = pelanggan;
        this.kapster = kapster;
        this.tanggal = tanggal;
        this.promo = promo;
        this.status = "Pending";
        this.totalHarga = 0.0;
    }
    
    public void addLayanan(Katalog layanan) {
        this.listKatalog.add(layanan);
        calculateTotal();
    }

    public void calculateTotal() {
        double subtotal = 0;
        
        for (Katalog k : listKatalog) {
            subtotal += k.getHarga();
        }

        if (this.promo != null) {
            subtotal -= subtotal*this.promo.getDiskon();
        }

        this.totalHarga = (subtotal < 0) ? 0 : subtotal;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Pelanggan getPelanggan() { return pelanggan; }
    public void setPelanggan(Pelanggan pelanggan) { this.pelanggan = pelanggan; }
    
    public Kapster getKapster() { return kapster; }
    public void setKapster(Kapster kapster) { this.kapster = kapster; }
    
    public List<Katalog> getListKatalog() { return listKatalog; }
    public void setListKatalog(List<Katalog> listKatalog) { this.listKatalog = listKatalog; }
    
    public LocalDateTime getTanggal() { return tanggal; }
    public void setTanggal(LocalDateTime tanggal) { this.tanggal = tanggal; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getTotalHarga() { return totalHarga; }
    public void setTotalHarga(double totalHarga) { this.totalHarga = totalHarga; }
    
    public Promo getPromo() { return promo; }
    public void setPromo(Promo promo) { this.promo = promo; }
}