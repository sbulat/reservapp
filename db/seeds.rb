require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# 8.times do |i|
#   s = (2..7).to_a.sample
#   Table.create(number: i + 1, seats: s)
# end

35.times do
  table = Table.pluck(:id, :seats).sample
  Reservation.create(
    date: Faker::Date.forward(7),
    hour: Faker::Number.between(15, 21).to_s + ':00',
    people: (2..table.last).to_a.sample,
    client_phone: Faker::Number.number(9),
    client_name: Faker::GameOfThrones.character,
    approved: true,
    table_id: table.first
  )
end
