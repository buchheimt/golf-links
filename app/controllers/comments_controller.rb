class CommentsController < ApplicationController

  def index
    @comments = Comment.for_tee_time_sorted(params[:id])
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

  def destroy
    @comment = Comment.find_by_id(params[:id])
    authorize @comment
    @comment.wipe
    render json: @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:tee_time_id, :content)
  end

end
