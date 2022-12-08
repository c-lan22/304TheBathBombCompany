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
    if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
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
    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city,state, postalCode, country, password FROM customer WHERE userid = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userName);
    ResultSet rst = pstmt.executeQuery();
    while(rst.next()){
        String fstname = rst.getString(2);
        out.print("<h3>Customer Profile</h3>");
        out.print("<form name=\"MyForm\" method=post action=\"validateNewInfo.jsp\">");
        out.print("<table border=\"1\">");
        out.print("    <tr><th>Account Id</th><td>"+rst.getString(1)+"</td></tr>");
        out.print("    <tr><th>First Name</th>");
        out.print("<td><input type=\"text\" name=\"firstName\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(2)+"\"> </td></tr>");
        out.print("    <tr><th>Last Name</th>");
        out.print("<td><input type=\"text\" name=\"lastname\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(3)+"\"> </td></tr>");
        out.print("    <tr><th>Email</th>");
        out.print("<td><input type=\"text\" name=\"email\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(4)+"\"> </td></tr>");
        out.print("    <tr><th>Phone</th>");
        out.print("<td><input type=\"text\" name=\"phonenum\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(5)+"\"> </td></tr>");
        out.print("    <tr><th>Address</th>");
        out.print("<td><input type=\"text\" name=\"address\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(6)+"\"> </td></tr>");
        out.print("    <tr><th>City</th>");
        out.print("<td><input type=\"text\" name=\"city\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(7)+"\"> </td></tr>");
        out.print("    <tr><th>State</th>");
        out.print("<td><input type=\"text\" name=\"state\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(8)+"\"> </td></tr>");
        out.print("    <tr><th>Postal Code</th>");
        out.print("<td><input type=\"text\" name=\"postcode\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(9)+"\"> </td></tr>");
        out.print("    <tr><th>Password</th>");
        out.print("<td><input type=\"text\" name=\"password\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(11)+"\"> </td></tr>");
        out.print("    <tr><th>Country</th>");
        out.print("<td><input type=\"text\" name=\"country\"  size=\"20\" maxlength=\"10\" value = \""+rst.getString(10)+"\"> </td></tr>");
        out.print("    <tr><th>User id</th><td>"+userName+"</td></tr>");
        out.print("</tbody></table>");
        out.print("<input class=\"submit\" type=\"submit\" name=\"Submit2\" value=\"Set new informaiton\">");
        out.print("</form>");


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

