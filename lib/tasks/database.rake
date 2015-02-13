namespace :db do
  namespace :data do

    desc 'Dump current database to db/dumps'
    task :dump => :environment do
      db_config = Rails.application.config.database_configuration[Rails.env]
      file_name = File.join(Rails.root, 'db', 'data.dump')

      `pg_dump -x -f #{Shellwords.escape(file_name)} #{db_config['database']}`
      raise 'Error dumping database' if $?.exitstatus == 1
      puts "Dump saved to #{file_name}"
    end

    desc 'Restore the last dump from db/dumps'
    task :restore => :environment do
      file_name = File.join(Rails.root, 'db', 'data.dump')
      db_config = Rails.application.config.database_configuration[Rails.env]
      exit unless Rails.env.development?

      `dropdb #{db_config['database']}`
      `createdb #{db_config['database']}`
      `psql -d #{db_config['database']} -f #{Shellwords.escape(file_name)}`
      raise 'Error restoring database' if $?.exitstatus == 1
      puts 'Database Restored'
    end

    task :setup => %w(db:create db:data:restore db:migrate)
    task :reset => %w(db:drop db:data:setup)
  end
end
