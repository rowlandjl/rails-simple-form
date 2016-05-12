class CommentsController < ApplicationController
  def create
    @menu_item = MenuItem.find(params[:menu_item_id])
    @comment = @menu_item.comments.build(comment_params)

    if @comment.save
      redirect_to menu_item_path(@menu_item),
        success: "Your comment was created successfully."
    else
      flash.now[:success] = "There was an issue with your comment. Please try again."
      render action: "../menu_items/show"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
