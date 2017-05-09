<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="db.Gallery"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.DBConnInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%!		
	DBConnInfo dbConnInfo=new DBConnInfo();
	String driver=dbConnInfo.getDriver();
	String url=dbConnInfo.getUrl();
	String user=dbConnInfo.getUser();
	String password=dbConnInfo.getPassword();
	
	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;
	
	ArrayList<Gallery> gallerys=new ArrayList<Gallery>();
	
	public void dbInsert(){
		try{
			/* Context initCtx=new InitialContext();
			Context envCtx=(Context) initCtx.lookup("java:comp/env");
			DataSource ds=(DataSource) envCtx.lookup("jdbc/java");
			con=ds.getConnection(); */
			
			Class.forName(driver);
			System.out.println("로드 성공");
			con=DriverManager.getConnection(url, user, password);
						
			if(con!=null){
				System.out.println("접속 성공");
				String sql="select * from gallery order by gallery_id asc";
				pstmt=con.prepareStatement(sql);
								
				rs=pstmt.executeQuery();
				
				while(rs.next()){
					Gallery dto=new Gallery();
					dto.setGallery_id(rs.getInt("gallery_id"));
					dto.setGallery_fileTitle(rs.getString("gallery_fileTitle"));
					dto.setGallery_fileName(rs.getString("gallery_fileName"));
					dto.setGallery_RegDate(rs.getString("gallery_RegDate"));
					
					gallerys.add(dto);
				}
				
			}					
			
		/* }catch(NamingException e){
			e.printStackTrace();
			 */
		}catch(ClassNotFoundException e){
			e.printStackTrace();
		}catch(SQLException e){
			e.printStackTrace();
			
		}finally{
			if(pstmt!=null){
				try{
					pstmt.close();
				}catch(SQLException e){
					
				}
			}
			if(con!=null){
				try{
					con.close();
				}catch(SQLException e){
					
				}
			}
			if(rs!=null){
				try{
					rs.close();
				}catch(SQLException e){
					
				}
			}
			
		}
	}
%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>갤러리</title>
	<style>	
		.container{
			margin:0 auto;		
			width:1010px;
			height: 1210px;
			background: green;
		}
	
		.list{
			width:200px;
			height:300px;			
			border:1px solid red;
			background:yellow;
			
			float: left;
		}
		
		.title{
			width:100px;
			height:50px;
		}
		
		.img{
			width:200px;
			height:200px;
		}
		
		.regdate{
			width:100px;
			height:100px;
		}
		
	</style>
	

</head>
<body>
	<div class="container">
		<%
		gallerys.removeAll(gallerys);//지우고 보여줘야 한다.
		dbInsert();		
		System.out.println(gallerys.size());
		for(int i=0; i<gallerys.size(); i++){ 
			Gallery gallery=gallerys.get(i);
		%>
		<div class="list">
			<div class="title"><%=gallery.getGallery_fileTitle()%></div>
			<img class="img" src="data/<%=gallery.getGallery_fileName() %>"/>
			<div class="regdate"><%=gallery.getGallery_RegDate()%></div>		
		</div>
		<%} %>
	</div>	
</body>
</html>