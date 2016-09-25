class UsersController < SailsController
  def create
    # byebug
    @user = User.new(username: params["user"]["username"])
    # byebug
    if params["user"]["name"] != "" || params["user"]["password"] != ""
      @user.password = params["user"]["password"]
      @user.save
      login!(@user)
      redirect_to "/"
    else
      flash.now[:errors] = ["Name must be present"]
      render :new
    end
  end


  def new
    @user = User.new
    render :new
  end

end
