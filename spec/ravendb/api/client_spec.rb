require "spec_helper"

RSpec.describe Ravendb::Api::Client::Client do

  let(:client) { Ravendb::Api::Client::Client.new(url: 'http://localhost:8080') }

  it "has a version number" do
    expect(Ravendb::Api::Client::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'stores a url' do
      expect(client.url).to eq 'http://localhost:8080'
    end
  end

end
