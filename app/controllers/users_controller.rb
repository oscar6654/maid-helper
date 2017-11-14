class UsersController < ApplicationController
  before_action :verify_user
  def index
    session[:modal] = false
    if current_user.admin?
      @users = User.all
    end
  end
  def show
    session[:modal] = false
    if current_user.admin?
     @user = User.friendly.find(params[:id])
     @user_jobs = @user.jobs.paginate(page: params[:page], per_page: 10)
     @job_applied = @user.applicants.paginate(page: params[:page], per_page: 10)
    elsif current_user && current_user.employer?
     @user = User.friendly.find(current_user[:id])
     @user_jobs = @user.jobs.paginate(page: params[:page], per_page: 10)
    elsif current_user && current_user.employee?
     @user = User.friendly.find(current_user[:id])
     @job_applied = @user.applicants.paginate(page: params[:page], per_page: 10)
    #  @user_jobs = @user.jobs.paginate(page: params[:page], per_page: 10)

    end
  end

  def edit
    session[:modal] = false
    if current_user.admin?
      @user = User.friendly.find(params[:id])
      @state = User::STATE
      @rating = User::RATE
      @gender = User::GENDER
    elsif current_user
      @user = User.friendly.find(current_user[:id])
      @state = User::STATE
      @rating = User::RATE
      @gender = User::GENDER
    end
  end

  def update
    session[:modal] = false
    @user = User.friendly.find(params[:id])
    if @user.update_attributes(edit_user_params)
      redirect_to user_path(@user), notice: "User Info Updated"
    else
      redirect_to user_path(@user), notice: "Failed to Update!"
    end
  end

  def destroy
    if current_user.admin?
      @user = User.friendly.find(params[:id]).destroy
      redirect_to users_path, notice: "User Deleted"
    end
  end
  def customize
    if current_user
      session[:modal] = false
       @user = User.friendly.find(params[:id])
       @state = User::STATE
       @rating = User::RATE
       @gender = User::GENDER
    end
  end

  def u_customize
    if current_user
      session[:modal] = false
      @user = User.friendly.find(params[:id])
      # binding.remote_pry
      # @user.remove_proof!
      # @user.save
      # binding.remote_pry
      trimmed_number = params[:user][:mobile_number].tr('^A-Za-z0-9', '')
      if current_user.mobile_number != trimmed_number
        # binding.remote_pry
        # trimmed_number = params[:user][:mobile_number].tr('^A-Za-z0-9', '')
        @user.update_attributes(is_verified: false, mobile_number: trimmed_number)
      end
      if @user.update_attributes(customize_user)
        redirect_to root_url, notice: "Profile Updated"
      else
        redirect_to root_url, notice: "Failed to Update"
      end
    end
  end

  def verify_user
    if user_signed_in?
      if !current_user.is_verified
        redirect_to new_user_verification_path
      end
    end
  end

  private
  def customize_user
    params.require(:user).permit(:profile_photo, :proof, :cooking_skills, :cleaning_skills, :dialect, :current_location, :age, :gender, :dialect, :preffered_location, :additional_desc)
  end

  def edit_user_params
    params.require(:user).permit(:first_name, :last_name, :profile_photo)
  end
end
