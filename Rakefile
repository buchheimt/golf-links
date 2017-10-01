# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :reload do
  File.delete('db/development.sqlite3', 'db/schema.rb')
  Rake::Task["db:migrate"].invoke
  Rake::Task["test:prepare"].invoke
end