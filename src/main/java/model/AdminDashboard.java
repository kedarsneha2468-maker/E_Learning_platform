package model;


public class AdminDashboard {
    private int totalStudents;
    private int totalInstructors;
    private int totalCourses;
    private int totalEnrollments;

    public AdminDashboard() {
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getTotalInstructors() {
        return totalInstructors;
    }

    public void setTotalInstructors(int totalInstructors) {
        this.totalInstructors = totalInstructors;
    }

    public int getTotalCourses() {
        return totalCourses;
    }

    public void setTotalCourses(int totalCourses) {
        this.totalCourses = totalCourses;
    }

    public int getTotalEnrollments() {
        return totalEnrollments;
    }

    public void setTotalEnrollments(int totalEnrollments) {
        this.totalEnrollments = totalEnrollments;
    }
}