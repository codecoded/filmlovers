module Utilities
  extend self

  def helpers
    @helpers ||= ActionController::Base.helpers
  end

  def to_currency(value, args={})
    helpers.number_to_currency(value.to_f, {unit:'$'}.merge(args))
  end

  def to_money(value, args={})
    Money.new(value)
  end

  def simplify(value)
    value > 99999 ? "#{(value / 1000)}K" : value
  end

  def humanize_number(value)
    helpers.number_to_human value.to_i
  end

  def url_helpers
    Filmlovers::Application.routes.url_helpers
  end

end