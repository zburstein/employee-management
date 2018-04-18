class Week < ApplicationRecord
  #associations
  has_many :weekly_payrolls, -> {order "employee_id ASC"} 
  has_many :shifts, through: :weekly_payrolls #insert this, might not actually need this
  has_many :employees, through: :weekly_payrolls

  #validations
  validates :date_started, presence: true, uniqueness: true
  

  #returns the current week. If no week exists, it creates it
  def self.current
    #get the start day adn search db 
    beginning_of_week = Time.zone.now.beginning_of_week(start_day = :sunday)
    current_week = Week.find_by_date_started(beginning_of_week)

    #return it or create one if nothing is found
    current_week || Week.create_current_week!
  end

  def employees_without_payroll
    Employee.where.not(id: self.employee_ids)
  end

  private
  #Use this in task? 
  #creates current week and returns it. Raises an exception if save fails
  def self.create_current_week!
    week = Week.new(date_started: Time.zone.now.beginning_of_week(start_day = :sunday))
    week.save!
    week
  end
end
