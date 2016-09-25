require_relative '../lib/connections/router.rb'

ROUTER_CONFIG = Router.new


ROUTER_CONFIG.draw do
  get Regexp.new("^/$"), NotesController, :index
  get Regexp.new("^/notes$"), NotesController, :index
  get Regexp.new("^/notes/new$"), NotesController, :new
  get Regexp.new("^/notes/(?<id>\\d+)$"), NotesController, :show
  delete Regexp.new("^/notes$"), NotesController, :destroy
  post Regexp.new("^/notes$"), NotesController, :create

  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create

  get Regexp.new("^/session/new$"), SessionsController, :new
  post Regexp.new("^/session$"), SessionsController, :create
  delete Regexp.new("^/session$"), SessionsController, :destroy

end
