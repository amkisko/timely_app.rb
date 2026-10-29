require "spec_helper"
require "stringio"
require_relative "../usr/lib/release_version_check"

RSpec.describe ReleaseVersionCheck do
  describe ".confirm_release?" do
    it "declines when input is closed" do
      expect(described_class.confirm_release?(input: StringIO.new)).to be false
    end

    it "accepts an entered default answer" do
      expect(described_class.confirm_release?(input: StringIO.new("\n"))).to be true
    end

    it "accepts a lowercase confirmation" do
      expect(described_class.confirm_release?(input: StringIO.new("y\n"))).to be true
    end

    it "declines a negative answer" do
      expect(described_class.confirm_release?(input: StringIO.new("n\n"))).to be false
    end
  end
end
