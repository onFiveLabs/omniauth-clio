require 'spec_helper'

describe OmniAuth::Strategies::Clio do
  subject do
    OmniAuth::Strategies::Clio.new({})
  end

  context "client options" do
    it 'should have correct name' do
      subject.options.name.should eq("Clio")
    end

    it 'should have correct site' do
      subject.options.client_options.site.should eq('https://app.goclio.com')
    end

  end
end
