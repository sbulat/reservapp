class AddApprovedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :approved, :boolean, default: false
  end
end
