<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
	<%@ include file = "headerstyle.html" %>
        <%@ include file = "header.jsp" %>
        <div class="maincontent" align="center">

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
// TODO: Print Customer information
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{

    // TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city,state, postalCode, country FROM customer WHERE userid = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userName);
    ResultSet rst = pstmt.executeQuery();
    while(rst.next()){
        out.print("<h3>Customer Profile</h3>");
        out.print("<table border=\"1\">");
        out.print("    <tbody><tr><th>Id</th><td>"+rst.getString(1)+"</td></tr>");
        out.print("    <tr><th>First Name</th><td>"+rst.getString(2)+"</td></tr>");
        out.print("    <tr><th>Last Name</th><td>"+rst.getString(3)+"</td></tr>");
        out.print("    <tr><th>Email</th><td>"+rst.getString(4)+"</td></tr>");
        out.print("    <tr><th>Phone</th><td>"+rst.getString(5)+"</td></tr>");
        out.print("    <tr><th>Address</th><td>"+rst.getString(6)+"</td></tr>");
        out.print("    <tr><th>City</th><td>"+rst.getString(7)+"</td></tr>");
        out.print("    <tr><th>State</th><td>"+rst.getString(8)+"</td></tr>");
        out.print("    <tr><th>Postal Code</th><td>"+rst.getString(9)+"</td></tr>");
        out.print("    <tr><th>Country</th><td>"+rst.getString(10)+"</td></tr>");
        out.print("    <tr><th>User id</th><td>"+userName+"</td></tr>");
        out.print("</tbody></table>");
    }

    rst.close();
} 
catch (SQLException ex) {
    out.println(ex);
}



// Make sure to close connection

%>
		</div>
</body>
</html>

