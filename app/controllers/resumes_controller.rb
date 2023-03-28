class ResumesController < ApplicationController
  # stree-ignore
  before_action :find_resume, only: [:show, :edit, :update, :destroy]

  def index
    # Lazy loading (可以先chain那些方法，等到最後進資料庫才會一次query，跟mongoose一樣)
    @resumes = Resume.all.order(created_at: :desc)
    # Delegate methods (@resume出來會是一個物件的集合，不是那個實體，但會自動去找到那個上面的類別方法，再去查)
    @resumes = @resumes.search(params[:keyword]) if params[:keyword].present?
  end

  def show
  end

  def new
    @resume = Resume.new
  end

  def create
    @resume = Resume.new(resume_params)

    if @resume.save
      # flash => create a popup, use it kind of like a hash
      flash[:notice] = "新增履歷成功"
      redirect_to resumes_path
      return
    end

    flash[:alert] = "新增履歷失敗"
    render "resumes/new"
  end

  def edit
  end

  def update
    if @resume.update(resume_params)
      redirect_to resume_path(@resume), notice: "已更新成功"
    else
      render :edit
    end
  end

  def destroy
    @resume.destroy
    redirect_to resumes_path, notice: "已成功刪除！"
  end

  private

  def resume_params
    params.require(:resume).permit(
      :name,
      :email,
      :tel,
      :skill,
      :intro,
      :city,
      :education,
      :experience,
      :portfolio,
    )
  end

  def find_resume
    @resume = Resume.find(params[:id])
  end
end
