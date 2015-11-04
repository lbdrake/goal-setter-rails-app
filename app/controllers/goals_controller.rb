class GoalsController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :destroy, :edit]

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = current_user.goals.new(goal_params)
    if @goal.save
      redirect_to user_url(current_user)
    else
      flash[:errors] = @goal.errors.full_messages
      redirect_to user_url(current_user)
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    render :edit
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to user_url(current_user)
    else
      flash[:errors] = @goal.errors.full_messages
      redirect_to user_url(current_user)
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to user_url(current_user)
  end

  def index
    @goals = Goal.all.where(goal_type: "Public").order("created_at")
    render :index
  end

  def show
    @goal = Goal.find(params[:id])
    @comments = @goal.comments
    render :show
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :goal_type)
  end

  def ensure_correct_user
    @goal = Goal.find(params[:id])

    unless current_user.id == @goal.user_id
      redirect_to user_url(current_user)
    end
  end
end
