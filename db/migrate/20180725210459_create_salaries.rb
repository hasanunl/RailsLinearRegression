class CreateSalaries < ActiveRecord::Migration[5.2]
  def change
    create_table :salaries do |t|
      t.integer :experience
      t.integer :salary

      t.timestamps
    end
  end
end
