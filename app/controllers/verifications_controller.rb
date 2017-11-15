class VerificationsController < ApplicationController
  require 'httparty'
  require 'addressable/uri'
  attr_accessor :send_message
  def mobile
    # binding.remote_pry
    mobile_num = params[:verification_code]
    trimmed_number = mobile_num.tr('^A-Za-z0-9', '')
    if trimmed_number.length > 13
      redirect_to new_user_verification_path, notice: "Enter Correct Number"
    end
    current_user.mobile_number = trimmed_number
    current_user.verification_code = nil
    current_user.save
    redirect_to new_user_verification_path
  end
  def delete_number
    current_user.mobile_number = nil
    current_user.verification_code = nil
    # binding.remote_pry
    current_user.save
    redirect_to new_user_verification_path, notice: "Enter New Number"
  end

  def send_message(message: nil, number: nil)
    uri     = Addressable::URI.new

    options = {
      apikey:     ENV['SEMAPHORE_API_KEY'],
      number:     number,
      message:    message,
      sendername: ENV['SEMAPHORE_SENDERNAME']
    }

    uri.query_values = options
    path = "http://api.semaphore.co/api/v4/messages?#{uri.query}"

    response = HTTParty.post(path)
  end

  def create
    current_user.verification_code =  1_000_000 + rand(10_000_000 - 1_000_000)
    current_user.save

    to = current_user.mobile_number
    if to[0] = "0"
      to.sub!("0", '+63')
    elsif tp[0] = "6"
      to.sub!("6", '+6')
    end
    send_message(message: "Welcome To House Helper #{current_user.first_name}! Please confirm your mobile number. Your verification code is #{current_user.verification_code}.",number: to)
    # @twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    # @twilio_client.account.sms.messages.create(
    #   :from => ENV['TWILIO_PHONE_NUMBER'],
    #   :to => to,
    #   :body => "WELCOME TO House Helper! Please confirm your mobile number. Your verification code is #{current_user.verification_code}."
    # )
    redirect_to new_user_verification_path, :flash => { :success => "A verification code has been sent to your mobile. Please fill it in below." }
    # redirect_to edit_user_registration_path, :flash => { :success => "A verification code has been sent to your mobile. Please fill it in below." }
    return
  end

  def verify
        if current_user.verification_code == params[:verification_code]
        current_user.is_verified = true
        current_user.verification_code = ''
        current_user.save
        redirect_to root_path, :flash => { :success => "Thank you for verifying your mobile number." }
        return
      else
        redirect_to new_user_verification_path, :flash => { :errors => "Invalid verification code." }
        return
      end
  end

end
