class UsersController < ApplicationController
  # before_action :restrict_other_users, only: [:show]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def show
    @user = User.find(params[:id])
    @goals = @user.goals
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end

  # def restrict_other_users
  #   unless params[:id] == current_user.id
  #     redirect_to user_url(current_user)
  #   end
  # end
end
