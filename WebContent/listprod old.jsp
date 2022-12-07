<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Bath Bombs Company Grocery</title>
<link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
	<%@ include file = "headerstyle.html" %>
	<%@ include file = "header.jsp" %>
	<div class="maincontent" align="center">
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";


// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00

try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
	String sql1 = "SELECT productId, productName, productPrice FROM product ";
	boolean hasProductName = name == null || name.equals("");
	PreparedStatement pstmt1 = null;
	ResultSet rst1 = null;
	if (!hasProductName){
		sql1 += " WHERE productName LIKE ?";
		pstmt1 = con.prepareStatement(sql1);
		pstmt1.setString(1,'%'+name+'%');	
		
	}else{
		pstmt1 = con.prepareStatement(sql1);
		
	} 
	
	rst1 = pstmt1.executeQuery();

	out.println("<h1>All products</h1>");
	out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	while (rst1.next())
	{

		String productId = rst1.getString(1);
		String productName = rst1.getString(2);
		double productPrice = rst1.getDouble(3);
		out.println("<tr><td><a href=\"addcart.jsp?id=" + productId + "&name=" + productName+ "&price=" + productPrice + "\">Add to Cart</a></td><td>"+productName+"</td><td>"+currFormat.format(productPrice)+"</td></tr>");
		//out.println("<tr><td><a href=\"addcart.jsp?id=" + productId + "&name=" +productName+ "&price=" + productPrice + "\">Add to Cart</a></td><td><a href=\"product.jsp?id=" + productId + "">"+productName+"</a></td><td>"+currFormat.format(productPrice)+"</td></tr>");
		
	}  
	out.println("</table>");
	rst1.close();
}
catch (SQLException ex)
{
	System.out.println("SQLException: " + ex);
}		

%>
</div>
</body>
</html>