class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #
  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def google_oauth2
    auth = request.env['omniauth.auth']
    # binding.pry
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user
      set_flash_message(:notice, :success, kind: "Google")
      sign_in_and_redirect(user, event: :authentication)
    # return sign_in_and_redirect(user, event: :authentication) if user
    else
      # binding.remote_pry
      session['devise.google_oauth2_data'] = request.env["omniauth.auth"].except("extra")
      redirect_to u_finish_signup_google_path
    end
  end
  def finish_signup_google
    @auth = session['devise.google_oauth2_data']
  end
  def finished_signup_google
    @auth = session['devise.google_oauth2_data']

    user = User.new(provider: @auth['provider'], uid: @auth['uid'],
                    email: @auth['info']['email'],
                    first_name: @auth['info']['name'],
                    password: Devise.friendly_token[0,20],
                    job_type: params[:job_type])
    # binding.remote_pry
    if user.save
      # user.migrate_session_records(session.id)

      session['devise.google_oauth2_data'] = nil
      set_flash_message(:notice, :success, kind: "Google")
      sign_in_and_redirect user, event: :authentication
      # redirect_to root_path
    else
      flash[:alert] = 'Please Provide Job Type or Email already exist'
      render :finish_signup_google
    end
  end

  def facebook
    auth = request.env['omniauth.auth']
    # binding.pry
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user
      set_flash_message(:notice, :success, kind: "Facebook")
      sign_in_and_redirect(user, event: :authentication)
    # return sign_in_and_redirect(user, event: :authentication) if user
    else
      # binding.remote_pry
      session['devise.facebook_data'] = auth
      redirect_to u_finish_signup_path
    end
  end

  def finish_signup
    @auth = session['devise.facebook_data']
  end

  def finished_signup
    @auth = session['devise.facebook_data']

    user = User.new(provider: @auth['provider'], uid: @auth['uid'],
                    email: @auth['info']['email'],
                    first_name: @auth['info']['name'],
                    password: Devise.friendly_token[0,20],
                    job_type: params[:job_type])
    # binding.remote_pry
    if user.save
      # user.migrate_session_records(session.id)

      session['devise.facebook_data'] = nil
      set_flash_message(:notice, :success, kind: "Facebook")
      sign_in_and_redirect user, event: :authentication
      # redirect_to root_path
    else
      flash[:alert] = 'Please Provide Job Type or Email already exist'
      render :finish_signup
    end
  end

  def failure
    redirect_to root_path
  end
end


# end
