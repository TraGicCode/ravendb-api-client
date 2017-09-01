require "ravendb/api/client/version"
require 'net/http'
require 'json'
require 'pry'

module Ravendb
  module Api
      class Client
        attr_reader :url

        def initialize(url:)
          @url = url
        end

        def databases
          response = Net::HTTP.get(URI(@url + '/databases'))
          JSON.parse(response)
        end

        # $body = @{
        #     Settings = @{
        #     "Raven/DataDir" = "~\Databases\$RavenDatabaseName"
        # "Raven/ActiveBundles" = "PeriodicBackup;DocumentExpiration;SqlReplication"
        # }
        # Disabled = $false
        # }
        #
        # Invoke-RestMethod -Uri http://$($HostName):$($Port)/admin/databases/$RavenDatabaseName -Method PUT -Body (ConvertTo-Json $body)
        def create_database(name:)
          #
          req = Net::HTTP::Post.new(URI(@url + "/admin/databases/#{name}"), 'Content-Type' => 'application/json')
          req.body = {Settings: { }, Disabled: false}.to_json
          res = Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.request(req)
          end
        end


    end
  end
end
