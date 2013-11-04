class AddWriteTimeToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :write_time, :datetime
  end
end
