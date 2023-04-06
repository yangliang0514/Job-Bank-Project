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
      # 因在form_with的local設成false，可以用JavaScript做畫面的部分更新
      # 就是一樣post到背後的url，但不做redirect，而畫面上的評論區用JavaScript操作DOM的方式去做更新
      # 所以這邊會直接跑到view裡面的create.js.erb去跑那個js檔案，所以可以在那裡面寫insertAdjacentHTML來做畫面更新，不轉址
      # 是rails奇特的寫法
      return
    end

    @comments = @resume.comments.where(user: current_user).order(created_at: :desc)
    # 記得用render不能直接把flash放在後面，要像這樣獨立另外寫，只有redirect_to才能直接寫在後面
    flash[:alert] = "請輸入內容"
    render "resumes/show"
  end

  def destroy
    @comment.destroy
    # 把找出來的comment再找他對應的resume，因刪掉的事database裡面的，不是那個instance variable，所以還是可以得到
    # 其實這邊可以不用把id指名放進去，只要resume就可以了，但我覺得這樣寫比較好懂
    redirect_to resume_path(@comment.resume.id), notice: "評論已刪除"
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
