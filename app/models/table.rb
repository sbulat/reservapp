class Table < ActiveRecord::Base
  acts_as_paranoid
  has_many :reservations

  validates :number, :seats, presence: true
  validates :number, numericality: { only_integer: true, greater_than: 0 }
  validates :number, uniqueness: true
  validates :seats, numericality: { only_integer: true, greater_than: 0 }

  class << self
    def ids_by_date(date, id)
      return Table.ids if date.nil?
      reservations = Reservation.where(date: date)
      reservations = reservations.where.not(id: id) unless id.to_i.zero?
      ids = reservations.pluck(:table_id)
      Table.ids - ids
    end

    def ids_by_people(people)
      return Table.ids if people.nil?
      Table.where('seats >= ?', people.to_i).pluck(:id)
    end
  end
end
