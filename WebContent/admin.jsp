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

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
        out.println("<h2>Administrator Sales Report by Day</h2>");
        out.print("<table border=\"1\"><tr><th>Order Date</th><th>Total Order Amount</th>");
        String sql1 = "SELECT date, SUM(totalAmount) FROM ordersummary OS JOIN (SELECT DISTINCT orderDate, CONVERT(DATE, orderDate, 120) AS date FROM ordersummary) D ON OS.orderDate = D.orderDate GROUP BY date";
        PreparedStatement pstmt1 = con.prepareStatement(sql1);
        ResultSet rst1 = pstmt1.executeQuery();
        while(rst1.next()){
                out.print("<tr><td>"+rst1.getString(1)+"</td>");
                out.print("<td>"+currFormat.format(rst1.getDouble(2))+"</td></tr>");	
        }
        out.println("</table>");
            
        out.println("<h2>Customer List</h2>");
        out.print("<table border=\"1\"><tr><th>Id</th><th>Name</th>");
        String sql2 = "SELECT customerId, firstName, lastName FROM customer";
        PreparedStatement pstmt2 = con.prepareStatement(sql2);
        ResultSet rst2 = pstmt2.executeQuery();
        while(rst2.next()){
                out.print("<tr><td>"+rst2.getString(1)+"</td>");
                out.print("<td>"+rst2.getString(2)+" "+rst2.getString(3)+"</td></tr>");	
        }
        out.println("</table>");
        %>
        
        <h2>Add New Product</h2>
        <form method="get" action="admin.jsp">
        <p>Product Name</p>
        <input type="text" name="productName" size="25">
        <p>Product Price</p>
        <input type="text" name="productPrice" size="25">
        <p>Submit Product</p>
        <input type="submit" value="Submit">
        </form>
        
        <%

        String prodName = request.getParameter("productName");
        String prodPrice = request.getParameter("productPrice");
        boolean allowInsert = true;
        double price = 0;
        
        try
        {
                if(prodName.length() > 40)
                {
                        allowInsert = false;
                        out.println("<p>Error. Product Name cannot be greater than 40 characters</p>");
                }

                try
                {
                        price = (double)Math.round(Double.parseDouble(prodPrice) * 100) / 100;
                       
                        if(price <= 0)
                        {
                                allowInsert = false;
                                out.println("<p>Error. Product Price must be more than 0</p>");
                        }
                }
                catch(Exception e)
                {
                        allowInsert = false;
                        out.println("<p>Error. Product Price must be a number</p>");
                }
        }
        catch(Exception e)
        {
                allowInsert = false;
                out.println("<p>Please fill out all input fields before you submit</p>");
        }
        finally
        {
                if(allowInsert)
                {
                        out.println("<p>Product Successfully Added</p>");
                        String sql3 = "INSERT INTO product (productName, productPrice) VALUES (?, ?)";
                        PreparedStatement pstmt3 = con.prepareStatement(sql3);
                        pstmt3.setString(1, prodName);
                        pstmt3.setString(2, prodPrice);
                        pstmt3.execute();
                }
        }

        %>

        <h2>Delete Product by Id</h2>
        <form method="get" action="admin.jsp">
        <p>Product Id</p>
        <input type="text" name="productId" size="25">
        <p>Submit Product</p>
        <input type="submit" value="Delete">
        </form>
		
        <%
        String prodId = request.getParameter("productId");
        
        try
        {
                int id = Integer.parseInt(prodId);
                String sql4 = "DELETE FROM product WHERE productId = ?";
                PreparedStatement pstmt4 = con.prepareStatement(sql4);
                pstmt4.setInt(1, id);
                pstmt4.execute();
                out.println("<p>Product Successfully Deleted</p>");
        }
        catch(Exception e)
        {
                out.println("<p>Please enter a valid Product Id</p>");
        }
        
        
} 
catch (SQLException ex) {
        out.println(ex);
}
out.println("</table>");

%>
<h2>Change Inventory</h2>
<form method="post" action="admin.jsp">
<p>Product Id</p>
<input type="number" name="productIdInv" size="5">
<p>Warehouse Id</p>
<input type="number" name="warehouseId" size="5">
<p>New Quantity</p>
<input type="number" name="quantity" size="5">
<p>Submit Inventory Change</p>
<input type="submit" value="Submit">
</form>
<%
//edit inventory
String prodIdInv = request.getParameter("productIdInv");
String warehouseId = request.getParameter("warehouseId");
String quantity = request.getParameter("quantity");
try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
	if(!prodIdInv.equals(null)&&!quantity.equals(null)&&!warehouseId.equals(null)){	
		String sql = "Update productinventory SET quantity = ? WHERE productid = ? AND warehouseId = ? ";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, quantity);
		pstmt.setString(2, prodIdInv);
		pstmt.setString(3, warehouseId);
		pstmt.executeUpdate();
		out.print("<p>Updated product "+prodIdInv+" in warehouse "+warehouseId+" to "+quantity+" units</p>");
	}
	//display inventory
	out.println("<h1>Item inventory by store/warehouse</h1>");
	out.print("<table border=\"1\"><tr><th>Item Number</th><th>Warehouse 1</th>");

	String sql = "SELECT productid, quantity FROM productinventory ";
	PreparedStatement pstmt = con.prepareStatement(sql);
	ResultSet rst = pstmt.executeQuery();
	while(rst.next()){
			out.print("<tr><td>"+rst.getInt(1)+"</td>");
			out.print("<td>"+rst.getInt(2)+"</td></tr>");	
	}
} 
catch (SQLException ex) {
		out.println(ex);
}
catch (NullPointerException ex) {
}
%>
        </div>
</body>
</html>

