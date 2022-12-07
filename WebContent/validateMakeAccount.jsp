<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateMakeAccount(out,request,session);
	}
	catch(Exception e)
	{	
		System.err.println(e);
	}

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

		boolean userAlreadyExists = false;
		String retStr = null;
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";

		try 
		(Connection con=DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement(); )
		{
			try
			{
				if(!firstname.equals("") && !lastname.equals("") && !email.equals("") && !phonenumber.equals("") && !address.equals("") && !city.equals("") && !state.equals("") && !postalcode.equals("") && !country.equals("")) //change to eunsure everything is filled in
				{
					if(username.length() != 0 && password.length() != 0)
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
								userAlreadyExists = true;
							}
						}

					
						String sql2 = "INSERT INTO customer VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
						PreparedStatement pstmt2 = con.prepareStatement(sql2);
						pstmt2.setString(1, firstname);
						pstmt2.setString(2, lastname);
						pstmt2.setString(3, email);
						pstmt2.setString(4, phonenumber);
						pstmt2.setString(5, address);
						pstmt2.setString(6, city);
						pstmt2.setString(7, state);
						pstmt2.setString(8, postalcode);
						pstmt2.setString(9, country);
						pstmt2.setString(10, username);
						pstmt2.setString(11, password);

						pstmt2.executeUpdate();

						retStr = username;
					}
					else
					{
						session.setAttribute("loginMessage","Please fill in all the input fields.");
						return null;
					}
				}
				else
				{
					session.setAttribute("loginMessage","Please fill in all the input fields.");
					return null;
				}
			}
			catch(Exception e){
				session.setAttribute("loginMessage","Please fill in all the input fields.");
				return null;
			}
		} 
		catch (SQLException ex) {
			session.setAttribute("loginMessage",ex);
			retStr = null;
		}

		if(!userAlreadyExists)
		{	
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
		{
            session.setAttribute("loginMessage","There is an account with that username already.");
			retStr = null;
        }
        return retStr;
	}
%>

