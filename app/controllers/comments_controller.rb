class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = current_user.authored_comments.new(comment_params)
    # @comment.commentable_id =

    if @comment.save
      redirect_to goal_url(@comment.goal)
    else
      render :new
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :goal)
  end
end
