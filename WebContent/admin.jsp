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

        <h2>Update Product by Id</h2>
        <form method="get" action="admin.jsp">
        <p>Product Id</p>
        <input type="number" name="productId" size="25">
        <p>New Product Name</p>
        <input type="text" name="productName" size="25">
        <p>New Product Price</p>
        <input type="text" name="productPrice" size="25">
        <input type="submit" value="Update">
        </form>
		
        <%
        String pId = request.getParameter("productId");
        String pName = request.getParameter("productName");
        String pPrice = request.getParameter("productPrice");
        
        try
        {
                int id = Integer.parseInt(pId);
                pPrice = Double.toString((double)Math.round(Double.parseDouble(pPrice) * 100) / 100);
                String sql4 =  "UPDATE product SET productName = ?, productPrice = ? WHERE productId = ?";
                PreparedStatement pstmt4 = con.prepareStatement(sql4);
                pstmt4.setString(1, pName);
                pstmt4.setString(2, pPrice);
                pstmt4.setInt(3, id);
                pstmt4.execute();
                out.println("<p>Product Successfully Updated</p>");
        }
        catch(Exception e)
        {
                out.println("<p>Please enter valid information</p>");
        }
        %>

        <h2>Delete Product by Id</h2>
        <form method="get" action="admin.jsp">
        <p>Product Id</p>
        <input type="number" name="productId" size="25">
        <input type="submit" value="Delete">
        </form>
		
        <%
        String prodId = request.getParameter("productId");
        
        try
        {
                int id = Integer.parseInt(prodId);
                String sql5 = "DELETE FROM product WHERE productId = ?";
                PreparedStatement pstmt5 = con.prepareStatement(sql5);
                pstmt5.setInt(1, id);
                pstmt5.execute();
                out.println("<p>Product Successfully Deleted</p>");
        }
        catch(Exception e)
        {
                out.println("<p>Please enter valid information</p>");
        }
        %>

        <h2>Add New Warehouse</h2>
        <form method="get" action="admin.jsp">
        <p>Warehouse Name</p>
        <input type="text" name="warehouseName" size="25">
        <input type="submit" value="Submit">
        </form>
        
        <%

        String warehouseName = request.getParameter("warehouseName");

        try
        {
                if(!warehouseName.equals("")){
                        String sql6 = "INSERT INTO warehouse(warehouseName) VALUES (?)";
                        PreparedStatement pstmt6 = con.prepareStatement(sql6);
                        pstmt6.setString(1, warehouseName);
                        pstmt6.execute();
                        out.println("<p>Warehouse Successfully Added</p>");
                }                
                else out.println("<p>Please enter valid information</p>");

        }
        catch(Exception e)
        {
                out.println("<p>Please enter valid information</p>");
        }

        %>

        <h2>Update Warehouse by Id</h2>
        <form method="get" action="admin.jsp">
        <p>Warehouse Id</p>
        <input type="number" name="warehouseId" size="25">
        <p>New Warehouse Name</p>
        <input type="text" name="warehouseName" size="25">
        <input type="submit" value="Update">
        </form>
		
        <%
        String wId = request.getParameter("warehouseId");
        String wName = request.getParameter("warehouseName");
        
        try
        {
                int id = Integer.parseInt(wId);
                String sql8 =  "UPDATE warehouse SET warehouseName = ? WHERE warehouseId = ?";
                PreparedStatement pstmt8 = con.prepareStatement(sql8);
                pstmt8.setString(1, wName);
                pstmt8.setInt(2, id);
                pstmt8.execute();
                out.println("<p>Warehouse Successfully Updated</p>");
        }
        catch(Exception e)
        {
                out.println("<p>Please enter valid information</p>");
        }
        %>

        <h2>Add New Customer</h2>
        <form method="get" action="admin.jsp">
        <p>First Name</p>
        <input type="text" name="firstName" size="25">
        <p>Last Name</p>
        <input type="text" name="lastName" size="25">
        <p>Email</p>
        <input type="text" name="email" size="25">
        <p>Phone</p>
        <input type="text" name="phonenum" size="25">
        <p>Address</p>
        <input type="text" name="address" size="25">
        <p>City</p>
        <input type="text" name="city" size="25">
        <p>State</p>
        <input type="text" name="state" size="25">
        <p>Postal Code</p>
        <input type="text" name="postalCode" size="25">
        <p>Country</p>
        <input type="text" name="country" size="25">
        <p>Username</p>
        <input type="text" name="userid" size="25">
        <p>Password</p>
        <input type="text" name="password" size="25">
        <input type="submit" value="Submit">
        </form>
        
        <%

        String cFirstName = request.getParameter("firstName");
        String cLastName = request.getParameter("lastName");
        String cEmail = request.getParameter("email");
        String cPhone = request.getParameter("phonenum");
        String cAddress = request.getParameter("address");
        String cCity = request.getParameter("city");
        String cState = request.getParameter("state");
        String cPostalCode = request.getParameter("postalCode");
        String cCountry = request.getParameter("country");
        String cUser = request.getParameter("userid");
        String cPass = request.getParameter("password");



        try
        {
                if(!cFirstName.equals("") && !cLastName.equals("") && !cEmail.equals("") && !cPhone.equals("") && !cAddress.equals("") && !cCity.equals("") && !cState.equals("") && !cPostalCode.equals("") && !cCountry.equals("")) 
                {
                        String sql7 = "INSERT INTO customer VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        PreparedStatement pstmt7 = con.prepareStatement(sql7);
                        pstmt7.setString(1, cFirstName);
                        pstmt7.setString(2, cLastName);
                        pstmt7.setString(3, cEmail);
                        pstmt7.setString(4, cPhone);
                        pstmt7.setString(5, cAddress);
                        pstmt7.setString(6, cCity);
                        pstmt7.setString(7, cState);
                        pstmt7.setString(8, cPostalCode);
                        pstmt7.setString(9, cCountry);
                        pstmt7.setString(10, cUser);
                        pstmt7.setString(11, cPass);
                        pstmt7.execute();
                        out.println("<p>Customer Successfully Added</p>");
                }
                else out.println("<p>Please enter valid information</p>");
        }
        catch(Exception e)
        {
                out.println("<p>Please enter valid information</p>");
        }
        %>

        <h2>Update Customer by Id</h2>
        <form method="get" action="admin.jsp">
        <p>Id</p>
        <input type="text" name="customerId" size="25">
        <p>New First Name</p>
        <input type="text" name="firstName" size="25">
        <p>New Last Name</p>
        <input type="text" name="lastName" size="25">
        <p>New Email</p>
        <input type="text" name="email" size="25">
        <p>New Phone</p>
        <input type="text" name="phonenum" size="25">
        <p>New Address</p>
        <input type="text" name="address" size="25">
        <p>New City</p>
        <input type="text" name="city" size="25">
        <p>New State</p>
        <input type="text" name="state" size="25">
        <p>New Postal Code</p>
        <input type="text" name="postalCode" size="25">
        <p>New Country</p>
        <input type="text" name="country" size="25">
        <p>New Username</p>
        <input type="text" name="userid" size="25">
        <p>New Password</p>
        <input type="text" name="password" size="25">
        <input type="submit" value="Update">
        </form>
		
        <%
        String custId = request.getParameter("customerId");
        String custFirstName = request.getParameter("firstName");
        String custLastName = request.getParameter("lastName");
        String custEmail = request.getParameter("email");
        String custPhone = request.getParameter("phonenum");
        String custAddress = request.getParameter("address");
        String custCity = request.getParameter("city");
        String custState = request.getParameter("state");
        String custPostalCode = request.getParameter("postalCode");
        String custCountry = request.getParameter("country");
        String custUser = request.getParameter("userid");
        String custPass = request.getParameter("password");
        
        try
        {
                int id = Integer.parseInt(custId);
                String sql9 =  "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, userid = ?, password = ? WHERE customerId = ?";
                PreparedStatement pstmt9 = con.prepareStatement(sql9);
                pstmt9.setString(1, custFirstName);
                pstmt9.setString(2, custLastName);
                pstmt9.setString(3, custEmail);
                pstmt9.setString(4, custPhone);
                pstmt9.setString(5, custAddress);
                pstmt9.setString(6, custCity);
                pstmt9.setString(7, custState);
                pstmt9.setString(8, custPostalCode);
                pstmt9.setString(9, custCountry);
                pstmt9.setString(10, custUser);
                pstmt9.setString(11, custPass);
                pstmt9.setInt(12, id);
                pstmt9.execute();
                out.println("<p>Customer Successfully Updated</p>");
        }
        catch(Exception e)
        {
                out.println("<p>Please enter valid information</p>");
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

