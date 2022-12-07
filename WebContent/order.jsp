<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
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
    <%@ include file = "cartpagestyle.html" %>
    <div class="maincontent" align="center">
<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


// If either are not true, display an error message

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
int orderId34 = 0;
try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
    try{
        // Determine if valid customer id was entered
        boolean idIsValid = false ;
        int custIdInt = Integer.parseInt(custId);
        String sql1 = "SELECT customerId, firstName, lastName FROM customer WHERE customerId = ?";
        PreparedStatement pstmt1 = con.prepareStatement(sql1);
        pstmt1.setInt(1, custIdInt);
        ResultSet rst1 = pstmt1.executeQuery();
        if(rst1.next()){

        	if(rst1.getString(1) != null){
            idIsValid = true;
        	}

        	if(!idIsValid){
            out.println("<h1>customer Id is wrong</h1>");
       		}if(idIsValid){ 
                if (productList == null){ // Determine if there are products in the shopping cart
                    out.println("<H1>Your shopping cart is empty!</H1>");
                }else{ 

                    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                    out.println("<h1>Your Order Summary</h1>");
                    out.println("<table><tr><th>Product id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>subtotal</th></tr>");
                    
                    // Print out order summary

                    double total =0;
                    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                    while (iterator.hasNext()) 
                    {	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                        if (product.size() < 4)
                        {
                            out.println("Expected product with four entries. Got: "+product);
                            continue;
                        }
                        
                        out.print("<tr><td>"+product.get(0)+"</td>");
                        out.print("<td>"+product.get(1)+"</td>");

                        out.print("<td align=\"center\">"+product.get(3)+"</td>");
                        Object price = product.get(2);
                        Object itemqty = product.get(3);
                        double pr = 0;
                        int qty = 0;
                        
                        try
                        {
                            pr = Double.parseDouble(price.toString());
                        }
                        catch (Exception e)
                        {
                            out.println("Invalid price for product: "+product.get(0)+" price: "+price);
                        }
                        try
                        {
                            qty = Integer.parseInt(itemqty.toString());
                        }
                        catch (Exception e)
                        {
                            out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
                        }		

                        out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
                        out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
                        out.println("</tr>");
                        total = total +pr*qty;
                    }
                    out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                        +"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
                    out.println("</table>");
                    
                    // Save order information to database

                    String sql2 = "INSERT INTO ordersummary(customerId) VALUES ("+custId+")";
						PreparedStatement pstmt2 = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
						pstmt2.executeUpdate();
						ResultSet keys = pstmt2.getGeneratedKeys();
						keys.next();
						int orderId = keys.getInt(1);
                        orderId34 = orderId;
    
                    out.println("<h1>Order completed. Will be shipped soon...</h1>");
                    out.println("<h1>Your order reference number is: "+orderId+" </h1>");
                    // Insert each item into OrderProduct table using OrderId from previous INSERT
                    try{
                        Iterator<Map.Entry<String, ArrayList<Object>>> iterator1 = productList.entrySet().iterator();
                        while (iterator1.hasNext())
                        { 
                            Map.Entry<String, ArrayList<Object>> entry = iterator1.next();
                            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                            String productId = (String) product.get(0);
                            String price = (String) product.get(2);
                            double pr = Double.parseDouble(price);
                            int qty = ( (Integer)product.get(3)).intValue();

                            String sql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)";
                            PreparedStatement pstmt = con.prepareStatement(sql);
                            pstmt.setInt(1, orderId);
                            pstmt.setString(2, productId);
                            pstmt.setInt(3, qty);
                            pstmt.setDouble(4, pr);
                            pstmt.executeUpdate();
                            
                            // Update total amount for order record

                            double totalPrice = 0;
                            String sql3 = "SELECT quantity, price FROM orderproduct WHERE orderId = " +orderId;
                            PreparedStatement pstmt3 = con.prepareStatement(sql3);
                            ResultSet rst3 = pstmt3.executeQuery();
                            while(rst3.next()){
                                totalPrice += rst3.getInt(1) * rst3.getDouble(2);
                            }
                            String sql4 = "UPDATE ordersummary SET totalAmount = " +totalPrice+" WHERE orderId = " +orderId;
                            PreparedStatement pstmt4 = con.prepareStatement(sql4);
                            pstmt4.executeUpdate();
                            }
                    }catch(NumberFormatException e){
                        out.println("Product list is empty");
                    }
    
    
                    out.println("<h1>Shipping to customer: "+custIdInt+" Name:"+rst1.getString(2)+" "+rst1.getString(3)+" </h1>");
                    // Clear cart if order placed successfully
                    session.setAttribute("productList", null);
                    

                }
			}
        }else out.println("<h1>Customer ID is not valid</h1>");
    }catch(NumberFormatException e){
        out.println("<h1>Customer ID is not a number<h1>");
    }
}
%>
<h2><a href=\shop\ship.jsp?orderId=<%= orderId34 %>>Ship Order <%= orderId34 %></a></h2>
<%


/*
// Use retrieval of auto-generated keys.
PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
ResultSet keys = pstmt.getGeneratedKeys();
keys.next();
int orderId = keys.getInt(1);
*/


// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/


%>
</div>
</BODY>
</HTML>