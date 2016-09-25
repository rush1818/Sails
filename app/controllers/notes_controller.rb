require 'byebug'

class NotesController < SailsController
  def create
    @note = Note.new(params["note"])
    if params["note"]["name"] != ""
      @note.save
      flash[:notice] = "Saved note successfully"
      redirect_to "/notes"
    else
      flash.now[:errors] = ["Name must be present"]
      render :new
    end
  end

  def index
    if current_user
      @notes = Note.all
      @current_user = current_user
      render :index
    else
      redirect_to "/session/new"
    end
  end

  def new
    if current_user
      @note = Note.new
      render :new
    else
      redirect_to "/session/new"
    end
  end

  def show
    if current_user
      @note = Note.find(params["id"])
      render :show
    else
      redirect_to "/session/new"
    end
  end

  def destroy
    if current_user
      @note = Note.find(params["id"])
      @note.delete
      redirect_to "/"
    else
      redirect_to "/session/new"
    end
  end

end
