require 'carrierwave/orm/activerecord'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    if params[:search]
      @posts = Post.search(params[:tag_id], params[:search], params[:search_type]).order("created_at DESC")
    else
      @posts = Post.all.order('created_at DESC')
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @all_tag = Tag.all
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.create(post_params)
      if @post.save
        flash[:success] = "Post created successfully!"
        redirect_to root_path
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy

    if @post.destroy
      flash[:success] = "Post deleted successfully"
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :description, :date_modified, :post_status, {imgs: []})
    end
end
