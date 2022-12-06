<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	

	<title>THE B.B.CO'S Grocery Order List</title>
	<link rel="icon" type="image/x-icon" href="favicon.ico">
	<%@ include file = "headerstyle.html" %>
	<%@ include file = "header.jsp" %>
</head>
<body>

<div align="center">
	<div class="title">
		<h1>Order List</h1>
	</div>
<div class="firstTable">
<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	String sql1 = "SELECT OS.orderId, C.customerId, C.firstName, C.lastName, OS.totalAmount FROM customer C JOIN ordersummary OS ON C.customerId = OS.customerId";
	String sql2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
	
	PreparedStatement pstmt1 = con.prepareStatement(sql1);
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
		
	ResultSet rst1 = pstmt1.executeQuery();

	out.println("<table><thead><tr><th>Order Id&nbsp;&nbsp;&nbsp;</th><th>Customer Id&nbsp;&nbsp;&nbsp;</th><th>Customer Name&nbsp;&nbsp;&nbsp;</th><th>Total Amount</th></tr></thead><tbody>");
	while (rst1.next())
	{

		String orderId = rst1.getString(1);
		String customerId = rst1.getString(2);
		String customerName = rst1.getString(3) +" " +rst1.getString(4);
		double totalAmount = rst1.getDouble(5);
		
		//first query output
		out.println("<tr><td>" +orderId +"</td><td>" +customerId +"</td><td>" +customerName +"</td><td align=\"right\">" +currFormat.format(totalAmount) +"</td>");

		pstmt2.setString(1, orderId);
		ResultSet rst2 = pstmt2.executeQuery();

		//seconed query output
		out.println("<tr><td></td><td></td><td></td><td><table><tbody><tr><th>Product Id&nbsp;&nbsp;</th><th> Quantity&nbsp;&nbsp;</th><th> Price&nbsp;&nbsp;</th></tr>");
		while(rst2.next()){
			out.println("<tr><td>" +rst2.getString(1) +" </td><td>" +rst2.getString(2) +" </td><td>" +currFormat.format(rst2.getDouble(3)) +"</td></tr>");
		}
		out.println("</tbody></table></td></tr>");
		rst2.close();
	}  
	//out.println("</tbody></table>");
	rst1.close();
}
catch (SQLException ex)
{
	System.out.println("SQLException: " + ex);
}		
%>
</div>
</div>

</body>
</html>