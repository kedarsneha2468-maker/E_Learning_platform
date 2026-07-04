package dao;

import java.sql.*;
import java.util.*;
import database.DBConnection;
import model.Module;
import model.Video;

public class CourseDetailsDAO {

    // 🔹 Get modules by course
    public List<Module> getModulesByCourse(int courseId){

        List<Module> list = new ArrayList<>();

        try{
            Connection con = DBConnection.getConnection();

            String q = "SELECT * FROM module WHERE course_id=?";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, courseId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Module m = new Module();

                m.setModuleId(rs.getInt("module_id"));
                m.setModuleName(rs.getString("module_name"));
                m.setDescription(rs.getString("description"));
                m.setCourseId(rs.getInt("course_id"));

                list.add(m);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 Get videos by module ✅
    public List<Video> getVideosByModule(int moduleId){

        List<Video> list = new ArrayList<>();

        try{
            Connection con = DBConnection.getConnection();

            String q = "SELECT * FROM video WHERE module_id=?";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, moduleId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Video v = new Video();

                v.setVideoId(rs.getInt("video_id"));
                v.setModuleId(rs.getInt("module_id"));
                v.setTitle(rs.getString("title"));
                v.setVideoUrl(rs.getString("video_url"));
                v.setDuration(rs.getString("duration"));

                list.add(v);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}