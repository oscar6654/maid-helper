class EmailNotifMailer < ApplicationMailer

  def email_notif(first_name, title_job, email, user_id)
    @applicant_name = first_name
    @title_job = title_job
    @user_email = email
    @user_id = user_id
    mail(
      to: @user_email,
      subject: 'Helper ' + @applicant_name + ' have just applied for ' + @title_job
    )
  end

end
