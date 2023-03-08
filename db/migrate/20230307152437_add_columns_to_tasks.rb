class AddColumnsToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :limit, :date
    add_column :tasks, :status, :string
    add_column :tasks, :priority, :string
  end
end