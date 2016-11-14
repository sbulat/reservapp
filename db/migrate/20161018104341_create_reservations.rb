class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :date
      t.string :hour
      t.integer :people
      t.string :client_phone
      t.string :client_name
      t.integer :table_id

      t.timestamps null: false
    end
  end
end
