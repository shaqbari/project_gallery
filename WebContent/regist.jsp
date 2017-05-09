<%@page import="java.sql.DriverManager"%>
<%@page import="db.DBConnInfo"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%!
	String fileTitle;
	String fileName;
	
	DBConnInfo dbConnInfo=new DBConnInfo();
	String driver=dbConnInfo.getDriver();
	String url=dbConnInfo.getUrl();
	String user=dbConnInfo.getUser();
	String password=dbConnInfo.getPassword();
	
	Connection con;
	PreparedStatement pstmt;
	
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
				String sql="insert into gallery(gallery_id, gallery_fileTitle, gallery_fileName) values (seq_gallery.nextVal, ?, ?)";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, fileTitle);
				pstmt.setString(2, fileName);
				//regdate는 오라클에서 default sysDate로 처리한다.
				
				int result=pstmt.executeUpdate();
				if(result==1){
					System.out.println("db에 삽입 성공");					
				
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
			
		}
	}
%>
<%
	request.setCharacterEncoding("UTF-8");
	
	ServletFileUpload upload=new ServletFileUpload(new DiskFileItemFactory());
	List<FileItem> list=upload.parseRequest(request);
	
	for(int i=0; i<list.size(); i++){
		FileItem item=list.get(i);
		if(item.isFormField()){//텍스트 파라미터라면
			String fieldName=item.getFieldName();
			
			if(fieldName.equals("fileTitle")){//필드이름이 fileTitle이라면
				fileTitle=item.getString();
				System.out.println(fileTitle);
				out.println("파일 제목은 :"+fileTitle);
			}
			
		}else {//업로드 파라미터				
			String realPath=application.getRealPath("/data");//파일이 저장될 경로 구하기
			fileName=FilenameUtils.getName(item.getName());//파일명 알아맞추기
			String path=realPath+File.separator+fileName;//저장될 최종경로
			System.out.println(path);
			
			InputStream is=item.getInputStream();
			FileOutputStream fos=new FileOutputStream(new File(path));
			
			byte[] b=new byte[1024];
			int flag;
			while(true){
				int result=is.read(b);
				if(result==-1)break;
				fos.write(b);				
			}
			System.out.println("복사완료");
			dbInsert();
			
			if(fos!=null){
				fos.close();				
			}
			if(is!=null){
				is.close();				
			}
		}
	}
	
	response.sendRedirect("list.jsp");
	
%>