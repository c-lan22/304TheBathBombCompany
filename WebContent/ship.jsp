<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>the Bath Bomb Company Shipment Processing</title>
<link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
<%@ include file="header.jsp" %><%@ include file="headerstyle.html" %>
<div class="maincontent" align="center">

<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
boolean orderIdIsValid = false;
int warehouseNum = 1;

try ( Connection con = DriverManager.getConnection(url, uid, pw);){		
	
	//set warehouse num
	int warehouseId = 1;
	//Get order id
	String orderId = request.getParameter("orderId");
	// Check if valid order id
	String sql1 = "SELECT orderId FROM ordersummary WHERE orderId = ?";
	PreparedStatement pstmt1 = con.prepareStatement(sql1);
	pstmt1.setString(1, orderId);
	ResultSet rst1 = pstmt1.executeQuery();
	if(rst1.next()){
		if(rst1.getString(1) != null){
			orderIdIsValid = true;
			
		}
	}

	if(orderIdIsValid){
		boolean hasInventory = true;
		// Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);			// Set auto-commit to false so can support transactions

		
		// Retrieve all items in order with given id
		String sql2 = "SELECT quantity, productId FROM orderproduct WHERE orderId = ?";
		PreparedStatement pstmt2 = con.prepareStatement(sql2);
		pstmt2.setString(1, orderId);
		ResultSet rst2 = pstmt2.executeQuery();
		while(rst2.next()){
			int orderProductQuantity = rst2.getInt(1);
			int productId = rst2.getInt(2);
			
			
			// For each item verify sufficient quantity available in warehouse 1.
			String sql3 = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = ?";
			PreparedStatement pstmt3 = con.prepareStatement(sql3);
			pstmt3.setInt(1, productId );
			pstmt3.setInt(2, warehouseId );
			ResultSet rst3 = pstmt3.executeQuery();	
			if(rst3.next()){
				int warehouseProductQuantity = rst3.getInt(1);
				if(warehouseProductQuantity - orderProductQuantity < 0){
					out.print("<h1>Not enough inventory for product "+productId+" in warehouse "+warehouseNum+"</h1>");
					hasInventory = false;
					break;
				}else{
					out.println("<h2>Order product "+productId+" Qty :"+orderProductQuantity+" previous Inventory: "+warehouseProductQuantity+" current Inventory:"+(warehouseProductQuantity - orderProductQuantity)+"</h2>");
					String sql6 = "UPDATE productinventory SET quantity = ? WHERE productId = ? AND warehouseId = ?";
					PreparedStatement pstmt6 = con.prepareStatement(sql6);
					pstmt6.setInt(1, warehouseProductQuantity - orderProductQuantity);
					pstmt6.setInt(2, productId);
					pstmt6.setInt(3, warehouseId);
					pstmt6.executeUpdate();	
				}
			}else{
				out.print("<h1>Not enough inventory for product "+productId+" in warehouse "+warehouseNum+"</h1>");
				hasInventory = false;
			}
							
		}
		
		// If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		if(hasInventory){
			//Create a new shipment record.
			String sql5 = "INSERT INTO shipment (warehouseId) VALUES (?)";
			PreparedStatement pstmt5 = con.prepareStatement(sql5);
			pstmt5.setInt(1, warehouseId);
			pstmt5.executeUpdate();	
			out.println("<h1>shipment confirmed</h1>");
			
			con.commit();		// Commit this transaction
		}else{
			out.println("<h1>Not enough inventory in warehouse "+warehouseNum+" + shipment canceled</h1>");
		}
	// Auto-commit should be turned back on
	con.setAutoCommit(true);
	}else{
		out.println("<h1>OrderId is not valid</h1>");
	}

}catch (SQLException ex) {
	out.println("SQLException: " + ex); 
}

%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>
</div>
</body>
</html>
