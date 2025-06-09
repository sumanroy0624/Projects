async function doLike(pid, uid, isLiked, btnElement) {
    if (!btnElement) {
        console.error("Button element not passed");
        return;
    }

    let url = `LikeServlet?uid=${uid}&pid=${pid}&operation=${isLiked ? 'unlike' : 'like'}`;

    try {
        const response = await fetch(url);
        const data = await response.text(); // "true" or "false"

        
        const likeCounter = btnElement.querySelector(".like-counter");

        if (data === "true") {
            /*icon.className = "fa fa-thumbs-up";*/
            btnElement.className = "btn btn-sm btn-primary";

            if (likeCounter) {
                likeCounter.textContent = parseInt(likeCounter.textContent) + 1;
            }
        } else {
           /* icon.className = "fa fa-thumbs-o-up";*/
            btnElement.className = "btn btn-sm btn-outline-primary";

            if (likeCounter) {
                likeCounter.textContent = parseInt(likeCounter.textContent) - 1;
            }
        }

    } catch (error) {
        console.error("Fetch error:", error);
    }
}
