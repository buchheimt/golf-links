class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:tee_time_id, :content)
  end

end
