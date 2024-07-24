# frozen_string_literal: true

# Fetch Request Model
#
# @attr [String] url The URL to fetch.
# @attr [String] requested_by The user who requested the fetch.
# @attr [String] status The status of the fetch.
# @attr [String] storage_url The URL of the stored HTML document.
class FetchRequest < ActiveRecord::Base
  validates :url, presence: true
  validates :requested_by, presence: true
end
