class TasksController < ApplicationController
  before_action :require_user_logged_in
  # before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:destroy, :update, :edit, :show]
  
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に作成されました'
      redirect_to root_url
      
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクが正常に作成されませんでした'
      render 'toppages/index'
    end
  end

  def edit
  end

  def update

    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Taskは正常に更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  
  private
  
  #strong parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
