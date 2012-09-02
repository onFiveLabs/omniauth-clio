require 'spec_helper'

describe OmniAuth::Strategies::clio do
  subject do
    OmniAuth::Strategies::clio.new({})
  end

  context "client options" do
    it 'should have correct name' do
      subject.options.name.should eq("clio")
    end

    it 'should have correct site' do
      subject.options.client_options.site.should eq('http://api-docs.goclio.com')
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_path.should eq('/oauth/authenticate')
    end
  end
end
