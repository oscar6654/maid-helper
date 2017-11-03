class UsersController < ApplicationController
  def index
    if current_user.admin?
      @users = User.all
    end
  end
  def show
    if current_user.admin?
     @user = User.friendly.find(params[:id])
    elsif current_user
     @user = User.friendly.find(current_user[:id])
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
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
       @user = User.friendly.find(params[:id])
       @state = User::STATE
       @rating = User::RATE
       @gender = User::GENDER
    end
  end

  def u_customize
    if current_user
      @user = User.friendly.find(params[:id])
      binding.remote_pry
      if @user.update_attributes(customize_user)
        redirect_to root_url, notice: "Profile Added"
      else
        redirect_to root_url, notice: "Failed to Update"
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
