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
          get(url: @url + get_databases_endpoint())
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
          put(url: @url + create_delete_database_endpoint() + name, json_hash: create_database_options)
        end
        # Invoke-RestMethod -Uri http://$($HostName):$($Port)/admin/databases/$RavenDatabaseName`?hard-delete=true -Method Delete
        def delete_database(name:)
          delete(url: @url + create_delete_database_endpoint() + name)
        end

        private
        def create_delete_database_endpoint
          return '/admin/databases/'
        end

        def get_databases_endpoint
          return '/databases'
        end


        def get(url:)
          _url = URI(url)
          http = Net::HTTP.new(_url.host, _url.port)
          req = Net::HTTP::Get.new(_url.request_uri)
          res = http.request(req)
          check_response(res)
          JSON.parse(res.body)
        end

        def put(url:, json_hash:)
          _url = URI(url)
          http = Net::HTTP.new(_url.host, _url.port)
          req = Net::HTTP::Put.new(_url.request_uri, 'Content-Type' => 'application/json')
          # These are hashes
          # They're equivalent. The second one is a more compact style that's common since lots of hashes have symbols for keys.
          # { :Settings => 'd', :Go: 'test' }.class
          # { Settings: '', Go: 'test' }.class
          req.body = json_hash.to_json
          check_response(http.request(req))
        end
        
        def delete(url:)
          _url = URI(url)
          http = Net::HTTP.new(_url.host, _url.port)
          req = Net::HTTP::Delete.new(_url.request_uri)
          check_response(http.request(req))
        end
        # TODO: Create post wrapper

        def check_response(response)
          case response
          when Net::HTTPSuccess
            return
          else
            raise RuntimeError, "Request failed with an HTTP status code of #{response.code} and a message of #{response.body}."
          end
        end


    end
  end
end
