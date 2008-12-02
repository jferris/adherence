ENV['RAILS_ENV'] = 'test'

require File.join(File.dirname(__FILE__), "rails_root", "config", "environment.rb")
require 'spec'
require 'spec/rails'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'adherence'

# Run the migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")

