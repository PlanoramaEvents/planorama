class Format < ApplicationRecord
  has_many :sessions
  has_many :published_sessions

  before_destroy :check_for_use

  private

  def check_for_use
    if Session.where(format_id: id).exists? ||
       PublishedSession.where(format_id: id).exists?
      raise 'can not delete a format that is being used'
    end
  end
end
