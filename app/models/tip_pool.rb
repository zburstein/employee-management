class TipPool < ApplicationRecord
  belongs_to :sale #the sale the tip was a part of
  belongs_to :shift #the shift taht this share is to be associated with
  has_one :employee, through: :shift 

  validates :sale, presence: true
  validates :shift, presence: true
  validates :amount_for_employee, presence: true
  validates :percentage_of_total, presence: true
  validates_inclusion_of :main_employee, in: [true, false]

  validate :sale_in_shift

  after_create :add_tip_to_shift
  after_update :adjust_shift_tip_earned, if: :saved_change_to_amount_for_employee?

  after_destroy :remove_tip_from_shift

  def adjust_with_new_percentage!(percentage)
    self.percentage_of_total = percentage
    self.amount_for_employee = percentage * self.sale.tip
    self.save!
  end

  private 
  #Wehn tip pool created add its value to the shift
  def add_tip_to_shift
    self.shift.add_tip!(self.amount_for_employee)
  end

  #adjusts shift.tip_earned when the tip pool value is updated
  def adjust_shift_tip_earned
    #get tip difference between present and what it was before
    diff = self.amount_for_employee - self.amount_for_employee_before_last_save

    #adjust the value on the shift
    self.shift.add_tip!(diff)
    
  end

  #remove the tip
  def remove_tip_from_shift
    self.shift.add_tip!(-self.amount_for_employee)
  end

  def sale_in_shift
    shift_range = self.shift.created_at..(self.shift.finished_at || Time.zone.now)
    errors.add(:shift_id, "The pools sale must ahve taken place during pooled employee's shift") if !shift_range.cover?(self.sale.created_at)
  end
end
