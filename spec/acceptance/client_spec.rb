require "ravendb/api/client"

describe 'client' do

    let(:client) { Ravendb::Api::Client.new(url: 'http://localhost:8081')  }

    before(:each) do
        # remove_all_databases(url: 'http://localhost:8081')
        client.databases.each { |db| client.delete_database(name: db) }
    end

    it 'creates a database' do
        # Arrange
        # Act
        client.create_database(name: 'development')

        # Assert
        expect(client.database_exists?(name: 'development')).to eq(true)
    end

    it 'deletes a database' do
        # Arrange
        client.create_database(name: 'development')
        # Act
        client.delete_database(name: 'development')
        # Assert
        expect(client.database_exists?(name: 'development')).to eq(false)
    end

    it 'reports a database exists' do
        client.create_database(name: 'development')
        expect(client.database_exists?(name: 'development')).to eq(true)
    end

    it 'reports a database does not exist' do
        expect(client.database_exists?(name: 'development')).to eq(false)
    end

end