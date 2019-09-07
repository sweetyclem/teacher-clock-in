class CreateClockIns < ActiveRecord::Migration[6.0]
  def change
    create_table :clock_ins do |t|
      t.datetime :start
      t.datetime :end
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
