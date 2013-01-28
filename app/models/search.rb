class Search
  include Mongoid::Document

  # def self.films(query, options={})
  #   find(query, :movie, options)
  # end

  # def self.persons(query, options={})
  #   find(query, :person, options)
  # end

  # def self.lists(query, options={})
  #   find(query, :list, options)
  # end

  # def self.companies(query, options={})
  #   find(query, :company, options)
  # end

  # def self.keywords(query, options={})
  #   find(query, :keyword, options)
  # end

  # def self.find(query, search_type=:movie, options={})
  #   SearchRepository.new(query, search_type, options ).find
  # end

  # def save!
  #   repository.save! doc
  # end

  # protected
  # def repository
  #   SearchRepository.new query, search_type
  # end
end