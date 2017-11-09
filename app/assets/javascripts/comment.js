$(function() {
  $("#toggleComments").click(toggleComments);
  $("#new_comment").submit(createComment);
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
    const $newComment = $("#comments div").last();
    $("#comments .comment-content").last().addClass("dark");
    $newComment.children(".comment-edit").show();
    $newComment.children(".comment-remove").show();
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
          const $newComment = $("#comments div").last();

          if (comment.user.username === $("#currentUser .username").text()) {
            $("#comments .comment-content").last().addClass("dark");
            $newComment.children(".comment-edit").show();
            $newComment.children(".comment-remove").show();
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
