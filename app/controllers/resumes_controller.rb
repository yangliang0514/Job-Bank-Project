class ResumesController < ApplicationController
  def index
    @resumes = Resume.all.order(created_at: :desc)
  end

  def show
    @resumes = Resume.find(params[:id])
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
end
