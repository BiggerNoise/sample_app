class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:edit, :update, :index]
  before_filter :only_self,       only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def  update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def signed_in_user
    store_location
    redirect_to '/auth/cas' unless signed_in?
  end

  def only_self
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end
end
