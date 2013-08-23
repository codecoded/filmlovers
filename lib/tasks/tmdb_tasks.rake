namespace :tmdb do


  task :update_changes, [:start_date, :page_no] => :environment do |t, args|
    start_date = args[:start_date] ? eval(args[:start_date]) : 36.hours.ago
    Tmdb::Admin.update_changes start_date, args[:page_no].blank? ? 1 : args[:page_no].to_i
  end

  task :fetch_all, [:starting_id] => :environment do |t, args|
    Tmdb::Admin.fetch_all args[:starting_id].to_i
  end


end