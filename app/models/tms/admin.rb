module TMS
  module Admin
    extend self

    def process_theatres(file)
      Theatre.import(file)
    end

    def process_programs(file)
      Program.import(file)
    end

    def process_schedules(file)
      Schedule.import(file)
    end

    def process_week(date)
      process_theatres  "onconnect/uk/#{date}/on_uk_samp_mov_sources_#{date}.xml"
      process_programs  "onconnect/uk/#{date}/on_uk_samp_mov_programs_#{date}.xml"
      process_schedules "onconnect/uk/#{date}/on_uk_samp_mov_schedules_#{date}.xml"
    end
  end
end