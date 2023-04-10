class AddPositionToResume < ActiveRecord::Migration[6.1]
  def change
    add_column :resumes, :position, :integer
  end
end
