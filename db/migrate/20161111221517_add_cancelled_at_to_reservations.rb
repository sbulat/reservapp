class AddCancelledAtToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :cancelled_at, :datetime
    add_column :reservations, :cancel_reason, :text
  end
end
