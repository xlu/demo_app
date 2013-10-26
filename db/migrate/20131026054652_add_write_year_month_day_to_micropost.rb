class AddWriteYearMonthDayToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :write_month, :string
    add_column :microposts, :write_day,   :string
    add_column :microposts, :write_year,  :string
  end
end
