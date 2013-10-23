class CreateMicropostSubjects < ActiveRecord::Migration
  def change
    create_table :micropost_subjects do |t|
      t.integer :micropost_id
      t.integer :subject_id

      t.timestamps
    end
    add_index :micropost_subjects, :micropost_id
    add_index :micropost_subjects, :subject_id
    add_index :micropost_subjects, [:micropost_id, :subject_id], unique: true
  end
end
