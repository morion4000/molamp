namespace :heroku do
  task :deploy do
    Rake::Task['heroku:push'].invoke
    Rake::Task['heroku:version'].invoke
  end
  
  task :push do
    puts "Deploying to Heroku..."
    sh "git push heroku master"
  end
  
  task :version do
    puts "Updating app version number on Heroku..."
    sh "heroku config:add rel=$(heroku releases | head -2 | tail -1 |awk '{print $6\".\"$7\".\"$1}')"
  end
end