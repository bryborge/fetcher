# frozen_string_literal: true

class FetchRequest < ActiveRecord::Base
  validates :url, presence: true
  validates :requested_by, presence: true
end
