class PublicationStatus < ApplicationRecord
  validates_inclusion_of :status, in: %i[inprogress completed]

  def status
    read_attribute(:status).to_sym
  end

  def status=(value)
    write_attribute(:status, value.to_s)
  end
end
