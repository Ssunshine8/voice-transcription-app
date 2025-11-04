class TranscriptionsController < ApplicationController

	def index
			@transcriptions = Transcription.all
			render json: {transcriptions: @transcriptions}, status: :ok
	end
	
	def new
	end
	
	def create
		unless params[:text].present?
			return render json: { errors: ["text is required"] }, status: :unprocessable_entity
		end
		transcription = Transcription.new(content: params.require(:text))
		if transcription.save
			summary = SummarizerService.new(transcription.content).call
			transcription.update(summary: summary, status: 'summarized')
			render json: { id: transcription.id, summary: summary }, status: :created
		else
			render json: { errors: transcription.errors.full_messages }, status: :unprocessable_entity
		end
	end
	
	def show
		transcription = Transcription.find(params[:id])
		render json: { id: transcription.id, text: transcription.content, summary: transcription.summary, status: transcription.status }
	end
	
	def summary
		transcription = Transcription.find(params[:id])
		if transcription.summary.present?
			render json: { id: transcription.id, summary: transcription.summary }
		else
			summary = SummarizerService.new(transcription.content).call
			transcription.update(summary: summary, status: 'summarized')
			render json: { id: transcription.id, summary: summary }
		end
	end
end
