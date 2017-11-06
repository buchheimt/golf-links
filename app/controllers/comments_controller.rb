class CommentsController < ApplicationController

  def index
    @comments = TeeTime.find_by_id(params[:id]).comments
    render json: @comments
  end

  def create
    @comment = Comment.new(comment_params)
    authorize @comment
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
