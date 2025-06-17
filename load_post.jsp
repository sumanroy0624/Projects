
<%@page import="com.tech.blog.dao.UserDao"%>
<%@page import="com.tech.blog.entities.User"%>
<%@page import="com.tech.blog.entities.Posts"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tech.blog.helper.ConnectionProvider"%>
<%@page import="com.tech.blog.dao.PostDao"%>
<%@page import="com.tech.blog.dao.LikeDao"%>

<div class="row">

	<%
	User user = (User) session.getAttribute("currentUser");

	PostDao dao = new PostDao(ConnectionProvider.getConnection());
	int cid = Integer.parseInt(request.getParameter("cid"));
	ArrayList<Posts> list = dao.getPostsByUserId(user.getId());

	if (list.size() == 0) {
		out.println("<h6 class='display-3 text-center text-white;'> No Post Yet !. </h6>");
		return;
	}

	for (Posts p : list) {
		UserDao ud = new UserDao(ConnectionProvider.getConnection());
		User u = ud.getUserByUserId(p.getUserID());
	%>

	<div id="<%="post-" + p.getPid()%>" class="col-md-4">



		<div class="card">
			<div class="d-flex align-items-center p-3 border-bottom">
				<a href="visit_profile.jsp?user_id=<%=u.getId()%>"> <img
					src="images/<%=u.getProfile()%>?t=<%=System.currentTimeMillis()%>"
					alt="Profile Picture" class="rounded-circle img-thumbnail mr-3"
					style="width: 60px; height: 60px; object-fit: cover;">
				</a>
				<div>
					<p class="mb-1">
						<strong> <a
							href="visit_profile.jsp?user_id=<%=u.getId()%>"
							style="color: black; text-decoration: none;"><%=u.getName()%></a>
						</strong>
					</p>
					<p class="mb-0 text-muted" style="font-size: 0.85rem;">
						Posted on: <strong><%=p.getpDate()%></strong>

					</p>
				</div>

				<div class="btn-group">
					<button type="button" class="btn  dropdown-toggle"
						data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span class="fa fa-list-ul"></span>

					</button>
					<div class="dropdown-menu dropdown-menu-right">
						<a class="dropdown-item" onclick="Edit_Post()"> <span
							class="fa fa-pencil-square-o"></span> Edit Post
						</a> <a onclick="deletePost(<%=p.getPid()%>)" class="dropdown-item">
							<span class="fa fa-trash-o"></span> Delete Post
						</a> <a class="dropdown-item"> <span class="fa fa-times-circle-o"></span>
							Not Interested
						</a> <a class="dropdown-item"> <span class="fa fa-save"></span>
							Save Post
						</a>

					</div>


					<!-- Modal -->


				</div>


			</div>

			<img class="card-img-top" src="blog_pics/<%=p.getpPic()%>"
				alt="Card image cap">
			<div class="card-body">

				<b> <%=p.getpTitle()%>
				</b>
				<p>
					<%=p.getpContent()%>
				</p>


			</div>

			<div class="card-footer text-center">

				<%
				LikeDao ld = new LikeDao(ConnectionProvider.getConnection());
				int count = ld.likeCountByPid(p.getPid());
				boolean isLiked = ld.isLikedByUser(p.getPid(), user.getId());
				%>


				<a id="<%="like-btn-" + p.getPid()%>" <%if (user != null) {%>
					onclick="doLike(<%=p.getPid()%>, <%=user.getId()%>)" <%} else {%>
					onclick="redirectToLogin()" <%}%>
					class="btn btn-sm <%=isLiked ? "btn-primary" : "btn-outline-primary"%>">

					<i id="<%="icon-" + p.getPid()%>"
					class="fa <%=isLiked ? "fa-thumbs-up" : "fa-thumbs-o-up"%>"></i> <span
					id="<%="showLiked-" + p.getPid()%>"> <%=isLiked ? "Liked " : "Like "%>
				</span> <span class="<%="like-counter-" + p.getPid()%>"> <%=count%>
				</span>
				</a> <a href="" class="btn btn-outline-primary btn-sm"> <i
					class="fa fa-commenting-o"> <span>10</span>
				</i>

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

