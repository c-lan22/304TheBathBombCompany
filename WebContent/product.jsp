<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>THE B.B.CO'S - Product Information</title>
<link rel="icon" type="image/x-icon" href="favicon.ico">
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file = "headerstyle.html" %>
    <%@ include file = "header.jsp" %>
    <div class="maincontent" align="center">

<%

out.println("<h1>B.B.CO's bombs</h1>");

// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try 
(Connection con=DriverManager.getConnection(url, uid, pw);
Statement stmt = con.createStatement(); )
{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String sql = "SELECT * FROM product WHERE productId = ?";
    PreparedStatement pstmt1 = con.prepareStatement(sql);
    pstmt1.setString(1, productId);

    ResultSet rst1 = pstmt1.executeQuery();
    if(rst1.next()){
        String picUrl = rst1.getString(4);
        String productName = rst1.getString(2);
        double productPrice = rst1.getDouble(3);

        if (picUrl != null){
            if (picUrl.equals("img/1.jpg")){
                out.println("<img src=\"img/1_a.jpg"+"\">");
            }
            out.print("<img src=\"");
            out.print(picUrl);
            out.print("\"");
            out.print(">");
        }
        //attempt to use image doesn't show
        //correct output and path can be acessed throu source code when inspecting page
        //out.println("<img src=\"displayImage.jsp?id=1"+"\">");
        out.println("<h2>"+productName+"</h2>");
        
        out.println("<table><tbody><tr><th>ID </th><td>"+productId+"</td></tr><tr><th>Price</th><td>"+currFormat.format(productPrice)+"</td></tr></tbody>");
        
        out.println("</table>");
        
        out.println("<h3><a href=\"addcart.jsp?id=" + productId + "&name=" +productName+ "&price=" + productPrice + "\">Add to Cart</a></h3>");
      
        /* 
        * the start of the reviews
        */
  
    }
    
    
    
    /* 
    * Add the review
    *
    */
    try {
    String reviewComment = request.getParameter("reviewComment");
    int rating = Integer.parseInt(request.getParameter("rating"));
        if(reviewComment.equals(null)){
            String sql2 = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?,?,?,?,?)";
            PreparedStatement pstmt2 = con.prepareStatement(sql2);
            pstmt2.setInt(1, rating);
            pstmt2.setString(2, null); //needs
            pstmt2.setInt(3, 1);    //needs
            pstmt2.setString(4, productId);
            pstmt2.setString(5, reviewComment);
            pstmt2.executeUpdate();
            out.print("<p>created review </p>");
        }
    } catch (NullPointerException e) {} catch (NumberFormatException w) {}
        
    /* 
    * query the reviews and print 
    */
    try {
        
        String sql43 = "SELECT * FROM review WHERE productId = ?";
        PreparedStatement pstmt43 = con.prepareStatement(sql43);
        pstmt43.setString(1, productId);
        ResultSet rst43 = pstmt43.executeQuery();
        out.print("<h2>Reviews By Customers:</h2>");
        if(rst43.next()){
            String reviewId     = rst43.getString(4);
            String reviewRating = rst43.getString(4);
            String reviewDate   = rst43.getString(4);
            String customerId   = rst43.getString(4);
            String productId23    = rst43.getString(4);
            String reviewComment1 = rst43.getString(4);
            
            out.print("<h3>Customer Id:"+customerId+" Date:"+reviewDate+" Review Rating:"+reviewRating+"</h3>");
            out.print("<textarea readonly rows=\"4\" cols=\"50\">"+reviewComment1+"</textarea>");
            
        }  
    } catch (NullPointerException e) {} catch (NumberFormatException w) {}
    
    /* 
    * print add my review
    */
    out.print(" <h2>Add my Review:</h2> "
    +"<form method=\"post\" action=\"product.jsp\">"
    +"<p>Rating</p><input type=\"number\" name=\"rating\" size=\"1\" min=\"1\" max=\"5\">"
    +"<p>Comment</p><textarea id=\"review\" name=\"reviewComment\" rows=\"4\" cols=\"50\"> </textarea>" 
    +"<input hidden type=\"number\" name=\"id\"value=\""+productId+"\">"
    +"<p>Submit Review</p><p><input type=\"submit\" value=\"Submit\"></p>"
    +"</form");
    
    
          
    out.println("<h3><a href=\"listprod.jsp?id= \">Continue Shopping</a></h3>");    
    
}
catch (SQLException ex)
{
	out.println("SQLException: " + ex);
}	
catch (Exception e){
    out.println("error" + e);
}


// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>

