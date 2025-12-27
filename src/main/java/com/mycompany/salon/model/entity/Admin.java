package com.mycompany.salon.model.entity;

public class Admin extends Pengguna {
    public Admin() {}
    
    public Admin(String username, String password, String email, String phone) {
        super(username, password, email, phone);
        this.setRole("Admin");
    }
}