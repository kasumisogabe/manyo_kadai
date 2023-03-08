class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    if params[:sort_limit]
      @tasks = Task.latest
    else
      @tasks = Task.all.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

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
    @tasks = Task.by_keyword(params[:keyword]).by_status(params[:status])
    # keyword = params[:keyword]
    # status = params[:status]
    # if keyword.present? && status.present?
    #   @tasks = Task.where("title LIKE ? AND status = ?", "%#{keyword}%", status)
    # elsif keyword.present?
    #   @tasks = Task.where("title LIKE ?", "%#{keyword}%")
    # elsif status.present?
    #   @tasks = Task.where("status = ?", status)
    # else
    #   @tasks = Task.all
    # end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :limit, :status, :priority)
    end
end
