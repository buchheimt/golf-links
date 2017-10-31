$(function() {
  $("#new_comment").submit(createComment)
});

const createComment = (e) => {
  e.preventDefault();
  const values = $(e.target).serialize();
  $.post("/comments", values, function(comment) {
    const newComment = '<div class="row"><div class="col-sm-12"><h4>' + comment.content + '</h4><br></div></div>'
    $("#comments").append(newComment);
    $("#addCommentBtn").removeAttr("data-disable-with");
    $("#addCommentBtn").removeAttr("disabled");
    $("#comment_content").val("");
  });
}
