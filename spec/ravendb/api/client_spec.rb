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

  describe '#create_database' do
    it 'creates a database' do
      # Setup spy
      allow(Net::HTTP).to receive(:start).with('localhost', 8080)

      # act
      client.create_database(name: 'qa1')

      # assert spy
      expect(Net::HTTP).to have_received(:start)
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