require "ravendb/api/client/version"

module Ravendb
  module Api
    module Client
      class Client
      # here
        attr_reader :url

        def initialize(url: url)
          @url = url
        end
      end
    end
  end
end
