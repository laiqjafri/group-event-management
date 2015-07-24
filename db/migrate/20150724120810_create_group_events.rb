class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string  :name, null: false
      t.text    :description
      t.string  :location
      t.date    :start_date
      t.date    :end_date
      t.integer :duration
      t.boolean :is_published, null: false, default: false

      t.timestamps null: false
    end
  end
end
