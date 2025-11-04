require 'rails_helper'

RSpec.describe "Transcriptions", type: :request do
  describe "GET /transcriptions" do
    it "returns all transcriptions" do
      Transcription.create!(content: "Hello world", summary: "Test summary", status: "summarized")

      get "/transcriptions"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["transcriptions"].size).to eq(1)
    end
  end

  describe "POST /transcriptions" do
    it "creates transcription and returns summary" do
      allow_any_instance_of(SummarizerService).to receive(:call).and_return("Mock Summary")

      post "/transcriptions",
        params: { text: "Rails is great for speech transcription" },
        as: :json

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)

      expect(body["summary"]).to eq("Mock Summary")

      record = Transcription.last
      expect(record.content).to eq("Rails is great for speech transcription")
      expect(record.summary).to eq("Mock Summary")
      expect(record.status).to eq("summarized")
    end

    it "returns error when text is missing" do
      post "/transcriptions", params: {}, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /transcriptions/:id" do
    it "returns the transcription" do
      t = Transcription.create!(content: "Hi there", summary: "Short summary", status: "summarized")

      get "/transcriptions/#{t.id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["text"]).to eq("Hi there")
      expect(body["summary"]).to eq("Short summary")
    end
  end

  describe "GET /summary/:id" do
    context "when summary already exists" do
      it "returns existing summary" do
        t = Transcription.create!(content: "Hello", summary: "Existing summary", status: "summarized")

        get "/summary/#{t.id}"

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["summary"]).to eq("Existing summary")
      end
    end

    context "when summary is missing" do
      it "generates new summary" do
        t = Transcription.create!(content: "Conversation text", status: "pending")

        allow_any_instance_of(SummarizerService).to receive(:call).and_return("Generated Summary")

        get "/summary/#{t.id}"

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["summary"]).to eq("Generated Summary")

        t.reload
        expect(t.summary).to eq("Generated Summary")
        expect(t.status).to eq("summarized")
      end
    end
  end
end
