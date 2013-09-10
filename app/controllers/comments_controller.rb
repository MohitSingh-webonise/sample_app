class CommentsController < ApplicationController
  def create
    params[:comment][:user_id] = current_user.id
    logger.info params.inspect
    @comment = Comment.new(secure_params)
    if @comment.save
      # @comm = Comment.where(micropost_id: params[:comment][:micropost_id]).order("created_at DESC")
      #redirect_to micropost_path
      #render :js => "window.location = #{micropost_path}"
      respond_to do |format|
      format.html { redirect_to @comment } #@comm } @comment
      format.js
      end
    else
      render micropost_path #{}"show", :notice => "error"
    end
  end

  def show
     # @post = Micropost.find_by(id: params[:id])
     # logger.info "|||||||||||||||||||||||||||||||||||||||||||"
     # logger.info current_user.name #@post.inspect
  end

  def secure_params
    params.require(:comment).permit(:content, :user_id, :micropost_id, :name)
  end
end
