require_relative '../app/controllers/sails_controller.rb'

Dir["./app/controllers/*_controller.rb"].each { |file| require file }

require_relative '../app/models/sail_record_base_model.rb'
Dir["./app/models/*_model.rb"].each {|file| require file }
