package model;

import java.util.Date;

public class Student {
    private int studentId;
    private String name;
    private String email;
    private String password;
    private String mobileNo;
    private Date enrollDate;
    
    // Constructors
    public Student() {}
    
    public Student(int studentId, String name, String email, String mobileNo, Date enrollDate) {
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.mobileNo = mobileNo;
        this.enrollDate = enrollDate;
    }
    
    // Getters and Setters
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
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
    
    public String getMobileNo() {
        return mobileNo;
    }
    
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }
    
    public Date getEnrollDate() {
        return enrollDate;
    }
    
    public void setEnrollDate(Date enrollDate) {
        this.enrollDate = enrollDate;
    }
    
    @Override
    public String toString() {
        return "Student{" +
                "studentId=" + studentId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", mobileNo='" + mobileNo + '\'' +
                ", enrollDate=" + enrollDate +
                '}';
    }
}