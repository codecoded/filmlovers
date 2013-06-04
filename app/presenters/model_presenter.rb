class ModelPresenter

  def self.present(film, &block)
    yield film
  end
end