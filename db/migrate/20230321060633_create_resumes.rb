class CreateResumes < ActiveRecord::Migration[6.1]
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :email
      t.string :tel
      t.string :skill
      t.text :intro
      t.string :city
      t.text :education
      t.text :experience
      t.text :portfolio

      t.timestamps
    end
  end
end
