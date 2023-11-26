# == Schema Information
#
# Table name: formats
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  name         :string           not null
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
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
