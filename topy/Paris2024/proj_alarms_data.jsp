<%@ page language="java" contentType="text/json; charset=utf-8"  pageEncoding="big5"%>
<%@ page import="java.text.*"%><%@ page import ="java.sql.*"%><%@ page import="java.util.*"%>
<%@ page import="javax.sql.*"%><%@ page import="javax.naming.*"%>
<%!public String rmNull(String myString){
if(myString!=null)
return myString;
else
return "";
}%>
<%
        response.setHeader("Pragma","no-cache");
        response.setHeader("Cache-Control","no-cache");
        response.setDateHeader("Expires", 0);
String myVal="";
if(request.getParameter("mypara")!=null)
myVal=request.getParameter("mypara");

java.util.Date date = new java.util.Date();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//�i���ഫ
String dateString = sdf.format(date);


Context ctx = new InitialContext(); 
Context env=(Context)ctx.lookup("java:comp/env");
DataSource ds =(DataSource)env.lookup("jdbc/noc_194"); 
PreparedStatement  pstmt = null;
Connection conn = null;
ResultSet rset=null;
String sqlstr="";
String pid="376";
boolean istest=false;
if(request.getParameter("pid")!=null)
pid=request.getParameter("pid");
else
istest=false;
//istest=true;
try{
if(istest){
%>
<%
}else{
conn = ds.getConnection();
sqlstr="select * from PNM_GRAPHICDATA where PID=?";
pstmt = conn.prepareStatement(sqlstr);
pstmt.setString(1,pid);
rset=pstmt.executeQuery();
while(rset.next()){
Blob blob = rset.getBlob("JSON");
byte[] bdata = blob.getBytes(1, (int) blob.length());
String s = new String(bdata,"UTF-8");%>
{"ProjData": <%=s%>,"Datetime":"<%=dateString%>"}
<%}
if(pstmt!=null) pstmt.close();
if(conn!=null)
conn.close();
}
}catch (Exception ex) {
out.println("���~e"+ex.toString()+sqlstr);
  try { if(conn != null && !conn.isClosed())
conn.close();} catch (SQLException XeE) { ; }
            
  } finally {
    // Always make sure result sets and statements are closed,
    // and the connection is returned to the pool
    if (rset != null) {
      try { rset.close(); } catch (SQLException XeE) { ; }
      rset = null;
    }
    if (pstmt != null) {
      try { pstmt.close(); } catch (SQLException XeE) { ; }
      pstmt = null;
    }
    if (conn != null) {
      try { conn.close(); } catch (SQLException XeE) { ; }
      conn = null;
    }

  }
  %>
