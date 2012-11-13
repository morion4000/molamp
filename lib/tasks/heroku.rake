namespace :heroku do
  task :deploy do
    Rake::Task['heroku:test'].invoke
    Rake::Task['heroku:push'].invoke
    Rake::Task['heroku:version'].invoke
  end
  
  task :push do
    puts "Deploying to Heroku..."
    sh "git push heroku master"
  end
  
  task :version do
    puts "Updating app version number on Heroku..."
    sh "heroku config:add rel=" + Date.today.year.to_s + "/" + Date.today.month.to_s + "/" + Date.today.day.to_s + 
    "-$(heroku releases | head -2 | tail -1 | awk '{print $1}')"
  end
  
  task :test do
    puts "Running tests..."
    Rake::Task['test'].invoke
  end
end