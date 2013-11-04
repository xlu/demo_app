class AddBirthTimeSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :birth_time, :datetime
  end
end
