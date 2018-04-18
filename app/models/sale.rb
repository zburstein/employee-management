class Sale < ApplicationRecord
  #associations
  belongs_to :shift
  has_one :employee, through: :shift
  has_many :tip_pools #the sum of the ppols is the total tip

  #validations
  validates :shift, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :tip, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :method_of_payment, presence: true

  validate :sale_in_shift

  #admin/destroy
  before_destroy :remove_tip_pools

  #sale creation
  after_create :collectivize_tip

  #admin/update
  before_update :recollectivize, if: :change_in_associated_shifts?
  after_update :adjust_tips, if: :tip_changed? #adjust the tip_pools if the tip was changed

  attr_accessor :associated_shift_ids, :new_associated_shift_ids


  def remove_shift_from_pool(shift)
    #add all pools to the new associated shifts exept for the shift provided and the main
    self.new_associated_shift_ids = []
    self.tip_pools.each do |pool|
      self.new_associated_shift_ids << pool.shift_id if pool.shift_id != shift.id && !pool.main_employee
    end

    self.recollectivize
  end

  def add_shift_to_pool(shift)
    #add the existing shift ids
    self.new_associated_shift_ids = []
    self.tip_pools.each{|pool| self.new_associated_shift_ids << pool.shift_id if !pool.main_employee}

    #then add self
    self.new_associated_shift_ids << shift.id

    #then recollectivize
    self.recollectivize
  end

  #removes the tip pools before destroying the sale
  def remove_tip_pools
    #remove the tip values from the shift and then destroy it
    self.tip_pools.each do |tip|
      tip.destroy
    end
  end

  #shoulf i work just with ids or can I work with the  full objects?
  def recollectivize
    #the current are existing pools and the new ones are held in new_associated_shift_ids
    current_assoc_shifts = self.tip_pools.map{|pool| pool.shift_id} #get the existing tip pools by shift id
    new_assoc_shifts = self.new_associated_shift_ids << self.shift_id #get what the new pools should be (the new associated and the self)
    new_assoc_shifts.uniq! #just as a precaution ensure there are no duplicates

    #set the percentages
    multiple_associated = (new_assoc_shifts.count > 2) ? true : false #if there are more than two employees, one being the main employee, then use multiple assoc percetnage

    #check if need to change existing percentages. use to have multiple associated, but is not now or if had solo associated but is now multi associated
    need_percentage_change = (current_assoc_shifts.count > 2 && !multiple_associated) ||  (current_assoc_shifts.count < 3 && multiple_associated) ? true : false

    #get what is on current but not new and then destroy them
    pools_to_remove = current_assoc_shifts.reject{|id| new_assoc_shifts.include? id}
    pools_to_remove&.each{|shift_id| self.tip_pools.find_by(shift_id: shift_id).destroy} #destroy each one. Tip removal is handled in tip pool callback

    #get what is on new but not current and create them
    pools_to_add = new_assoc_shifts.reject{|id| current_assoc_shifts.include? id}
    pools_to_add&.each do |shift_id|
      employee_position = Shift.find(shift_id).position
      assoc_percentage = multiple_associated ? employee_position.multi_associated_tip_percentage : employee_position.solo_associated_tip_percentage
      TipPool.new(sale: self, shift_id: shift_id, percentage_of_total: assoc_percentage, amount_for_employee: self.tip * assoc_percentage, main_employee: false).save!
    end

    #adjust existing if the number of employees changes the category
    if need_percentage_change
      pools_to_adjust = new_assoc_shifts & current_assoc_shifts
      pools_to_adjust.each do |shift_id|
        #get the pool
        pool = self.tip_pools.find_by(shift_id: shift_id)

        next if pool.main_employee

        #then the percentage
        employee_position = Shift.find(shift_id).position
        assoc_percentage = multiple_associated ? employee_position.multi_associated_tip_percentage : employee_position.solo_associated_tip_percentage

        #then adjust adn save. Callback in tip pool will handle adjusting associated values
        pool.adjust_with_new_percentage!(assoc_percentage)
      end
    end

    #main employee might always have to change even if percentage of existing does not change
    remaining_percentage = 1
    self.tip_pools.reload.each{|pool| remaining_percentage -= pool.percentage_of_total if !pool.main_employee}
    pool = self.tip_pools.find_by(main_employee: true)
    pool.adjust_with_new_percentage!(remaining_percentage)
  end

  private

  #pools the tip. called when sale created
  def collectivize_tip
    #retrieve the associated shifts
    associated_shifts = get_associated_shifts
    tip_pools = []
    remaining_percentage = 1

    #iterate through each associated shift if there are any
    associated_shifts&.each do |shift|

      #get the percentage based off of the number of associated employees and create the tip pool
      assoc_percentage = (associated_shifts.count > 1) ? shift.position.multi_associated_tip_percentage : shift.position.solo_associated_tip_percentage
      tip_pools << TipPool.new(sale: self, shift: shift, percentage_of_total: assoc_percentage, amount_for_employee: self.tip * assoc_percentage, main_employee: false)

      #subtract from remaining tip
      remaining_percentage -= assoc_percentage
    end

    #then create the Tip Pool for the main employee
    tip_pools << TipPool.new(sale: self, shift: self.shift, percentage_of_total: remaining_percentage, amount_for_employee: self.tip * remaining_percentage, main_employee: true)

    #finally iterate through each one and save it, throwing an exception to roll back if unsuccessful
    tip_pools.each do |pool|
      pool.save!
      #pool.shift.add_tip!(pool.amount_for_employee) #moved this to callback
    end
  end

  #retrieves the shifts to be associated with sale for the purpose of pooling the tip
  def get_associated_shifts
    #if no ids passed, then it is being created by an employee and must be retrieved
    if(self.associated_shift_ids.nil?)
      associated_shifts = []

      #retrieve all active shifts and return those that are meant to be associated and does not belong to the main empoyee
      currently_clocked_in = Shift.active_shifts
      currently_clocked_in.each do |shift|
        associated_shifts << shift if shift.associate_with_sale && shift.employee != self.employee
      end

    #else it is being created by an admin, so use supplied ids
    else
      associated_shifts = self.associated_shift_ids.map{|id| Shift.find(id)}
    end

    #return it
    associated_shifts
  end

  #adjusts the tip pools if th etip was changed
  def adjust_tips
    #get the tip pools 
    tip_pools = self.tip_pools

    #iterate through each one and adjust the value of amount earned based on the change in tip
    tip_pools.each do |pool|
      pool.amount_for_employee = pool.percentage_of_total * self.tip
      pool.save!
    end
  end

  def change_in_associated_shifts?
    #convert the associated to int and add the main shift
    new_pools = self.new_associated_shift_ids.map{|id| id.to_i}
    new_pools << self.shift.id

    #sort and copare with sorted shift ids on tip pools
    new_pools.sort != self.tip_pools.map{|pool| pool.shift_id}.sort

  end

  def sale_in_shift
    #set the range
    shift = self.shift
    shift_range = shift.created_at..(shift.finished_at || Time.zone.now)

    #add error if the sale is not within range
    errors.add(:created_at, "Sale must be within the time frame of the shift") if !shift_range.cover?(self.created_at)
  end




end
