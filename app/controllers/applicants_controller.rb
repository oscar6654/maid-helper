class ApplicantsController < ApplicationController
  require 'httparty'

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
    @job = Job.find(params[:job_id])
    if Applicant.exists?(user_id: current_user.id, job_id: @job.id)
      redirect_to @job, notice: "Already Applied"
    end
    @comments = params[:applicant][:comments]
    @application = @job.applicants.new(comments: @comments, user_id: current_user.id)
    if @application.save
      if @job.text_notifications
        send_message(message: "#{@application.user.first_name}, have applied for #{@job.title}.", number: "#{@application.user.mobile_number}") #{current_user.first_name}!)
      end
      if @job.email_notifications
        EmailNotifMailer.email_notif(@application.user.first_name, @job.title, @application.user.email, @application.user.id).deliver
      end
      redirect_to @job, notice: "Application Submitted"
    else
      redirect_to @job, notice: "Failed to Submit Application"
    end
  end


  private
  def application_params
    params.require(:applicant).permit(:comments)
  end
end
