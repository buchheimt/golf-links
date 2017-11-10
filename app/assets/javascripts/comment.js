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
    $("#comments .comment-content").last().addClass("dark");
    attachCommentEditListener($newComment.children(".comment-edit"));
    attachCommentRemoveListener($newComment.children(".comment-remove"));
    $(".octicon-check").addClass("hidden");
    $newComment.children(".comment-edit").show()
    $newComment.children(".comment-remove").show();
    $("#addCommentBtn").removeAttr("data-disable-with");
    $("#addCommentBtn").removeAttr("disabled");
    $("#comment_content").val("");
  });
}

const toggleComments = () => {
  if ($("#toggleComments").text() === "To Comments") {
    $(".tee-time-show-card").fadeOut();
    $("#commentForm").fadeIn();
    $("#toggleComments").hide();
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
            attachCommentEditListener($newComment.children(".comment-edit"))
            attachCommentRemoveListener($newComment.children(".comment-remove"))
            if (comment.status === "active") {
              $(".octicon-check").addClass("hidden");
              $newComment.children(".comment-edit").show();
              $newComment.children(".comment-remove").show();
            }
          }
        });
      });
    }
    $("#toggleComments").text("Back to Info");
    $("#toggleComments").fadeIn();
  } else {
    $(".tee-time-show-card").fadeIn();
    $("#commentForm").fadeOut();
    $("#comments div").fadeOut();
    $("#toggleComments").text("To Comments");
  }
}

const attachCommentEditListener = ($button) => {
  $button.click(function() {
    const $targetDiv = $button.parents(".commentDiv");
    $targetDiv.find(".octicon-pencil").hide();
    $targetDiv.find(".octicon-check").fadeIn();
    const commentValue = $targetDiv.find(".content").text();
    $targetDiv.find(".content-col").html("<textarea class='textEditor'>");
    $targetDiv.find(".textEditor").val(commentValue);
    $button.off("click");
    $button.click(attachCommentUpdateListener($button));
  });
}

const attachCommentUpdateListener = ($button) => {
  $button.click(function() {
    const $targetDiv = $button.parents(".commentDiv");
    const commentContent = $targetDiv.find(".textEditor").val();
    const updateRoute = $(this).data("url");
    $.ajax({
      url: updateRoute,
      method: "PATCH",
      data: {'content': commentContent}
    }).done(function(comment) {
      $targetDiv.find(".octicon-check").hide();
      $targetDiv.find(".octicon-pencil").fadeIn();
      $targetDiv.find(".content-col").html("<p class='content'></p>");
      $targetDiv.find(".content").text(comment.content);
      $button.off("click");
      $button.click(attachCommentEditListener($button));
    });
  });
}

const attachCommentRemoveListener = ($button) => {
  $button.click(function() {
    if (confirm("You're sure you want to remove this comment?")) {
      const deleteRoute = $(this).data("url");
      $.ajax({url: deleteRoute, method: "DELETE"}).done(function(data) {
        const $toWipe = $(".commentDiv[data-id=" + data.id + "]");
        $toWipe.find(".content").text(data.content);
        $toWipe.find(".username").text("[removed]");
      });
      $(this).hide();
      $(this).siblings().hide();
    }
  })
}
