class AddReferenceToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :user_id, :integer
    add_column :comments, :resume_id, :integer
    add_index :comments, :deleted_at
    add_index :comments, :user_id
    add_index :comments, :resume_id
  end
end
