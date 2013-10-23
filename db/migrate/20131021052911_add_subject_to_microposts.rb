class AddSubjectToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :subject_id, :string
  end
end
