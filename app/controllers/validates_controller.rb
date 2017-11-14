class ValidatesController < ApplicationController
  def index
    if current_user && current_user.admin?
    else
      redirect_to root_url, notice: "No Access Rights"
    end
  end
end
