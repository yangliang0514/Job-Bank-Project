class Api::V1::ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resume

  def sort
    # 看新的index是第幾位，改變他的順序並寫進資料庫
    @resume.insert_at(params[:newIndex].to_i)

    # position
    render json: { id: params[:id], result: "ok" }
  end

  private

  def find_resume
    if current_user.role == "user" || current_user.role == "vip"
      @resume = current_user.resumes.find(params[:id])
      return
    end

    @resume = Resume.find(params[:id])
  end
end
