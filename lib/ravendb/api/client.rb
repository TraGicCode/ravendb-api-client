require "ravendb/api/client/version"
require 'net/http'
require 'json'
require 'pry'

# RavenDB HTTP Api
# https://ravendb.net/docs/article-page/3.5/http/client-api/commands/how-to/get-database-configuration
module Ravendb
  module Api
      class Client
        attr_reader :url

        def initialize(url:)
          @url = URI(url)
        end

        def databases
          response = Net::HTTP.get(URI(@url + get_databases_endpoint()))
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
          res = Net::HTTP.start(@url.host, @url.port) do |http|
            req = Net::HTTP::Put.new(create_delete_database_endpoint() + "#{name}", 'Content-Type' => 'application/json')

            req.body = {
              Settings: { 
                'Raven/ActiveBundles': '', 
                'Raven/DataDir': "~/#{name}" 
              }, 
              Disabled: false
            }.to_json
            http.request(req)
          end
        end

        def delete_database(name:)
          name
        end

        private
        def create_delete_database_endpoint
          return '/admin/databases/'
        end

        def get_databases_endpoint
          return '/databases'
        end

        # TODO: Create post wrapper
        # TODO: Create get wrapper


    end
  end
end
