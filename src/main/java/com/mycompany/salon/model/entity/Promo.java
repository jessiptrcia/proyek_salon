package com.mycompany.salon.model.entity;

public class Promo {
    private int id;
    private String kodePromo; 
    private double diskon;   
    private String deskripsi;

    public Promo() {}
    
    public Promo(String kodePromo, double diskon) {
        this.kodePromo = kodePromo;
        this.diskon = diskon;
        this.deskripsi = "-";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getKodePromo() { return kodePromo; }
    public void setKodePromo(String kodePromo) { this.kodePromo = kodePromo; }

    public double getDiskon() { return diskon; }
    public void setDiskon(double diskon) { this.diskon = diskon; }

    public String getDeskripsi() { return deskripsi; }
    public void setDeskripsi(String deskripsi) { this.deskripsi = deskripsi; }
}