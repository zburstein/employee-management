class Employee < ApplicationRecord
  #associations
  has_many :shifts, -> { order "id DESC" }
  has_many :sales, through: :shifts #####might not need this (check employee show)########
  has_many :weekly_payrolls
  belongs_to :position
  #has_many :tip_pools, through: :shifts ###might not need this###### add it if i need it

  #devise model
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  #validations
  validates :name, presence: true
  validates :position, presence: true
  validates :wage, presence: true
  validates :email, presence: true, uniqueness: true

  #randomize the EID
  before_create :randomize_id

  #get employee's current shift. returns nil if none
  def current_shift
    #Shift.find_by_completed_and_employee_id(false, self.id)
    Shift.employees_current_shift(self)
  end

  #get the current weekly payroll. 
  def current_weekly_payroll
    WeeklyPayroll.current_weekly_payroll(self)
  end

	private
  #randomizes the EID, doing so until unique
	def randomize_id
	  begin
	    self.id = SecureRandom.random_number(99999) + 10000
	  end while Employee.where(id: self.id).exists?
	end

end
