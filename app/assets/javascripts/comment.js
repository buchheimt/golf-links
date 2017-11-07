$(function() {
  $("#toggleComments").click(toggleComments);
  $("#new_comment").submit(createComment);
  $("#commentForm").fadeOut();
});

const createComment = (e) => {
  e.preventDefault();
  const templateSource = $("#comment-template").html();
  const template = Handlebars.compile(templateSource);
  const values = $(e.target).serialize();
  $.post("/comments", values, function(comment) {
    const newComment = template(comment);
    $("#comments").append(newComment);
    $(".comment-content").last().fadeIn();
    if (comment.user.get_image !== "user-default.jpg") {
      $("#comments img").last().attr("src", comment.user.get_image);
    }

    $("#addCommentBtn").removeAttr("data-disable-with");
    $("#addCommentBtn").removeAttr("disabled");
    $("#comment_content").val("");
  });
}

const toggleComments = () => {
  if ($("#toggleComments").text() === "Show Comments") {
    $("#commentForm").fadeIn();
    if ($("#comments div").length > 0) {
      $("#comments div").fadeIn();
    } else {
      const teeTimeId = $("#toggleComments").data("id").toString();
      const templateSource = $("#comment-template").html();
      const template = Handlebars.compile(templateSource);
      $.get("/comments", {id: teeTimeId}, function(comments) {
        console.log(comments);
        comments.forEach(function(comment) {
          const commentDiv = template(comment);
          $("#comments").append(commentDiv);
          $(".comment-content").last().fadeIn();

          if (comment.user.get_image !== "user-default.jpg") {
            $("#comments img").last().attr("src", comment.user.get_image);
          }
        });
      });
    }
    $("#toggleComments").text("Hide Comments");
  } else {
    $("#commentForm").fadeOut();
    $("#comments div").fadeOut();
    $("#toggleComments").text("Show Comments");
  }
}
