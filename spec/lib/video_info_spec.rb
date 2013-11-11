require 'spec_helper'

describe VideoInfo do

  describe "#initialize" do
    let(:url) { 'url' }
    let(:options) { { foo: :bar } }
    let(:provider) { double('provider', provider: 'Provider') }

    it "uses the first usable provider" do
      VideoInfo::Providers::Vimeo.stub(:usable?) { false }
      VideoInfo::Providers::Youtube.stub(:usable?) { true }
      VideoInfo::Providers::Youtube.stub(:new) { provider }

      expect(VideoInfo.new(url, options).provider).to eq 'Provider'
    end

    it "raise when no providers are usable" do
      VideoInfo::Providers::Vimeo.stub(:usable?) { false }
      VideoInfo::Providers::Youtube.stub(:usable?) { false }

      expect { VideoInfo.new(url, options) }.to raise_error(VideoInfo::UrlError)
    end
  end

  describe ".usable?" do
    let(:url) { 'url' }
    let(:provider) { double('provider', new: true) }

    it "returns true when a provider is usable" do
      VideoInfo::Providers::Vimeo.stub(:usable?) { false }
      VideoInfo::Providers::Youtube.stub(:usable?) { true }
      VideoInfo::Providers::Youtube.stub(:new) { true }

      expect(VideoInfo.usable?(url)).to be_true
    end

    it "returns false when no providers are usable" do
      VideoInfo::Providers::Vimeo.stub(:usable?) { false }
      VideoInfo::Providers::Youtube.stub(:usable?) { false }

      expect(VideoInfo.usable?(url)).to be_false
    end
  end

end
