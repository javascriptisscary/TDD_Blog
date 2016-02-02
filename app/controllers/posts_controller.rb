class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    
  end

  def create
    @post = Post.new(post_params)
    
    if @post.save!
      redirect_to @post, notice: 'Post was successfully created'
    else
      redirect_to root_path, alert: 'Post not created. Please try again.'
    end
    
  end

  def new
    @post = Post.new
  end

  def show
    
  end
  
  def edit
    
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      render :show, notice: 'Post successfully updated'
    else
      render :edit, alert: 'Post was not updated. Please try again.'
        
    end
    
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private
  
    def post_params
      params.require(:post).permit(:user_id, :title, :content)
    end

end