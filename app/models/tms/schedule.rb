module TMS
  class Schedule

    def initialize(data)
      @data = data
    end

    def self.load(file)
      json = Utilities.file_to_json(file)
      json['on']['schedules']['schedule'].map {|schedule| new schedule}
    end

    def self.import(file)
      schedules = load file
      schedules.each do |s|        
        s.events.each(&:update_show_times) if s.events
      end
    end

    def theatre_id
      @theatre_id ||= @data['theatreId']
    end

    def cinema
      @cinema ||= Cinema.find_by_tms_id(theatre_id)
    end

    def events
      return unless cinema
      @events ||= @data['event'].map {|e| TMS::ScheduledEvent.new cinema, e}
    end

  end
end