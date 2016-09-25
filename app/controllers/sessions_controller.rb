class SessionsController < SailsController
  def create
    @user = User.find_by_credentials(params["user"]["username"], params["user"]["password"])
    if @user
      login!(@user)
      redirect_to "/notes"
    else
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end


  def new
    @user = User.new
    render :new
  end

  def destroy
    logout!
    redirect_to "/session/new"
  end
end
