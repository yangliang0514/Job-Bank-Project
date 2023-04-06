class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resume, only: %i[create]
  before_action :find_comment, only: %i[edit update destroy]

  def create
    # 直接用current_user去做新的comment，這樣就等於自動把user資料放進去，就不用再手動放
    @comment = current_user.comments.new(comment_data)
    # 把resume的資料放進去，或是可以在comment_data的地方直接用merge把東西先放進去就又省了一步
    # (只能放current_user，然後用resume去做comment)
    @comment.resume = @resume

    if @comment.save
      redirect_to resume_path(@resume.id), notice: "新增評論成功"
      return
    end

    @comments = @resume.comments.where(user: current_user).order(created_at: :desc)
    flash[:alert] = "請輸入內容"
    render "resumes/show"
  end

  def destroy
    find_comment
    @comment.destroy
    # 把找出來的comment再找他對應的resume，因刪掉的事database裡面的，不是那個instance variable，所以還是可以得到
    redirect_to resume_path(@comment.resume.id)
  end

  private

  def find_comment
    # 用current_user去找，不直接用Comment model找因為如果用model找，只要改id就可以刪掉其他人的留言
    @comment = current_user.comments.find(params[:id])

  end

  def find_resume
    @resume = Resume.find(params[:resume_id])
  end

  def comment_data
    params.require(:comment).permit(:content)
  end
end
