class Position < ApplicationRecord
  #validations
  validates :name, presence: true
  validates_inclusion_of :associate_with_tip, in: [true, false]
  validates :solo_associated_tip_percentage, presence: true, if: :associated?
  validates :multi_associated_tip_percentage, presence: true, if: :associated?

  #converts human format to decimal
  before_save :set_percentage, if: :percentage_changed? 


  private
  def set_percentage
    if associated?
      self.solo_associated_tip_percentage = (solo_associated_tip_percentage || 0) / 100
      self.multi_associated_tip_percentage = (self.multi_associated_tip_percentage || 0) / 100
    else
      self.solo_associated_tip_percentage = nil
      self.multi_associated_tip_percentage = nil
    end
  end

  def percentage_changed?
    self.solo_associated_tip_percentage_changed? || self.multi_associated_tip_percentage_changed? 
  end

  def associated?
    self.associate_with_tip
  end
end
