class HomesController < ApplicationController
  before_action :verify_user
  def index
    # session[:modal] = false
    if current_user && current_user.employee? || current_user && current_user.admin?
      @user = User.friendly.find(current_user.id)
      @state = User::STATE
      @rating = User::RATE
      @gender = User::GENDER
      @jobs = Job.where(["work_location =? and job_closed =?", current_user.preffered_location, false]).paginate(page: params[:page], per_page: 8)
      # binding.remote_pry
    elsif current_user && current_user.employer? || current_user && current_user.admin?
      @applicants = current_user.applicants.paginate(page: params[:page], per_page: 8)
    else
      # @jobs = Job.where(["work_location =? and job_closed =?", current_user.preffered_location, false]).paginate(page: params[:page], per_page: 7)
    end
  end

  def verify_user
    if user_signed_in?
      if !current_user.is_verified
        redirect_to new_user_verification_path
      end
    end
  end

end
