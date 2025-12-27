package com.mycompany.salon.model.entity;

import com.mycompany.salon.model.interfaces.Rateable;
import java.time.LocalDateTime;

public class Feedback implements Rateable {
    private int id;
    private int idBooking;
    private String komentar;
    private double rating;
    private LocalDateTime tanggal;
    
    public Feedback() {}
    
    public Feedback(int idBooking, String komentar, int rating) {
        this.idBooking = idBooking;
        this.komentar = komentar;
        this.rating = rating;
        this.tanggal = LocalDateTime.now();
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

    public int getIdBooking() { return idBooking; }
    public void setIdBooking(int idBooking) { this.idBooking = idBooking; }

    public String getKomentar() { return komentar; }
    public void setKomentar(String komentar) { this.komentar = komentar; }

    public LocalDateTime getTanggal() { return tanggal; }
    public void setTanggal(LocalDateTime tanggal) { this.tanggal = tanggal; }
}
