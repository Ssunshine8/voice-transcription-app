require "rails_helper"

RSpec.describe SummarizerService do
  let(:content) { "This is a long conversation that needs summarization." }

  describe "#call" do
    it "returns a summary when API returns content" do
      fake_client = instance_double(OpenAI::Client)
      allow(OpenAI::Client).to receive(:new).and_return(fake_client)

      mock_response = {
        "choices" => [
          { "message" => { "content" => "• This is a summary." } }
        ]
      }
      allow(fake_client).to receive(:chat).and_return(mock_response)
      summary = SummarizerService.new(content).call
      expect(summary).to eq("• This is a summary.")
    end

    it "returns fallback text when API fails" do
      fake_client = instance_double(OpenAI::Client)
      allow(OpenAI::Client).to receive(:new).and_return(fake_client)
      allow(fake_client).to receive(:chat).and_raise(StandardError.new("API Failed"))
      
      summary = SummarizerService.new(content).call
      expect(summary).to eq("(summary unavailable)")
    end

    it "returns fallback when API returns nil" do
      fake_client = instance_double(OpenAI::Client)
      allow(OpenAI::Client).to receive(:new).and_return(fake_client)
      allow(fake_client).to receive(:chat).and_return(nil)
      summary = SummarizerService.new(content).call
      expect(summary).to eq("(summary unavailable)")
    end
  end
end
