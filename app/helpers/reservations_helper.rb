module ReservationsHelper
  def tables_select(count)
    (1..count).map { |i| [i, i - 1] }
  end
end
