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

        def database_exists?(name:)
          databases.include?(name)
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
        # test(options: { Settings: 'test'})
        # test(options: { :Settings => 'test'})
        def create_database(name:, options: {})
          default_options = {
            Settings: { 
              'Raven/ActiveBundles': '', 
              'Raven/DataDir': "~/#{name}" 
            }, 
            Disabled: false
          }

          create_database_options = default_options.merge(options)

          res = Net::HTTP.start(@url.host, @url.port) do |http|
            req = Net::HTTP::Put.new(create_delete_database_endpoint() + "#{name}", 'Content-Type' => 'application/json')
            binding.pry
            # { Settings: '', Go: 'test' }.class
            # This is a hash  
            # This is also a hash.  not sure which one to use
            # { :Settings => 'd', :Go: 'test' }.class
            req.body = create_database_options.to_json
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
