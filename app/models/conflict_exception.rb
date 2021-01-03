# require 'planner_utils'
class ConflictException < ApplicationRecord
  validates_inclusion_of :conflict_type,
                         in: %i[schedule room item avail time back2back]

  # before_save do |el|
  #   el.idx = PlannerUtils.calculate_pairing(PlannerUtils.calculate_pairing(el.affected, el.src1), el.src2)
  # end
  #
  def conflict_type
    read_attribute(:conflict_type).to_sym
  end

  def conflict_type=(value)
    write_attribute(:conflict_type, value.to_s)
  end
end
