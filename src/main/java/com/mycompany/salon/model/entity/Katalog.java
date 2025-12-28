package com.mycompany.salon.model.entity;

import com.mycompany.salon.model.interfaces.Rateable;

public class Katalog implements Rateable {
    private int id;
    private String namaLayanan; 
    private int harga;  
    private String deskripsi;
    private int durasiMenit;
    private double rating;
    private int jumlahUlasan;

    public Katalog() {}
    
    public Katalog(String namaLayanan, int harga) {
        this.namaLayanan = namaLayanan;
        this.harga = harga;
        this.deskripsi = "-";
        this.durasiMenit = 30; // Default
        this.rating = 0.0;
    }
    
    public void tambahUlasan(double ratingBaru) {
        double totalSkorLama = this.rating * this.jumlahUlasan;
        this.jumlahUlasan++;
        this.rating = (totalSkorLama + ratingBaru) / this.jumlahUlasan;
    }
    
    @Override
    public double getRating() {
        return this.rating;
    }

    @Override
    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNamaLayanan() { return namaLayanan; }
    public void setNamaLayanan(String namaLayanan) { this.namaLayanan = namaLayanan; }

    public int getHarga() { return harga; }
    public void setHarga(int harga) { this.harga = harga; }

    public String getDeskripsi() { return deskripsi; }
    public void setDeskripsi(String deskripsi) { this.deskripsi = deskripsi; }
    
    public int getDurasiMenit() { return durasiMenit; }
    public void setDurasiMenit(int durasiMenit) { this.durasiMenit = durasiMenit; }
    
    public int getJumlahUlasan() { return jumlahUlasan; }
    public void setJumlahUlasan(int jumlahUlasan) { this.jumlahUlasan = jumlahUlasan; }
}