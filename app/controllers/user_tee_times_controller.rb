class UserTeeTimesController < ApplicationController

  def create
    @user_tee_time = UserTeeTime.new
    authorize @user_tee_time
    @tee_time = TeeTime.find_by_id(params[:user_tee_time][:tee_time_id])
    @user = User.find_by_id(params[:user_tee_time][:user_id])
    if @tee_time.add_user(@user)
      render json: @tee_time.user_tee_times.last
    else
      flash[:warning] = @tee_time.user_tee_times.last.errors.full_messages.first
      redirect_to tee_time_path(@tee_time)
    end
  end

  def update
    @user_tee_time = UserTeeTime.find_by_id(params[:id])
    authorize @user_tee_time
    params[:operation] == '1' ? @user_tee_time.add_guest : @user_tee_time.remove_guest
    if (params[:operation] == '1' || params[:operation] == '-1') && @user_tee_time.save
      render json: UserTeeTime.find_by_id(params[:id])
    else
      flash[:confirmation] = "Uh oh, something went wrong"
      redirect_to tee_time_path(@user_tee_time.tee_time)
    end

  end

  def destroy
    @user_tee_time = UserTeeTime.find_by_id(params[:id])
    authorize @user_tee_time
    tee_time = @user_tee_time.tee_time
    @user_tee_time.destroy
    if tee_time.users.empty?
      flash[:confirmation] = "Successfully left and deleted Tee Time"
      tee_time.comments.destroy_all
      tee_time.destroy
      redirect_to user_path(current_user)
    else
      render json: tee_time
    end
  end

  private

  def user_tee_time_params
    params.require(:user_tee_time).permit(:tee_time_id, :user_id)
  end

end
