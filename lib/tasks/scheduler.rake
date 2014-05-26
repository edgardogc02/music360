desc "This tasks are called by the Heroku scheduler add-on"

task :remind_challenged_users => :environment do
  RemindChallengedUsersWorker.perform_async
end

task :remind_challenger_users => :environment do
  RemindChallengerUsersWorker.perform_async
end
