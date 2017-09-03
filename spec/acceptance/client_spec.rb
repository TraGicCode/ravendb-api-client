require 'spec_helper_acceptance'
require "ravendb/api/client"

describe 'client' do

    let(:client) { Ravendb::Api::Client.new(url: 'http://localhost:8081')  }

    it 'creates a database' do
        # Arrange
        # Act
        client.create_database(name: 'development')

        # Assert
        expect(client.database_exists?(name: 'development')).to eq(true)
    end
end