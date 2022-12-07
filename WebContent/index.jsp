<!DOCTYPE html>
<html>
<head>
        <title>The Bath Bomb Company Main Page</title>
        <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
        <%@ include file = "headerstyle.html" %>
        <%@ include file = "header.jsp" %>
        <div class="maincontent" align="center">
<h1 align="center">Welcome to the Bath Bomb Company</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="makeAccount.jsp">Make Account</a></h2>

<h2 align="center"><a href="oftheweek.jsp">Bath Bomb of The Week!</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
// TODO: Display user name that is logged in (or nothing if not logged in)
	
        String userName = (String) session.getAttribute("authenticatedUser");
        if(userName == null)
                out.print("<h3></h3>"); 
        else
                out.print("<h3>Signed in as: "+userName+"</h3>");
	
%>
</div>
</body>
</head>


