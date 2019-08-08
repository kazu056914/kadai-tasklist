class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.order(id: :desc)
  end

  def show
    unless @task
      redirect_to root_url
    end
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render :new
    end
  end

  def edit
    unless @task
      redirect_to root_url
    end
  end

  def update
    unless @task
      flash[:danger] = 'Taskは更新されませんでした'
      redirect_to root_url
      return
    end

    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end

  def destroy
    unless @task
      flash[:danger] = 'Taskは削除されませんでした'
      redirect_to root_url
      return
    end

    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end
