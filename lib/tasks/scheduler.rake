desc "This task is called by the Heroku scheduler add-on"
task :create_week => :environment do
  #week = Week.new(date_started: Time.now.beginning_of_week(start_day = :sunday))
  #puts week.save ? "week successfully created" : "week creation failed"

  begin
    Week.create_current_week!
    puts "Success"
  rescue ActiveRecord::RecordInvalid => invalid
    invalid.record.errors.full_messages.each do |error_message|
      puts error_message
    end

  end
end