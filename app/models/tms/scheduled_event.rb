module TMS
  class ScheduledEvent

    attr_reader :cinema

    def initialize(cinema, data)
      @cinema, @data = cinema, data
    end

    def tms_id
      @tms_id ||= @data['TMSId']
    end

    def day
      @day ||= @data['date'].to_date
    end 

    def times
      return unless @data['times']
      @data['times']['time'].to_a
    end

    def show_times
      daily_schedule.show_times.find_or_create_by tms_id: tms_id 
    end

    def daily_schedule
      @daily_schedule ||= cinema.find_or_create_daily_schedule(day.to_s)
    end

    def program
      @program ||= Program.find tms_id
    end

    def update_show_times
      show_times.tap do | show| 
        show.film_id = program.film_id if program
        show.times = times
        show.title = program.title
        show.release_date = program.release_date
        show.rating = program.bbfc_rating
        show.save
      end
    end


  end
end