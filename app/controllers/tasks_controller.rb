class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(5)
    @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
    if params[:sort_limit]
      @tasks = Task.latest
      @tasks = @tasks.page(params[:page]).per(5)
    elsif params[:sort_priority]
      @tasks = Task.priority_sort
      @tasks = @tasks.page(params[:page]).per(5)
    else
      # @tasks = Task.all.order(created_at: :desc)
      # @tasks = @tasks.page(params[:page]).per(5)
      @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(5)
    end
  end

  def show
  end

  def new
    @task = Task.new
    @task.labellings.build
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    @tasks = Task.by_keyword(params[:keyword]).by_status(params[:status]).priority_sort.search_name(params[:label_search])
  end

  private
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :limit, :status, :priority,label_ids: [])
    end
end
