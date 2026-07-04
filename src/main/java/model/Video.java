package model;

import java.sql.Timestamp;

public class Video {
    private int videoId;
    private String title;
    private String videoUrl;
    private String duration;
    private int moduleId;
    private boolean isWatched;  // Add this field for tracking watched status
    private Timestamp watchedAt; // Optional: track when it was watched
    
    public Video() {}
    
    // Getters and Setters
    public int getVideoId() {
        return videoId;
    }
    
    public void setVideoId(int videoId) {
        this.videoId = videoId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getVideoUrl() {
        return videoUrl;
    }
    
    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public int getModuleId() {
        return moduleId;
    }
    
    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }
    
    public boolean isWatched() {
        return isWatched;
    }
    
    public void setWatched(boolean isWatched) {
        this.isWatched = isWatched;
    }
    
    public Timestamp getWatchedAt() {
        return watchedAt;
    }
    
    public void setWatchedAt(Timestamp watchedAt) {
        this.watchedAt = watchedAt;
    }
}