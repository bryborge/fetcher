# frozen_string_literal: true

class HtmlFetcher
  def initialize(strategy)
    @strategy = strategy
  end

  def fetch(url)
    @strategy.fetch(url)
  end
end
