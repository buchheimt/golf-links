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
  $("#comments").prepend(Comment.template(this));
  this.$div = $("#comments div").first();
  if (this.isCurrentUser()) {
    this.$div.children().first().addClass("dark");
    this.attachEditListener();
    this.attachRemoveListener();
    if (this.isActive()) {
      this.$div.find(".octicon-check").addClass("hidden");
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
      $.ajax({url: $btn.data("url"), method: "DELETE"}).done(commentJSON => {
        this.$div.find(".content").text(commentJSON.content);
        this.$div.find(".username").text("[removed]");
      });
      $btn.hide();
      $btn.siblings().hide();
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
    }).done(commentJSON => {
      this.$div.find(".octicon-check").hide();
      this.$div.find(".octicon-pencil").fadeIn();
      this.$div.find(".content-col").html("<p class='content'></p>");
      this.$div.find(".content").text(commentJSON.content);
      $btn.off("click");
      this.attachEditListener();
    });
  });
}

Comment.prototype.isCurrentUser = function() {
  return this.username === $("#currentUser .username").text();
}

Comment.prototype.isActive = function() {
  return this.status === "active";
}

$(document).on("turbolinks:load", function() {
  $("#toggleComments").click(toggleComments);
  $("#new_comment").submit(createComment);
  Comment.ready();
});

const createComment = (e) => {
  e.preventDefault();
  const values = $(e.target).serialize();
  $.post("/comments", values, commentJSON => {
    const comment = new Comment(commentJSON);
    comment.renderDiv();
    $("#addCommentBtn").removeAttr("data-disable-with");
    $("#addCommentBtn").removeAttr("disabled");
    $("#comment_content").val("");
    comment.$div.fadeIn();
  });
}

const toggleComments = () => {
  const $toggleBtn = $("#toggleComments");
  if ($toggleBtn.text() === "View Comments") {
    $(".tee-time-show-card").fadeOut('400', function() {
      $("#commentForm").fadeIn();
      $toggleBtn.hide();
      if ($("#comments div").length > 0) {
        $("#comments div").fadeIn();
      } else {
        const teeTimeId = $toggleBtn.data("id").toString();
        $.get("/comments", {id: teeTimeId}, function(commentsJSON) {
          commentsJSON.forEach(commentJSON => {
            const comment = new Comment(commentJSON);
            comment.renderDiv();
          });
        });
      }
      $toggleBtn.text("Back to Info");
      $toggleBtn.fadeIn();
    });
  } else {
    $(".tee-time-show-card").fadeIn();
    $("#commentForm").fadeOut();
    $("#comments div").fadeOut();
    $toggleBtn.text("View Comments");
  }
}
