module ApplicationHelper
  def week_range(week)
    "#{week.date_started.strftime("%m/%d/%Y")} - #{(week.date_started + 6.days).strftime("%m/%d/%Y")}"
  end
end
