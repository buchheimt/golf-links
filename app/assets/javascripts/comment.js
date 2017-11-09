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
    $(newComment).addClass("dark");
    $("#comments").append(newComment);
    $("#comments .comment-content").last().addClass("dark");

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
        comments.forEach(function(comment) {
          const commentDiv = template(comment);
          $("#comments").append(commentDiv);
          if (comment.user.username === $("#currentUser .username").text()) {
            console.log("wha");
            $("#comments .comment-content").last().addClass("dark");
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
