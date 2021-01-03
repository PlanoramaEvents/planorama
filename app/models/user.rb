#
#
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :trackable
         # :confirmable # allow the user to confirm and set their password

  validates_uniqueness_of :username, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validates_uniqueness_of :email, uniqueness: { case_sensitive: false }

  #
  # TODO - change the role and access control mechanism
  #
  has_many  :user_role_assignments, dependent: :delete_all
  has_many  :user_roles, through: :user_role_assignments

  # Put this in means that person needs to exist ...
  # So either link of create a new person when a user is created ....
  # belongs_to :person

  attr_writer :login

  def login
    @login || self.username || self.email
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["username = :value OR email = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
