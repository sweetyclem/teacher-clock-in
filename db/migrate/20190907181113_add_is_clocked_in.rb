class AddIsClockedIn < ActiveRecord::Migration[6.0]
  def change
    add_column :teachers, :is_clocked_in, :boolean
    add_reference :teachers, :last_clock_in, references: :clock_ins, index: true
  end
end
