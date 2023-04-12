class ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resume, only: %i[show edit update destroy like]

  def index
    # Lazy loading (可以先chain那些方法，等到最後進資料庫才會一次query，跟mongoose一樣)
    # @resumes = Resume.where(user: current_user).order(created_at: :desc)
    # 這裡的user其實是代表user_id: current_user.id，只是內建的慣例會自動去找
    # 更好的寫法，resumes是用關聯建立的方法，建立在User底下
    if current_user.role == "user" || current_user.role == "vip"
      @resumes = current_user.resumes
    else
      @resumes = Resume.all
    end
    # Delegate methods (@resume出來會是一個物件的集合，不是那個實體，但會自動去找到那個上面的類別方法，再去查)
    @resumes = @resumes.search(params[:keyword]) if params[:keyword].present?
  end

  def show
    @comment = Comment.new

    # 把所有comments找出來並依照時間反向排列，要放到show裡面的，且只要找出那個user自己留的留言，才不會看到別人的留言
    @comments =
      @resume.comments.order(created_at: :desc).where(user: current_user)
  end

  def new
    @resume = Resume.new
    authorize @resume
  end

  def create
    @resume = Resume.new(resume_params)
    @resume.user = current_user #是belongs_to做出來的方法，把他指向current user，意思就是把user放進去，讓他可以指向

    authorize @resume # pundit gem 提供的方法，用來驗證授權

    if @resume.save
      # flash => create a popup, use it kind of like a hash
      flash[:notice] = "新增履歷成功"
      redirect_to resumes_path
      return
    end

    flash[:alert] = "新增履歷失敗"

    # 這裡要status 403，因為用turbo drive時，如果有validation error，要回給他400 or 500，不然會出現錯誤
    render "resumes/new", status: 403
  end

  def edit
    authorize @resume
  end

  def update
    authorize @resume

    if @resume.update(resume_params)
      redirect_to resume_path(@resume), notice: "已更新成功"
      return
    end

    render :edit
  end

  def destroy
    authorize @resume

    @resume.destroy
    redirect_to resumes_path, notice: "已成功刪除！"
  end

  def like
    authorize @resume

    liked = current_user.liked?(@resume)

    if liked
      current_user.liked_resumes.delete(@resume)
    else
      # 把那個履歷push進去那個liked array中
      current_user.liked_resumes << @resume
    end

    render json: { id: params[:id], status: liked ? "unliked" : "liked" }
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
    if current_user.role == 1
      @resume = current_user.resumes.find(params[:id])
      return
    end

    @resume = Resume.find(params[:id])
  end
end
