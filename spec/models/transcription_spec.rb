require 'rails_helper'

RSpec.describe Transcription, type: :model do
  describe "validations" do
    it "is valid with content" do
      transcription = Transcription.new(content: "Sample text")
      expect(transcription).to be_valid
    end

    it "is invalid without content" do
      transcription = Transcription.new(content: nil)
      expect(transcription).not_to be_valid
      expect(transcription.errors[:content]).to include("can't be blank")
    end
  end

  describe "status enum" do
    it "defaults to pending" do
      transcription = Transcription.create!(content: "Some text")
      expect(transcription.status).to eq("pending")
    end

    it "can be summarized" do
      transcription = Transcription.create!(content: "Some text", status: "summarized")
      expect(transcription.summarized?).to be true
    end

    it "can switch status" do
      transcription = Transcription.create!(content: "Some text")
      transcription.summarized!
      expect(transcription.status).to eq("summarized")
    end
  end
end
