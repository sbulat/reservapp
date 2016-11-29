module ReservationsHelper
  def display_date(date, reservations)
    if !reservations.all?(&:approved?)
      "#{date} <span style='font-style: italic; color: red'>!</span>".html_safe
    else
      date
    end
  end
end
