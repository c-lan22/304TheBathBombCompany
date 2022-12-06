<!DOCTYPE html>
<html>
<head>
    <title>THE B.B.CO'S Grocery CheckOut Line</title>
    <link rel="icon" type="image/x-icon" href="favicon.ico">
    <%@ include file = "headerstyle.html" %>
	<%@ include file = "header.jsp" %>
</head>
<body>
<div class="maincontent" align="center">
<h1>Enter your customer id to complete the transaction:</h1>

<form method="get" action="order.jsp">
<input type="text" name="customerId" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</div>
</body>
</html>

