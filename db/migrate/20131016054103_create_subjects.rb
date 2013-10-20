class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :birth_month
      t.string :birth_day
      t.string :birth_year
      t.integer :user_id

      t.timestamps
    end
  end
end