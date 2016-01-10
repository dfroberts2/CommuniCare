class LoginsController < ApplicationController

  def new
    @login = Login.new
  end

  def create
    if params[:login][:loginable_type] == "PrimaryCaregiver"
      caregiver = PrimaryCaregiver.create(about_me: "")
      @login = Login.new(login_params)
      @login.loginable_id = caregiver.id
      @login.loginable_type = "PrimaryCaregiver"
    else
      caregiver = OnCallCaregiver.create(about: "")
      @login = Login.new(login_params)
      @login.loginable_id = caregiver.id
      @login.loginable_type = "OnCallCaregiver"
    end

    if @login.save
      flash[:notice] = 'You Are Now Registered!'
      session[:login_id] = @login.id
      binding.pry
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    pcc = PrimaryCaregiver.find_by(id: params[:id])
    pcc.login
    pcc.login.update_attributes(pcc_login_params)
      if pcc.save
        redirect_to root_path
      else
        redirect_to primary_caregiver_path(primary_caregiver.id)
      end
      occ = OnCallCaregiver.find_by(id: params[:id])
     occ.login.update_attributes(pcc_login_params)
        if occ.save
      return root_path
    else
      return on_call_caregiver_path(on_call_caregiver.id)
    end
  end

  def edit
    @pcc = PrimaryCaregiver.find_by(id: params[:id])
    @occ = OnCallCaregiver.find_by(id: params[:id])
  end

private

  def login_params
    params.require(:login).permit(:email,:address,:city, :state, :password, :zipcode, :phone, :first_name, :last_name)
  end

  def pcc_login_params
      params.require(:login).permit(:first_name,:last_name,:address,:city,:state,:phone)
  end
  def occ_login_params
      params.require(:login).permit(:first_name,:last_name,:address,:city,:state,:phone)
  end
end
