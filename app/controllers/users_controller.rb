class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def dashboard
    @user = current_user
    @page_title = @user.name + "\'s Dashboard"
    require_user
    @patients = @user.patients.all.paginate(:page => params[:page])
  end


  def exportjson
    @user = User.find(params[:id])
    @patients = @user.patients.all

    respond_to do | f |
      f.html {
        if (@current_user != @user)
          redirect_to '/'
        else
          redirect_to 'dashboard'
        end
      }

      f.any(:xml, :json) {
        render request.format.to_sym => @user.patients.all
      }
    end
  end

  def exportpatient
    @patient = Patient.find(params[:id])


    respond_to do | f |
      f.html {
        if (@current_user != @user)
          redirect_to '/'
        else
          redirect_to 'dashboard'
        end
      }

      f.any(:xml, :json) {
        render request.format.to_sym => @patient
      }
    end
  end

  def importpatient
    @user = current_user

    Patient.update(params[:patient], :user_id => @user.id)

  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
