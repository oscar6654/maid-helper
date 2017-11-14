class Api::V1::ValidatesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    if current_user && current_user.admin?
      render json: User.where(["proof != ? and proof_verified != ?", "nil","true"])
    else
      redirect_to root_url, notice: "No Access Rights"
    end
  end

  def update
    if current_user && current_user.admin?
      data = JSON.parse(request.body.read)
      User.find(data["id"]).update_attributes(proof_verified: true)
      render json: User.where(["proof != ? and proof_verified != ?", "nil","true"])
    end
  end

  def destroy
    if current_user && current_user.admin?
      data = JSON.parse(request.body.read)
      @user = User.find(data["id"])
      @user.remove_proof!
      @user.save
      render json: User.where(["proof != ? and proof_verified != ?", "nil","true"])
    end
  end
end
