# frozen_string_literal: true

require_relative './config/environment'

use Rack::MethodOverride

# Controllers ------------------------------------------------------------------

# Add new controllers here.

map ('/') { run BaseApiController }
map ('/api/v1') { run FetchRequestsController }
