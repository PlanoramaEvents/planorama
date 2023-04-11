# frozen_string_literal: true
# Exttracted from devise-security so we are compatible with newer ruby and rails for now
module PasswordArchivable
  extend ActiveSupport::Concern

  included do
    has_many :old_passwords, class_name: 'OldPassword', as: :password_archivable, dependent: :destroy
    before_update :archive_password, if: :will_save_change_to_encrypted_password?
    validate :validate_password_archive, if: :password_present?
  end

  delegate :present?, to: :password, prefix: true

  def validate_password_archive
    errors.add(:password, :taken_in_past) if will_save_change_to_encrypted_password? && password_archive_included?
  end

  # @return [Integer] max number of old passwords to store and check
  def max_old_passwords
    5
  end

  # validate if the password was used in the past
  # @return [true] if current password was used previously
  # @return [false] if disabled or not previously used
  def password_archive_included?
    return false unless max_old_passwords.positive?

    old_passwords_including_cur_change = old_passwords.reorder(created_at: :desc).limit(max_old_passwords).pluck(:encrypted_password)
    old_passwords_including_cur_change << encrypted_password_was # include most recent change in list, but don't save it yet!
    old_passwords_including_cur_change.any? do |old_password|
      self.class.new.tap { |object| object.encrypted_password = old_password }.valid_password?(password)
    end
  end

  private

  # Archive the last password before save and delete all to old passwords from archive
  # @note we check to see if an old password has already been archived because
  #   mongoid will keep re-triggering this callback when we add an old password
  def archive_password
    if max_old_passwords.positive?
      return true if old_passwords.where(encrypted_password: encrypted_password_was).exists?

      old_passwords.create!(encrypted_password: encrypted_password_was) if encrypted_password_was.present?
      old_passwords.reorder(created_at: :desc).offset(max_old_passwords).destroy_all
    else
      old_passwords.destroy_all
    end
  end
end
