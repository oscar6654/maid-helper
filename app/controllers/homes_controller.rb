class HomesController < ApplicationController
  def index
    if current_user
      @user = User.friendly.find(current_user.id)
      @state = User::STATE
      @rating = User::RATE
      @gender = User::GENDER
    else

    end
  end
end
