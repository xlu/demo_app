class AddMicropostToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :micropost_id, :string
  end
end
