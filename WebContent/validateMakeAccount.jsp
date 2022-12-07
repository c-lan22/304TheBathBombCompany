<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateMakeAccount(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("makeAccount.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateMakeAccount(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("userid");
		String password = request.getParameter("password");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String email = request.getParameter("email");
		String phonenumber = request.getParameter("phonenumber");
		String address = request.getParameter("address");
		String city = request.getParameter("city");
		String state = request.getParameter("state");
		String postalcode = request.getParameter("postalcode");
		String country = request.getParameter("country");

		boolean makeAcc = true;

		String retStr = null;
		boolean isAccount = false;

		if(username == null || password == null || firstname == null || lastname == null ||email == null || phonenumber == null || address == null ||city == null || state == null ||postalcode == null || country == null) //change to eunsure everything is filled in
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try 
		(Connection con=DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement(); )
		{
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String tempUser = "";
			String tempPassword = "";
			String sql = "SELECT userid, password FROM customer";
			PreparedStatement pstmt = con.prepareStatement(sql);
			//pstmt.setString(1, username);
			//pstmt.setString(2, password);
			ResultSet rst = pstmt.executeQuery();
			while(rst.next()){
				tempUser = rst.getString(1);
				tempPassword = rst.getString(2);
				if(tempUser.equals(username) && tempPassword.equals(password)){
					retStr = null;
					makeAcc = false;
				}
			}

			if(makeAcc == true){
				String sql2 = "INSERT INTO customer VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement pstmt2 = con.prepareStatement(sql2);
				pstmt.setString(1, firstname);
				pstmt.setString(2, lastname);
				pstmt.setString(3, email);
				pstmt.setString(4, phonenumber);
				pstmt.setString(5, address);
				pstmt.setString(6, city);
				pstmt.setString(7, state);
				pstmt.setString(8, postalcode);
				pstmt.setString(9, country);
				pstmt.setString(10, username);
				pstmt.setString(11, password);

				pstmt.executeUpdate();

				retStr = username;

			}

				
			rst.close();
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else{
            session.setAttribute("loginMessage","There is an account with that username already.");
        }
        return retStr;
	}
%>

