<%@page import="com.tech.blog.dao.UserDao"%>
<%@page import="com.tech.blog.dao.LikeDao"%>
<%@page import="com.tech.blog.entities.Posts"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
User user = (User) session.getAttribute("currentUser");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="images/logo.png" type="image/png">
<title>StackFlux Official</title>
<!-- CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/index.css">
</head>

<body>

	<!-- Navbar -->
	 <%
	if (user == null) {
	%>
	<jsp:include page="normal_navbar.jsp" />
	<%
	} else {
	%>
	<jsp:include page="loggedin_navbar.jsp" />
	<%
	}
	%>

	<!-- Banner -->
	<div class="container-fluid p-0 m-0">
		<div class="jumbotron banner-background">
			<div class="container">
				<h3 class="display-3">Welcome to StackFlux</h3>
				<p>
				Computer programming or coding is the composition of sequences of
				instructions, called programs, that computers can follow to perform
				tasks.[1][2] It involves designing and implementing algorithms,
				step-by-step specifications of procedures, by writing code in one or
				more programming languages. Programmers typically use high-level
				programming languages that are more easily intelligible to humans
				than machine code, which is directly executed by the central
				processing unit. Proficient programming usually requires expertise
				in several different subjects, including knowledge of the
				application domain, details of programming languages and generic
				code libraries, specialized algorithms, and formal logic.
                 </p>
				<%
				if (user == null) {
				%>
				<a href="register_page.jsp" class="btn btn-outline-primary"> <span
					class="fa fa-user-plus"></span> Start Coding..
				</a> <a href="login_page.jsp" class="btn btn-outline-primary"> <span
					class="fa fa-user-circle-o"></span> Log in
				</a>
				<%
				}
				%>
			</div>
		</div>
	</div>

	<!-- Cards -->
	<div class="container">
		<div class="row mb-2">
			<%
			PostDao d = new PostDao(ConnectionProvider.getConnection());
			ArrayList<Posts> posts = d.getAllPosts();

			for (Posts p : posts) {
				UserDao ud = new UserDao(ConnectionProvider.getConnection());
				User u = ud.getUserByUserId(p.getUserID());
			%>

			<div class="col-md-4">
				<div class="card">
					<div class="d-flex align-items-center p-3 border-bottom">
						<a href="visit_profile.jsp?user_id=<%=u.getId() %>"> <img
							src="images/<%=u.getProfile()%>?t=<%=System.currentTimeMillis()%>"
							alt="Profile Picture" class="rounded-circle img-thumbnail mr-3"
							style="width: 60px; height: 60px; object-fit: cover;">
						</a>
						<div>
							<p class="mb-1">
								<strong> <a href="visit_profile.jsp?user_id=<%=u.getId() %>"
									style="color: black; text-decoration: none;"><%=u.getName()%></a>
								</strong>
							</p>
							<p class="mb-0 text-muted" style="font-size: 0.85rem;">
								Posted on:
								<strong><%=p.getpDate()%></strong>
								
							</p>
						</div>
					</div>

					<img class="card-img-top" src="blog_pics/<%=p.getpPic()%>"
						alt="Post Image">

					<div class="card-body">
						<b><%=p.getpTitle()%></b>
						<p><%=p.getpContent()%></p>
					</div>

					<div class="card-footer text-center">
						<%
						LikeDao ld = new LikeDao(ConnectionProvider.getConnection());
						int count = ld.likeCountByPid(p.getPid());
						boolean isLiked = false;
						int userId = -1;

						if (user != null) {
							userId = user.getId();
							isLiked = ld.isLikedByUser(p.getPid(), userId);
						}
						%>
						
						
                       
						<a <%if (user != null) {%>
							onclick="doLike(<%=p.getPid()%>, <%=userId%>)" <%} else {%>
							
							onclick="redirectToLogin()" <%}%>
							class="btn btn-sm <%=isLiked ? "btn-primary" : "btn-outline-primary"%>">
							<i class="fa <%=isLiked ? "fa-thumbs-up" : "fa-thumbs-o-up"%>"></i>
							<%=isLiked ? "Liked " : "Like "%> <span class="like-counter"><%=count%></span>
						</a> 
						
					
						
						 <a href="#" class="btn btn-outline-primary btn-sm"> <i
							class="fa fa-commenting-o"> <span>10</span></i>
						</a> <a href="show_blog_page.jsp?post_id=<%=p.getPid()%>"
							class="btn btn-outline-primary btn-sm">Read More...</a>
					</div>
				</div>
				<br>
			</div>

			<%
			}
			%>
		</div>
	</div>
 
	<!-- JavaScript -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"
		integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js"
		integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"
		integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
		crossorigin="anonymous"></script>

	<script src="js/myjs.js"></script>

	<!-- Login Redirect Function -->
	

</body>
</html>
