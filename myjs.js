function doLike(pid, uid) {
    console.log(pid, uid);

    const d = {
        uid: uid,
        pid: pid,
        operation: 'like'
    };

    const btnElement = event.currentTarget;
    $.ajax({
        url: 'LikeServlet',
        data: d,
        success: function(data, textStatus, jqXHR) {
            console.log(data);
            let counterElement = $(btnElement).find(".like-counter");
            let likeCount = parseInt(counterElement.html());
            if (data.trim() === 'true') {
                counterElement.html(likeCount + 1);
                $(btnElement).find("i").removeClass("fa-thumbs-o-up").addClass("fa-thumbs-up");
                $(btnElement).contents().filter(function () {
                    return this.nodeType === 3;
                }).first().replaceWith("Liked ");
            } else {
                
                counterElement.html(likeCount - 1);
                $(btnElement).find("i").removeClass("fa-thumbs-up").addClass("fa-thumbs-o-up");
                $(btnElement).contents().filter(function () {
                    return this.nodeType === 3;
                }).first().replaceWith("Like ");
            }

            $(btnElement).toggleClass("btn-primary btn-outline-primary");
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("Error in AJAX:", errorThrown);
        }
    });
	
	
	
	
	
}
function redirectToLogin() {
		if (confirm("You need to login to like this post. Do you want to login now?")) {
			window.location.href = "login_page.jsp";
		} 
		
		
		
}
