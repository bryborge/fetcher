# frozen_string_literal: true

class BaseStrategy
  def fetch(url)
    raise NotImplementedError, 'You must implement the fetch method'
  end
end
