class SummarizerService
	def initialize(content)
		@content = content
		@client = OpenAI::Client.new
	end

	def call
		prompt = <<~PROMPT
			Summarize the following conversation in 3–4 concise bullet points.
			#{@content}
		PROMPT

		resp = @client.chat(
			parameters: {
				model: "gpt-4o-mini",
				messages: [{ role: "user", content: "Summarize:\n#{@content}" }],
				max_tokens: 150
			}
		)
		resp.dig("choices", 0, "message", "content")&.strip || ""
	rescue => e
		Rails.logger.error("Summarizer error: #{e.message}")
		"(summary unavailable)"
	end
end
  