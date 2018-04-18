class WeeklyPayroll < ApplicationRecord
  #associations
  belongs_to :employee
  belongs_to :week 
  has_many :shifts #insert this
  #has_many :sales, through: :shifts how deep should i go

  #serialize the hash to be stored on db
  serialize :hours_worked_per_day, Hash

  #validations
  validates :employee, presence: true
  validates :week, presence: true, uniqueness: { scope: :employee }



  def total_hours_worked
    self.hours_worked_per_day.values.sum
  end

  #gets the employee's current payroll. If one does not exist, it will create it and return it
  def self.current_weekly_payroll(employee)
    #get the week
    current_week = Week.current

    #if one already exists, return it
    if weekly_payroll = current_week.weekly_payrolls.find_by(employee: employee) 
      weekly_payroll
    
    else
      #else create and save new one and then return it
      weekly_payroll = WeeklyPayroll.new(week: current_week, employee: employee)
      weekly_payroll.save!
      weekly_payroll
    end
  end


  #update the weekly payroll with the changes to shift
  def adjust_hours_and_wage!(shift, action)
    #case for the action being executed
    case action

    #on create simply add the values on shift
    when "create"
      hours = shift.hours_worked
      wage = shift.wage_earned

    #on update, calculate the change and adjust
    when "update"
      #get the differences
      hours =  shift.hours_worked - (shift.hours_worked_before_last_save || 0)
      wage = shift.wage_earned  - (shift.wage_earned_before_last_save || 0)

    #on destory remove entirely
    when "destroy"
      hours = -shift.hours_worked
      wage = -shift.wage_earned
    end

    #then adjust them on self if needed
    add_hours_to_day!(shift.day_worked, hours) if hours != 0
    add_wage_to_total!(wage) if wage != 0

    #and save, throwing an exception on a fail
    self.save!
  end

  private
  #adds the number of hours to the specified day. Used also for subtration
  def add_hours_to_day!(day, hours)
    #prep the day of the week
    days_of_the_week = Date::DAYNAMES
    days_of_the_week = days_of_the_week.map(&:downcase)

    #if present then add it to the day, else throw an exception
    days_of_the_week.include?(day) ? (self.hours_worked_per_day[day.to_sym] += hours) : raise("Day does not exist within Weekly Payroll")   
  end

  #add the wage to total
  def add_wage_to_total!(wage)
    self.total_wage += wage
  end
end
