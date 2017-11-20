function Comment(attributes) {
  this.id = attributes.id;
  this.username = attributes.user.username;
  this.timestamp = attributes.timestamp;
  this.content = attributes.content;
  this.status = attributes.status;
}

Comment.ready = function() {
  if ($("#comment-template")[0]) {
    Comment.templateSource = $("#comment-template").html();
    Comment.template = Handlebars.compile(Comment.templateSource);
  }
}

Comment.prototype.renderDiv = function() {
  const commentDiv = Comment.template(this);
  $("#comments").prepend(commentDiv);
  this.$div = $("#comments div").first();
  if (this.isCurrentUser()) {
    $("#comments .comment-content").first().addClass("dark");
    this.attachEditListener();
    this.attachRemoveListener();
    if (this.isActive()) {
      $(".octicon-check").addClass("hidden");
      this.$div.find(".comment-edit").show();
      this.$div.find(".comment-remove").show();
    }
  }
}

Comment.prototype.attachEditListener = function() {
  const $btn = this.$div.find(".comment-edit");
  $btn.click(() => {
    this.$div.find(".octicon-pencil").hide();
    this.$div.find(".octicon-check").fadeIn();
    const commentValue = this.$div.find(".content").text();
    this.$div.find(".content-col").html("<textarea class='textEditor'>");
    this.$div.find(".textEditor").val(commentValue);
    $btn.off("click");
    this.attachUpdateListener();
  });
}

Comment.prototype.attachRemoveListener = function() {
  const $btn = this.$div.find(".comment-remove");
  $btn.click(() => {
    if (confirm("You're sure you want to remove this comment?")) {
      $.ajax({url: $btn.data("url"), method: "DELETE"}).done(function(data) {
        const $toWipe = $(".commentDiv[data-id=" + data.id + "]");
        $toWipe.find(".content").text(data.content);
        $toWipe.find(".username").text("[removed]");
      });
      $(this).hide();
      $(this).siblings().hide();
    }
  })
}

Comment.prototype.attachUpdateListener = function() {
  const $btn = this.$div.find(".comment-edit");
  $btn.click(() => {
    const commentContent = this.$div.find(".textEditor").val();
    $.ajax({
      url: $btn.data("url"),
      method: "PATCH",
      data: {'content': commentContent}
    }).done((comment) => {
      this.$div.find(".octicon-check").hide();
      this.$div.find(".octicon-pencil").fadeIn();
      this.$div.find(".content-col").html("<p class='content'></p>");
      this.$div.find(".content").text(comment.content);
      $btn.off("click");
      this.attachEditListener();
    });
  });
}

Comment.prototype.isCurrentUser = function() {
  return this.username === $("#currentUser .username").text()
}

Comment.prototype.isActive = function() {
  return this.status === "active"
}

$(document).on("turbolinks:load", function() {
  $("#toggleComments").click(toggleComments);
  $("#new_comment").submit(createComment);
  Comment.ready()
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
