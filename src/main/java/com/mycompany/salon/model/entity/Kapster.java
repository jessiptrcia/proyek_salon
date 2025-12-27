package com.mycompany.salon.model.entity;

import com.mycompany.salon.model.interfaces.Rateable;

public class Kapster implements Rateable {
    private int id;
    private String nama;
    private String spesialisasi; 
    private String status;      
    private double rating; 
    private int jumlahUlasan;
    private String foto;         

    public Kapster() {}
    
    public Kapster(String nama, String spesialisasi) {
        this.nama = nama;
        this.spesialisasi = spesialisasi;
        this.rating = 0.0;
        this.status = "Open";
        this.foto = "default_kapster.jpg";
    }
    
    public void updateRating(double newRating) {
        this.rating = newRating;
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

    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }

    public String getSpesialisasi() { return spesialisasi; }
    public void setSpesialisasi(String spesialisasi) { this.spesialisasi = spesialisasi; }

    public String getStatus() { return status; } 
    public void setStatus(String status) { this.status = status; }

    public int getJumlahUlasan() { return jumlahUlasan; }
    public void setJumlahUlasan(int jumlahUlasan) { this.jumlahUlasan = jumlahUlasan; }
    
    public String getFoto() { return foto; }
    public void setFoto(String foto) { this.foto = foto; }
}