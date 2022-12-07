
<ul class="inliner">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="listorder.jsp">List Orders</a></li>
    <li><a href="listprod.jsp">List Products</a></li>
    <li><a href="showcart.jsp">Show Cart</a></li>
    <li><a href="checkout.jsp">Checkout</a></li>
    <% 
    String userName1 = (String) session.getAttribute("authenticatedUser");
    try{
        if(userName1.equals(null)){
            out.println("<li class=\"split\"><a href=\"login.jsp\">Login</a></li>");
        }else{
            out.println("<li class=\"split\"><a href=\"logout.jsp\">Logout</a></li>");
            out.println("<li class=\"split\"><a href=\"customer.jsp\">Account Info</a></li>");
            out.println("<li class=\"split\"><a href=\"admin.jsp\">Admin</a></li>");
            out.println("<li  class=\"user\">"+userName1+"</li>");
        }
    }catch(NullPointerException e){
        out.println("<li class=\"split\"><a href=\"login.jsp\">Login</a></li>");
        out.println("<li class=\"split\"><a href=\"makeAccount.jsp\">Create Account</a></li>");
    }
    %>
    

</ul>
<!-- <div class="topnav">
    <a href="index.jsp">Home</a>       
    <a href="listorder.jsp">List Orders</a>
    <a href="listprod.jsp">List Products</a>
    <a href="showcart.jsp">Show Cart</a>
    <a href="checkout.jsp">Checkout</a>
    <a href="logout.jsp">logout</a>
    <a href="admin.jsp">Admin</a>
    <a class="split" href="login.jsp">Login</a>
</div> -->
