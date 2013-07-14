module TMS
  class Theatre

    def initialize(data)
      @data = data
    end

    def self.import(file)
      json = Utilities.file_to_json(file)
      json['on']['sources']['theatres']['theatre'].map {|t| new(t).cinema}
    end

    def postal_code
      @data['address']['postalCode']
    end

    def cinema
      @cinema ||= Cinema.find_by('address.postalCode'=> postal_code) || Cinema.create(@data)
    end

  end
end