package model;

public class Instructor {
    private int instructorId;
    private String name;
    private String email;
    private String password;
    private String expertise;
    private int experience;
    
    public Instructor() {}
    
    public Instructor(int instructorId, String name, String email, String expertise, int experience) {
        this.instructorId = instructorId;
        this.name = name;
        this.email = email;
        this.expertise = expertise;
        this.experience = experience;
    }
    
    // Getters and Setters
    public int getInstructorId() {
        return instructorId;
    }
    
    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getExpertise() {
        return expertise;
    }
    
    public void setExpertise(String expertise) {
        this.expertise = expertise;
    }
    
    public int getExperience() {
        return experience;
    }
    
    public void setExperience(int experience) {
        this.experience = experience;
    }
}