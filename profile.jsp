<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.entities.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page errorPage="error_page.jsp"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page import="com.tech.blog.dao.LikeDao"%>
<%
User user = (User) session.getAttribute("currentUser");
if (user == null) {
	response.sendRedirect("login_page.jsp");
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link rel="icon" href="images/logo.png" type="image/png">
<title><%=user.getName()%>'s Profile</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/profile.css">
  <style>
  .dropdown-toggle::after {
    display: none !important;
  }
   .dropdown-menu {
      right: 0;
      left: auto;
    }
</style>
</head>
<body>

	<!--NavBar  -->
	<jsp:include page="loggedin_navbar.jsp" />

	<!-- End of navbar -->
	<div class="container mt-5">
		<div class="row justify-content-center">
			<div id="profile-details" class="col-md-8">

				<div id="profile-details" class="card border-0 shadow-lg p-4">
					<div class="text-center">
						<img
							src="images/<%=user.getProfile()%>?t=<%=System.currentTimeMillis()%>"
							alt="Profile Picture" class="rounded-circle img-thumbnail mb-3"
							style="width: 120px; height: 120px; object-fit: cover;">


						<h3 class="text-dark"><%=user.getName()%></h3>
						<p class="text-muted">
							<i class="fa fa-envelope"></i>
							<%=user.getEmail()%></p>
					</div>

					<hr>

					<div class="row mb-3">
						<div class="col-md-6">
							<h6>
								<i class="fa fa-id-badge"></i> User ID
							</h6>
							<p><%=user.getId()%></p>
						</div>
						<div class="col-md-6">
							<h6>
								<i class="fa fa-venus-mars"></i> Gender
							</h6>
							<p><%=user.getGender() != null ? user.getGender() : "Not specified"%></p>
						</div>
						<div class="col-md-12">
							<h6>
								<i class="fa fa-info-circle"></i> About
							</h6>
							<p><%=user.getAbout() != null && !user.getAbout().trim().isEmpty() ? user.getAbout() : "No description provided."%></p>
						</div>
						<div class="col-md-12">
							<h6>
								<i class="fa fa-calendar"></i> Registered On
							</h6>
							<p><%=user.getTime() != null && !user.getTime().trim().isEmpty() ? user.getTime() : "No registration date."%></p>
						</div>
					</div>

					<div class="text-center">
						<a href="edit_profile.jsp" class="btn btn-warning"> <i
							class="fa fa-pencil"></i> Edit Profile
						</a>
					</div>
				</div>

			</div>
		</div>
	</div>
	<hr>
	<!-- Main body of the page -->
	<main>
		<div class="container">
			<div class="row mt-5">
				
				
				<!-- Second col -->
				<div class="col-md-12">
					<!-- Posts -->

					<div class="loader-wrapper text-center" id="loader">
						<div class="spinner"></div>
						<p class="mt-3" style="color: white;">Fetching awesome content
							for you...</p>
					</div>

					<div class="container-fluid" id="post-container"></div>

				</div>


			</div>


		</div>

	</main>


	<!--End of Main body of the page -->

	<!-- Bootstrap and jQuery JS -->

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

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"
		integrity="sha512-AA1Bzp5Q0K1KanKKmvN/4d3IRKVlv9PYgwFPvm32nPO6QS8yH1HO7LbgB1pgiOxPtfeg5zEn2ba64MUcqJx6CA=="
		crossorigin="anonymous" referrerpolicy="no-referrer"></script>



	<script src="js/myjs.js"></script>

	<script>
		$(document)
				.ready(
						function() {
							$("#add-post-form")
									.on(
											"submit",
											function(event) {
												event.preventDefault();
												var form1 = $('#add-post-form')[0];

												let form = new FormData(this);
												/* now requesting to server */
												console.log("submitted..");

												$
														.ajax({
															url : "AddPostServlet",
															type : 'POST',
															data : form,
															success : function(
																	data,
																	textStatus,
																	jqXHR) {
																if (data.trim() == 'done') {
																	$(
																			'#add-post-modal')
																			.modal(
																					'hide');
																	swal(
																			"Good job!",
																			"Post is Successfull !",
																			"success");
																} else {
																	swal(
																			"Error !",
																			"Something went wrong!",
																			"error");

																}

															},
															error : function(
																	jqXHR,
																	textStatus,
																	errorThrown) {
																swal(
																		"Error !",
																		"Something went wrong!",
																		"error");
															},
															processData : false,
															contentType : false
														})
											})
						});
	</script>

	<script>
		function getPost(catId, temp) {
			$("#loader").show();
			$("#post-container").hide();

			$(".c-link").removeClass('active');

			$.ajax({

				url : "load_post.jsp",
				data : {
					cid : catId
				},
				success : function(data, textStatus, jqXHR) {
					console.log(data);
					$("#loader").hide();
					$("#post-container").show();
					$("#post-container").html(data);
					$(temp).addClass('active');

				}
			})
		}
		$(document).ready(function() {
			let allPostRef = $('.c-link')[0];

			getPost(0, allPostRef);
		})
	</script>



</body>
</html>
