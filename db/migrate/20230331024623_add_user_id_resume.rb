class AddUserIdResume < ActiveRecord::Migration[6.1]
  def change
    # 這邊的user只是一個命名，只是在resume中會加入一個user_id column，所以這裡不要自己加id
    add_reference :resumes, :user
  end
end
