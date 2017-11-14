function Comment(attributes) {
  this.id = attributes.id;
  this.username = attributes.user.username;
  this.timestamp = attributes.timestamp;
  this.content = attributes.content;
  this.status = attributes.status;
}

Comment.ready = function() {
  Comment.templateSource = $("#comment-template").html();
  Comment.template = Handlebars.compile(Comment.templateSource);
}

Comment.prototype.renderDiv = function() {
  Comment.templateSource = $("#comment-template").html();
  Comment.template = Handlebars.compile(Comment.templateSource);
  const commentDiv = Comment.template(this);
  $("#comments").prepend(commentDiv);
  const $newComment = $("#comments div").first();
  if (this.username === $("#currentUser .username").text()) {
    $("#comments .comment-content").first().addClass("dark");
    attachCommentEditListener($newComment.find(".comment-edit"))
    attachCommentRemoveListener($newComment.find(".comment-remove"))
    if (this.status === "active") {
      $(".octicon-check").addClass("hidden");
      $newComment.find(".comment-edit").show();
      $newComment.find(".comment-remove").show();
    }
  }
}

$(document).on("turbolinks:load", function() {
  $("#toggleComments").click(toggleComments);
  $("#new_comment").submit(createComment);
  //Comment.ready()
});

const createComment = (e) => {
  e.preventDefault();
  const values = $(e.target).serialize();
  $.post("/comments", values, function(commentJSON) {
    const comment = new Comment(commentJSON);
    comment.renderDiv();
    const $newComment = $("#comments div").first();
    $("#addCommentBtn").removeAttr("data-disable-with");
    $("#addCommentBtn").removeAttr("disabled");
    $("#comment_content").val("");
    $newComment.fadeIn();
  });
}

const toggleComments = () => {
  if ($("#toggleComments").text() === "View Comments") {
    $(".tee-time-show-card").fadeOut('400', function() {
      $("#commentForm").fadeIn();
      $("#toggleComments").hide();
      if ($("#comments div").length > 0) {
        $("#comments div").fadeIn();
      } else {
        const teeTimeId = $("#toggleComments").data("id").toString();
        const templateSource = $("#comment-template").html();
        const template = Handlebars.compile(templateSource);
        $.get("/comments", {id: teeTimeId}, function(commentsJSON) {
          commentsJSON.forEach(function(commentJSON) {
            const comment = new Comment(commentJSON);
            comment.renderDiv();
          });
        });
      }
      $("#toggleComments").text("Back to Info");
      $("#toggleComments").fadeIn();
    });
  } else {
    $(".tee-time-show-card").fadeIn();
    $("#commentForm").fadeOut();
    $("#comments div").fadeOut();
    $("#toggleComments").text("View Comments");
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
