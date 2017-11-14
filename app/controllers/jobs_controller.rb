class JobsController < ApplicationController
  before_action :find_job, only: [:show, :edit, :update, :destroy]
  def new
    if current_user.admin? && current_user || current_user && current_user.employer?
      @job = Job.new
      @state = User::STATE
    end
  end
  def destroy
    if current_user.admin? && current_user
      if @job.update_attributes(job_closed: true)
        redirect_to root_url, notice: "Job Closed!"
      end
    elsif @job.user_id == current_user.id
      if @job.update_attributes(job_closed: true)
        redirect_to user_path(@job.user_id), notice: "Job Closed!"
      end
    end
  end

  def search
    query = "%#{params[:query]}%"
    @search = query
    @jobs_search = Job.text_search(params[:query])
    @jobs = @jobs_search.where("job_closed != ?", true).paginate(page: params[:page], per_page: 15)
    # @jobs = Job
    #   .where('title ilike ? or job_description ilike ? or work_location ilike ?',
    #          query, query, query).paginate(page: params[:page], per_page: 15)
  end

  def create
    if current_user.admin? && current_user || current_user && current_user.employer?
      @job = Job.new({user_id: current_user.id}.merge!(job_params))
      if @job.save
        redirect_to job_path(@job), notice: "Job Posted!"
      else
        redirect_to root_path, notice: "Failed to Post Job"
      end
    end
  end
  def edit
    if current_user.admin? && current_user
      @job_edit = Job.find(params[:id])
      @state = User::STATE
    elsif @job.user_id == current_user.id
      @job_edit = Job.find(params[:id])
      @state = User::STATE
    end
  end
  def update
    @job_update = Job.find(params[:id])
    # binding.remote_pry
    if @job_update.update_attributes(job_params)
      redirect_to job_path(@job_update), notice: "Job Updated!"
    end
  end
  def show
    if current_user && current_user.employee?
      @applied = Applicant.exists?(user_id: current_user.id, job_id: @job.id)
      @application = Applicant.new
      @job = Job.find(params[:id])
      @job_poster = @job.user
      @job_applicants = @job.applicants
    elsif current_user.admin? && current_user || @job.user_id == current_user.id
      @applied = Applicant.exists?(user_id: current_user.id, job_id: @job.id)
      @application = Applicant.new
      @job = Job.find(params[:id])
      @job_poster = @job.user
      @job_applicants = @job.applicants
    end
  end
  private

  def find_job
      @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :work_location, :job_description, :text_notifications, :email_notifications)
  end
end
