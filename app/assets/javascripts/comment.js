$(function() {
  $("#toggleComments").click(toggleComments);
  $("#new_comment").submit(createComment);
  $("#commentForm").hide();
});

const createComment = (e) => {
  e.preventDefault();
  const templateSource = $("#comment-template").html();
  const template = Handlebars.compile(templateSource);
  const values = $(e.target).serialize();
  $.post("/comments", values, function(comment) {
    const newComment = template(comment);
    $("#comments").append(newComment);

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
    $("#commentForm").show();
    if ($("#comments div").length > 0) {
      $("#comments div").show();
    } else {
      const teeTimeId = $("#toggleComments").data("id").toString();
      const templateSource = $("#comment-template").html();
      const template = Handlebars.compile(templateSource);
      $.get("/comments", {id: teeTimeId}, function(comments) {
        comments.forEach(function(comment) {
          const commentDiv = template(comment);
          $("#comments").append(commentDiv);

          if (comment.user.get_image !== "user-default.jpg") {
            $("#comments img").last().attr("src", comment.user.get_image);
          }
        });
      });
    }
    $("#toggleComments").text("Hide Comments");
  } else {
    $("#commentForm").hide();
    $("#comments div").hide();
    $("#toggleComments").text("Show Comments");
  }
}
