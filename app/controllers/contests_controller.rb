class ContestsController < ApplicationController
  before_filter :authenticate_user!, :only => [:comment, :destroy_comment]

  def index
    @contests = Contest.all
  end

  def show
    @contest = Contest.find(params[:id])
  end

  def comment
    @contest = Contest.find(params[:id])
    new_comment = @contest.comments.build(comment_params)
    new_comment.user_id = current_user.id
    # Use the bang to be able to save new_comment as the new saved object and pass it to the json below.
    new_comment.save!
    render :json => new_comment.to_json, :status => 200
  end

  def destroy_comment
    @comment = Comment.where(
      :id => params[:comment_id],
      :contest_id => params[:contest_id]
    ).first

    # TODO: Destroy the comment
    @comment.destroy if @comment.user_id == current_user.id

    render :nothing => true, :status => 200
  end

private

  def comment_params
    params.permit(:side, :username, :comment)
  end

end
