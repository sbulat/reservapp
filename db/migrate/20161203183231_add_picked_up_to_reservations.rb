class AddPickedUpToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :picked_up, :boolean, default: false
  end
end
