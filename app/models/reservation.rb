class Reservation < ActiveRecord::Base
  acts_as_paranoid column: :cancelled_at
  belongs_to :table

  validates :table_id, :date, :hour, :client_name, :client_phone, :people,
            presence: true
  validates :table_id, numericality: true, inclusion: { in: Table.ids }
  validates :table_id, uniqueness: {
    scope: :date
  }
  validate :table_have_enough_seats
  validate :date_cant_be_past
  validates :hour, format: {
    with: /\A\d{1,2}.\d{2}\z/
  }
  validates :people, numericality: { only_integer: true, greater_than: 0 }
  validates :client_phone, format: {
    with: /\A\d{9}\z/
  }

  before_save :correct_hour
  after_create :send_sms

  scope :current, -> { where('date >= ?', Time.current.beginning_of_day) }
  scope :old, -> { where('date < ?', Time.current.beginning_of_day) }

  def send_sms
    return unless approved?
    return unless client_phone == '669215504'
    service = SmsAPI::Service.new(client_phone)
    service.message = I18n::t('.reservations.approved', day: date, hour: hour)
    service.send_sms
  end

  private

  def correct_hour
    h = hour.scan(/(\d+).(\d+)/).flatten
    h[0] = "0#{h[0]}" if h[0].length == 1
    self.hour = h.join(':')
  end

  def date_cant_be_past
    return if date.nil?
    if date < Time.current.beginning_of_day
      errors.add(:date, "can't be in the past")
    end
  end

  def table_have_enough_seats
    return if people.nil?
    seats = Table.find(table_id).seats.to_i
    errors.add(:table_id, "doesn't have enough seats") if seats < people
  rescue ActiveRecord::RecordNotFound
    errors.add(:table_id, "doesn't exist")
  end
end
