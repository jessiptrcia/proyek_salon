package com.mycompany.salon.model.entity;

public class Pelanggan extends Pengguna {
    private String nama;
    private boolean member;
    private int poinLoyalty;

    // Constructor Kosong (Wajib untuk mapping ResultSet)
    public Pelanggan() {
        super();
    }

    // Constructor untuk Registrasi (Wajib untuk AuthController)
    public Pelanggan(String username, String password, String email, String phone, String nama) {
        super(username, password, email, phone); // Memanggil constructor Pengguna
        this.nama = nama;
        this.member = false; // Default
        this.poinLoyalty = 0; // Default
    }

    // Getter dan Setter...
    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }
    public boolean isMember() { return member; }
    public void setMember(boolean member) { this.member = member; }
    public int getPoinLoyalty() { return poinLoyalty; }
    public void setPoinLoyalty(int poinLoyalty) { this.poinLoyalty = poinLoyalty; }
}