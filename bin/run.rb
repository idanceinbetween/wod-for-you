require_relative '../config/environment'
require 'sinatra/activerecord/rake'
require_all 'app'

cli = CLI.new
cli.start
