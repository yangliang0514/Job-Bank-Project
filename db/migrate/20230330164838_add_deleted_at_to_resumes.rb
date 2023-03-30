class AddDeletedAtToResumes < ActiveRecord::Migration[6.1]
  def change
    add_column :resumes, :deleted_at, :datetime
    add_index :resumes, :deleted_at
  end
end
