class AddIsClockedIn < ActiveRecord::Migration[6.0]
  def change
    rename_column :teachers, :current_clock_in_id, :last_clock_in_id
    add_column :teachers, :is_clocked_in, :boolean
  end
end
