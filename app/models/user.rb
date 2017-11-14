class User < ApplicationRecord
  extend FriendlyId
  # filter_parameter_logging :verification_code
  friendly_id :first_name, use: :slugged
  attr_accessor :login
  has_many :jobs, dependent: :destroy
  has_many :applicants, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :verifiable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  #  validates :mobile_number, presence: true
  #  validates :verification_code, presence: true
   validates_uniqueness_of :mobile_number
   validates :mobile_number, phone: { possible: false, allow_blank: true, types: [:mobile] }
   validates :first_name, presence: true
  #  validates :last_name, presence: true
   validates :job_type, presence: true
   validates :username, uniqueness: true
  #  verify_fields :verification_code
   #USERNAME FIELD
   def self.find_for_database_authentication warden_conditions
     conditions = warden_conditions.dup
     login = conditions.delete(:login)
     where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
   end
   #####

   #MOBILE SMS#

  def needs_mobile_number_verifying?
    #  binding.remote_pry
    if is_verified
      return false
    end
    if mobile_number.blank?
      return false
    end
    if !verification_code.blank?
      return false
    end
    return true
  end

  def resend_code?
    if verification_code.blank?
      return false
    end
    return true
  end

  def mobile_number_filled?
    if mobile_number.blank?
      return true
    end
    return false
  end
   ###########

  mount_uploader :profile_photo, ProfilePhotoUploader
  mount_uploader :proof, ProofUploader


  STATE = [
    ["Armm", "Armm"],
    ["Bicol Region", "Bicol Region"],
    ["C.A.R", "C.A.R"],
    ["Cagayan Valley", "Cagayan Valley"],
    ["Calabarzon & Mimaropa", "Calabarzon & Mimaropa"],
    ["Central Luzon", "Central Luzon"],
    ["Caraga", "Caraga"],
    ["Central Visayas", "Central Visayas"],
    ["Davao", "Davao"],
    ["Eastern Visayas", "Eastern Visayas"],
    ["Ilocos Region", "Ilocos Region"],
    ["National Capital Reg", "National Capital Reg"],
    ["Northen Mindano", "Northen Mindano"],
    ["Soccsksargen", "Soccsksargen"],
    ["Western Visayas", "Western Visayas"],
    ["Zamboanga", "Zamboanga"]
  ]
  RATE = [
    ["POOR", "POOR"],
    ["BELOW AVERAGE", "BELOW AVERAGE"],
    ["AVERAGE", "AVERAGE"],
    ["GOOD", "GOOD"],
    ["EXCELLENT", "EXCELLENT"],
  ]
  GENDER = [
    ["Male", "Male"],
    ["Female", "Female"]
  ]

  def admin?
    admin == true
  end

  def employee?
    job_type == "Employee"
  end

  def employer?
    job_type == "Employer"
  end
  protected

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions attributes = {}
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors required_attributes, attributes, error = :invalid
    (case_insensitive_keys || []).each {|k| attributes[k].try(:downcase!)}

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if {|_key, value| value.blank?}

    if attributes.size == required_attributes.size
      if attributes.key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = where(attributes).first
      end
    end

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

  def self.find_record login
    where(["username = :value OR email = :value", {value: login}]).first
  end
end
