class Format < ApplicationRecord
  has_many :programme_items
  has_many :published_programme_items

  before_destroy :check_for_use

  private

  def check_for_use
    if ProgrammeItem.where(format_id: id).exists? ||
       PublishedProgrammeItem.where(format_id: id).exists?
      raise 'can not delete a format that is being used'
    end
  end
end
