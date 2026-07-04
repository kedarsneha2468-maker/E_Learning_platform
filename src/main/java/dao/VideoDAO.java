package dao;

import java.sql.*;
import java.util.*;
import database.DBConnection;
import model.Video;

public class VideoDAO {

    // 🔹 Get all videos for a course
    public List<Video> getVideosByCourseId(int moduleId) {

        List<Video> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String query = "SELECT * FROM video WHERE module_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, moduleId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Video v = new Video();

                v.setVideoId(rs.getInt("video_id"));
                v.setModuleId(rs.getInt("module_id"));
                v.setTitle(rs.getString("video_title"));
                v.setVideoUrl(rs.getString("video_url"));
                v.setDuration(rs.getString("duration"));

                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 Add new video
    public boolean addVideo(Video v) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO video(module_id, video_title, video_url, duration) VALUES(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, v.getModuleId());
            ps.setString(2, v.getTitle());
            ps.setString(3, v.getVideoUrl());
            ps.setString(4, v.getDuration());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}