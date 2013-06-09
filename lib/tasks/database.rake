namespace :database do
  
    desc "Copy production database to local"
    task :sync => :environment do
      system 'mongodump --host juliet.mongohq.com:10028 -db app10709075 -u heroku -p1f3a4d378314afec6f72e24e06503285 -o db/backups/'
      system 'mongorestore -h localhost --drop -d filmlovers_development db/backups/app10709075/'
    end
  
  end