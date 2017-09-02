require "spec_helper"

RSpec.describe Ravendb::Api::Client do

  let(:client) { Ravendb::Api::Client.new(url: 'http://localhost:8080') }

  it "has a version number" do
    expect(Ravendb::Api::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'stores a url' do
      expect(client.url.to_s).to eq 'http://localhost:8080'
    end
  end

  describe '#databases' do
    it 'returns databases' do
      allow(Net::HTTP).to receive(:get).and_return("[\"development\", \"production\"]")
      expect(client.databases).to eq ['development', 'production']
    end

    it 'returns no databases' do
      allow(Net::HTTP).to receive(:get).and_return('[]')
      # constraint on specific parameter
      # allow(Net::HTTP).to receive(:get).with('blah').and_return('[]')
      expect(client.databases).to eq []
    end
  end

  describe '#database_exists?' do
  
    it 'returns true' do
      allow(client).to receive(:databases).and_return(['development'])
      expect(client.database_exists?(name: 'development')).to eq(true)
    end
  
    it 'returns false' do
      allow(client).to receive(:databases).and_return([])
      expect(client.database_exists?(name: 'development')).to eq(false)
    end
  end

  describe '#create_database' do
    it 'creates a database' do
      # Setup spy
      allow(client).to receive(:put).with(url: URI('http://localhost:8080/admin/databases/qa1'), json_hash: {
        Settings: { 
          'Raven/ActiveBundles': '', 
          'Raven/DataDir': "~/qa1" 
        }, 
        Disabled: false
      })


      # act
      client.create_database(name: 'qa1')

      # assert spy
      expect(client).to have_received(:put)
    end

    it 'fails to create a database that already exists' do

    end

  end

  describe '#delete_database' do
    it 'deletes a database' do
      expect{ client.delete_database(name: 'qa1')
      }.to_not raise_error()
    end
  end
end