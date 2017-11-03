class User < ApplicationRecord
  extend FriendlyId
  friendly_id :first_name, use: :slugged
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

   validates :first_name, presence: true
  #  validates :last_name, presence: true
   validates :job_type, presence: true
   validates :username, uniqueness: true

   def self.find_for_database_authentication warden_conditions
     conditions = warden_conditions.dup
     login = conditions.delete(:login)
     where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
   end
   def self.new_with_session(params, session)
     super.tap do |user|
       if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
         user.email = data["email"] if user.email.blank?
       end
     end
   end
   def self.from_omniauth(auth)
     where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
       user.email = auth.info.email
       user.password = Devise.friendly_token[0,20]
       user.first_name = auth.info.name   # assuming the user model has a name
       user.profile_photo = auth.info.image # assuming the user model has an image
       # If you are using confirmable and the provider(s) you use validate emails,
       # uncomment the line below to skip the confirmation emails.
       # user.skip_confirmation!
     end
   end

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
