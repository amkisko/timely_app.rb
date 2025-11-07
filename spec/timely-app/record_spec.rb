require "spec_helper"

RSpec.describe TimelyApp::Record do
  let(:id) { 123 }
  let(:record) { TimelyApp::Record.new(project_id: id) }

  describe "#[]" do
    it "returns attribute values" do
      expect(record[:project_id]).to eq(id)
    end
  end

  describe "#method_missing" do
    it "returns attribute values" do
      expect(record.project_id).to eq(id)
    end

    it "calls super when attribute doesn't exist" do
      expect {
        record.nonexistent_attribute
      }.to raise_error(NoMethodError)
    end

    it "calls super when method has arguments" do
      expect {
        record.project_id(123)
      }.to raise_error(NoMethodError)
    end

    it "calls super when method has block" do
      expect {
        record.project_id { "block" }
      }.to raise_error(NoMethodError)
    end
  end

  describe "#respond_to_missing?" do
    it "returns true when attribute exists" do
      expect(record.respond_to?(:project_id)).to be true
    end

    it "returns false when attribute doesn't exist" do
      expect(record.respond_to?(:nonexistent_attribute)).to be false
    end
  end

  describe "#to_h" do
    it "returns an attributes hash" do
      attributes = {project_id: id}

      expect(record.to_h).to eq(attributes)
    end
  end
end
