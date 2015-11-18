require 'carrierwave/orm/activerecord'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :close]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :close]
  before_action :correct_user, only: [:edit, :update, :close]

  # GET /posts
  # GET /posts.json
  def index
    if params[:search]
      if params[:search_type] == '0' 
        @posts = Post.search_by_tag_want(params[:search])
      else
        @posts = Post.search_by_tag_have(params[:search])
      end
    else
      @posts = Post.where.not(post_status: true).order('created_at DESC')
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post_attachments = @post.post_attachments.all
    @current_tag_have = []
    @current_tag_want = []

    all_tag_have = @post.tag_have.all
    all_tag_have.each do |a|
      tbi = Tag.find(a.tag)
      @current_tag_have << tbi
    end

    all_tag_want = @post.tag_want.all
    all_tag_want.each do |a|
      tbi = Tag.find(a.tag)
      @current_tag_want << tbi
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post_attachment = @post.post_attachments.build
    @tag_have = @post.tag_have.build
    @tag_want = @post.tag_want.build
    @all_tag = Tag.all
  end

  # GET /posts/1/edit
  def edit
    @all_tag = Tag.all
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.create(post_params)
    @post.post_status = false
      if @post.save
        params[:post]['tag_have'].each do |tag|
          if tag != ''
            @tag_have = @post.tag_have.create(:tag => tag.to_i, :post => @post)
          end
        end

        params[:post]['tag_want'].each do |tag|
          if tag != ''
            @tag_want = @post.tag_want.create(:tag => tag.to_i, :post => @post)
          end
        end

        params[:post_attachments]['avatar'].each do |a|
          @post_attachment = @post.post_attachments.create!(:avatar => a)
        end

        flash[:success] = "Post created successfully!"
        redirect_to @post
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
    post_id = @post.id

    unless @post.user_id == current_user.id
      flash[:error] = "Bạn không thể xoá bài đăng của người khác!"
      redirect_to action: "index"
      return
    end

    if @post.destroy
      wants = TagWant.where(post: post_id)
      wants.each { |a| a.destroy }
      
      haves = TagHave.where(post: post_id)
      haves.each { |a| a.destroy  }
      
      flash[:success] = "Post deleted successfully"
      redirect_to root_path
    end
  end
  
  def close
    unless @post.user_id == current_user.id
      flash[:error] = "Bạn không thể đóng bài đăng của người khác!"
      redirect_to action: "index"
      return
    end
    
    if @post.update(post_status: true)
      flash[:success] = "Bài đăng đã được đóng lại"
      redirect_to action: "index"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :description, :date_modified, :post_status, post_attachments_attributes: [:id, :post_id, :avatar])
    end

    def correct_user
    end

    def assign_user(post)
      post.user_id = current_user.id
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to access this page"
        redirect_to login_path
      end
    end

end
