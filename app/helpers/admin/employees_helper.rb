module Admin::EmployeesHelper
  def time_worked_string(shift)
    Time.at(shift.finished_at - shift.created_at).utc.strftime("%H:%M")
  end

=begin
  def time_worked_decimal(shift)
    seconds_worked = shift.finished_at - shift.created_at
    hours_ratio = (seconds_worked / 1.hour).round(1)
    #minutes = 
    #not finished
  end
=end
end
