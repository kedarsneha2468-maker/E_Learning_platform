package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Certificate {
    private int certificateId;
    private int studentId;
    private int courseId;
    private String certificateCode;
    private Timestamp issueDate;
    private int downloadCount;
    
    public Certificate() {}
    
    public int getCertificateId() { return certificateId; }
    public void setCertificateId(int certificateId) { this.certificateId = certificateId; }
    
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    
    public String getCertificateCode() { return certificateCode; }
    public void setCertificateCode(String certificateCode) { this.certificateCode = certificateCode; }
    
    public Timestamp getIssueDate() { return issueDate; }
    public void setIssueDate(Timestamp issueDate) { this.issueDate = issueDate; }
    
    public String getIssueDateFormatted() {
        if (issueDate == null) return "N/A";
        return new SimpleDateFormat("dd MMMM yyyy").format(issueDate);
    }
    
    public int getDownloadCount() { return downloadCount; }
    public void setDownloadCount(int downloadCount) { this.downloadCount = downloadCount; }
}