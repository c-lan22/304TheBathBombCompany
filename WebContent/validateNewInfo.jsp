<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	session = request.getSession(true);

	String itWorks = null;

	try
	{
		itWorks = validateNewInfo(out,request,session);
	}
	catch(Exception e)
	{	
		System.err.println(e);
	}

	if(itWorks != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("customer.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateNewInfo(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
        String username = (String) session.getAttribute("authenticatedUser");
		String password = request.getParameter("password");
		String firstname = request.getParameter("firstName");
		String lastname = request.getParameter("lastname");
		String email = request.getParameter("email");
		String phonenumber = request.getParameter("phonenum");
		String address = request.getParameter("address");
		String city = request.getParameter("city");
		String state = request.getParameter("state");
		String postalcode = request.getParameter("postcode");
		String country = request.getParameter("country");

		boolean valid = false;

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
					if( password.length() != 0)
					{
						
						String sql2 = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, password = ? WHERE userId = ?";
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
						pstmt2.setString(10, password);
						pstmt2.setString(11, username);

						pstmt2.executeUpdate();

						retStr = username;
						valid = true;
					}
					else
					{
						session.setAttribute("loginMessage","Please provide a password.");
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
				session.setAttribute("loginMessage",e);
				return null;
			}
		} 
		catch (SQLException ex) {
			session.setAttribute("loginMessage",ex);
			retStr = null;
		}

		if(valid == true)
		{	
			session.removeAttribute("loginMessage");
		}
		else
		{
            session.setAttribute("loginMessage","Could not save new information.");
			retStr = null;
        }
        return retStr;
	}
%>

