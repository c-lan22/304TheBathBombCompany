<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
    <%@ include file = "headerstyle.html" %>
        <%@ include file = "header.jsp" %>
        <div class="maincontent" align="center">

<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%

// TODO: Write SQL query that prints out total order amount by day
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

out.println("<h1>Administrator Sales Report by Day</h1>");
out.print("<table border=\"1\"><tr><th>Order Date</th><th>Total Order Amount</th>");

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
        String sql = "SELECT date, SUM(totalAmount) FROM ordersummary OS JOIN (SELECT DISTINCT orderDate, CONVERT(DATE, orderDate, 120) AS date FROM ordersummary) D ON OS.orderDate = D.orderDate GROUP BY date";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rst = pstmt.executeQuery();
        while(rst.next()){
                out.print("<tr><td>"+rst.getString(1)+"</td>");
                out.print("<td>"+currFormat.format(rst.getDouble(2))+"</td></tr>");	
        }
                
        rst.close();
} 
catch (SQLException ex) {
        out.println(ex);
}

out.println("</table>");

out.println("<h1>Item inventory by store/warehouse</h1>");
out.print("<table border=\"1\"><tr><th>Item Number</th><th>Warehouse 1</th>");


try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
        String sql = "SELECT productid, quantity FROM productinventory ";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rst = pstmt.executeQuery();
        while(rst.next()){
                out.print("<tr><td>"+rst.getInt(1)+"</td>");
                out.print("<td>"+rst.getInt(2)+"</td></tr>");	
        }
                
        rst.close();
} 
catch (SQLException ex) {
        out.println(ex);
}

out.println("</table>");

%>
        </div>
</body>
</html>

