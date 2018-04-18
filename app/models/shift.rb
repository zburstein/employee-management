class Shift < ApplicationRecord
  #associations
  has_many :sales
  belongs_to :employee 
  belongs_to :weekly_payroll 
  belongs_to :position
  has_many :tip_pools  
  has_one :week, through: :weekly_payroll 

  #validations
  validates :employee, presence: true
  validates_inclusion_of :completed, in: [true, false]
  validates :wage_earned, presence: true, if: :completed
  validates :tip_earned, presence: true, numericality: {greater_than_or_equal: 0}
  validates :finished_at, presence: true, if: :completed
  validates :position, presence: true
  validates_inclusion_of :associate_with_sale, in: [true, false]
  validates :weekly_payroll, presence: true 

  #custom validations: 
  validate :finished_at_greater_than_created_at #ensure that started is before finished
  validate :shift_in_week, if: :completed   #ensure that shift is within the week being assigned
  #validate :no_overlap

  #block more tahn one open shift
  before_save :block_multiple_open_shifts

  #validates :completed, uniqueness: { scope: :employee }, if :completed

  #assign default position, wage, and weekly payroll on creation if none are provided
  before_validation :assign_defaults, on: :create

  #set wage earned on admin create so it passes validations
  before_validation :calculate_wage_earned!, on: :create, if: :before_admin_create?

  #destorys associated objects when shift is destoryed
  before_destroy :adjust_associated_values_on_destroy

  
  ######admin update##########
  before_update :adjust_calculated_values, if: :admin_update?  #adjust any necessary calculated values after admin update
  #change associate with sale if the position is changed
  before_update :change_associate_with_sale, if: :position_id_changed?
  #recollectivize the tips if the position was changed to either associate or not associate
  after_update :adjust_tip_association, if: :saved_change_to_associate_with_sale?

  #goes throug pools and removes any outside of shift time and adds those within if not already present
  #only if the time has changed and is to be associated with sales
  after_save :check_pools, if: :time_changed_and_associate_with_sale?

  #adjust the values of weekly payroll any time the time worked or wages changed
  after_save :adjust_weekly_payroll, if: :saved_changes_to_time_or_wage?  


  #return all active shifts
  def self.active_shifts
    #Shift.where("completed = ?", false)
    Shift.where("completed = ?", false).or(Shift.where("created_at < ? AND finished_at > ?", Time.zone.now, Time.zone.now))
  end

  #clocks out and saves the shift. returns the resource
  #will raise an exception if the shift is completed or save fails
  def clock_out!
    #dont clock out if already done

    raise "Can't clock out on completed shift" if completed == true

    #completed
    self.completed = true

    #finished at
    self.finished_at = Time.zone.now

    #wage
    calculate_wage_earned!

    self.save!
    self
  end

  #returns true or false if shif is completed
  def completed?
    completed
  end

  #add amount to tip_earned. Saves with exception 
  def add_tip!(amount)
    self.tip_earned += amount
    self.save!
  end

  #returns employees current shift. Called from employee model
  def self.employees_current_shift(employee)
    Shift.find_by_completed_and_employee_id(false, employee)
  end

  #returns the number of hours worked as a Decimal
  def hours_worked
    (BigDecimal.new((self.finished_at - self.created_at).to_i) / 1.hour).round(ROUND_VALUE)
  end

  #returns the number of hours that was worked before change 
  def hours_worked_before_last_save
    (BigDecimal.new((self.finished_at_before_last_save - self.created_at_before_last_save).to_i) / 1.hour).round(ROUND_VALUE)

  end

  #returns the name of the day of the week that shift was worked
  def day_worked
    self.created_at.strftime("%A").downcase
  end

  def concurrent_shifts_eligible_for_tip
    concurrent_shifts.reject{|shift| !shift.associate_with_sale}
  end


  private

  #returns shifts that overlap in any way with self
  def concurrent_shifts
    #does not cover shifts started before current that have not finished or finished after the shift !!!!! 

    #provide temporary place holder for finished_at to allow it to use current time if still an open shift
    finished_at_holder = (self.finished_at || Time.zone.now)

    #if completed
      #use or so can test even if the shift is incomplete. 
      #I do not beleive this shoudl affect the return because it still maintians range and I take into account any unfinished shifts
      range = self.created_at..finished_at_holder



      (Shift.where(created_at: range).
      or(Shift.where(finished_at: range)).
      or(Shift.where("created_at < ? AND finished_at > ?", self.created_at, finished_at_holder)).
      or(Shift.where("created_at < ? AND finished_at IS ?", self.created_at, nil))).
      reject{|shift| shift.id == self.id}
  end

  #if the shif tis being created by an admin
  def before_admin_create?
    !self.created_at.nil? && !self.finished_at.nil? && self.wage_earned.nil?
  end

  #calulates the wage earned in a finished shift
  def calculate_wage_earned!
    hours = self.hours_worked#((self.finished_at - self.created_at)/ 1.hour) #.round(2)##########Do I round this or not?????######********
    self.wage_earned = self.wage * hours
  end

  #makes completed a private varaiable. Might change this
  def completed
    self[:completed]
  end

  #ensures that an employee can never have more than one open and active shift
  def block_multiple_open_shifts
    #the purpose of this funciton to block multiple open shifts from being present at any time, but also allow updates on incomplete shifts
    current_shift = self.employee.current_shift

    #if being saved is not completed, there is a current open shift, and that shift is not the one that is being saved, then block it
    if !completed && current_shift && current_shift.id != self.id #this might be a better one to have then the line below!
      errors.add(:completed, "Cant open more than one shift at a time")
      throw :abort
    end
  end

  #assign shift defaults unless otherwise specified
  def assign_defaults
    #assign role with either default or other if specified
    self.position ||= self.employee.position

    #this will be changed to check associate table and chekc those values but now I am keeping it simple
    self.associate_with_sale = self.position.associate_with_tip

    #assigns default wage unless otherwise specified
    self.wage ||= self.employee.wage

    #callback to assign weekly payroll
    self.weekly_payroll ||= WeeklyPayroll.current_weekly_payroll(self.employee)
  end

  #add error adn fail validation if clocked out time is earlier than clock in time. Only run when there is a clock_out time
  def finished_at_greater_than_created_at
    errors.add(:created_at, "The clock in time must be earlier than clock out time") if !self.finished_at.nil? && (self.created_at >= self.finished_at)
  end

  #validate if the shift is within the given week
  def shift_in_week
    #create ranges for botht eh week and shift
    week_range = (self.week.date_started)..(self.week.date_started + 1.week - 1.second)
    #shift_range = self.created_at..self.finished_at

    #invalid if they do not overlap
    errors.add(:created_at, "The shift must have started within the week") if !week_range.cover?(self.created_at) #only need the created at within if im going to close shifts at midnight
    #if !shift_range.overlaps?(week_range)
  end

  #validate that there are no overlapping shifts 
  def no_overlap
    concurrent_shifts.each{|shift| errors.add(:created_at, "The shift must not overlap with any other of the same employee. If unable to clock out contact manager to resolve conflict") if shift.employee == self.employee}
  end

  #if the changes to time or wage was saved. this might be issue betwen updates and creates
  def saved_changes_to_time_or_wage?
    (self.saved_change_to_finished_at? || self.saved_change_to_created_at? || self.saved_change_to_wage?) && completed
  end

  ##if time or wage changed on a completed shift, returns true. Used to recalculate wages on edits
  def time_or_wage_changed?
    (self.finished_at_changed? || self.created_at_changed? || self.wage_changed?) && completed
  end

  #if just the time changed
  def time_changed?
    (self.finished_at_changed? || self.created_at_changed?) 
  end

  #need to destroy sales, their tip_pools, and adjust the values on weekly payroll when shift is destroyed
  def adjust_associated_values_on_destroy
    #destroy all tip pools
    #self.tip_pools.destroy(self.tip_pools)

    #remove the pool if is not the owner of the sale. If owner of the sale, the entire sale will be deleted shortly
    self.tip_pools.each do |pool|
      pool.sale.remove_shift_from_pool(self) if !pool.main_employee
    end

    #then all the sales
    self.sales.destroy(self.sales)

    #only alter payroll if the shift is completed
    if completed
      #then adjust the payroll values
      weekly_payroll = self.weekly_payroll
      weekly_payroll.adjust_hours_and_wage!(self, "destroy")
    end
  end

  #if the shift is being clocked out
  def after_clock_out?
    self.completed_before_last_save == false && self.completed? == true
  end

  #add the totals of the shift to weekly payroll totals after clock_out
  #will have to make changes for admin add
  def adjust_weekly_payroll
    weekly_payroll = self.weekly_payroll
    action = after_clock_out? ? "create" : "update"
    weekly_payroll.adjust_hours_and_wage!(self, action) 
  end

  #if the shift being updated was already completed (know its admin because currently no option to clock out on an admin update). Cant change tip earned in admin update, 
  #so it prevents updates when tip_add is called
  def admin_update?
    completed && !self.completed_changed? && !self.tip_earned_changed?
  end

  def adjust_calculated_values
    calculate_wage_earned! if time_or_wage_changed?    
  end

  #adjust the value of whether the shift is to be associated with sales
  def change_associate_with_sale
    self.associate_with_sale = self.position.associate_with_tip
  end

  #if shift changes positions
  #(this just removes. have to figure out how to add)
  def adjust_tip_association
    #if being unassociated with sales
    if !self.associate_with_sale

      #go through the tip pools of this shift
      self.tip_pools.each do |pool|
        next if pool.main_employee #dont remove them if they are the main employee

        #get the sale and remove self from the pool
        sale = pool.sale
        sale.remove_shift_from_pool(self)
      end
      
    else
      add_to_sales_during_shift
    end
  end

  def add_to_sales_during_shift
    sales_during_shift.each do |sale|
      sale.add_shift_to_pool(self) if (self.tip_pools & sale.tip_pools).empty? 
    end
  end

  #Retrieve all sales during the shift
  def sales_during_shift
    range = self.created_at..self.finished_at
    Sale.where(created_at: range)
  end

  #only when time or wage changed and to be associated with sales
  def time_changed_and_associate_with_sale?
    self.associate_with_sale && (self.saved_change_to_finished_at? || self.saved_change_to_created_at?) 
  end

  #Adds pools to sales within shift time and removes pools outside of shift time
  def check_pools
    #check existing pools first to remove any that are outside of the shift range. Dont remove if they made the sale. Could lead to problems
    range = self.created_at..self.finished_at
    self.tip_pools.where.not(created_at: range).each{|pool| pool.sale.remove_shift_from_pool(self) if !pool.main_employee}

    #then get all the ones that they are supposed to be associatied with and add the ones they arent
    add_to_sales_during_shift
  end

end
