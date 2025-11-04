class Transcription < ApplicationRecord
  validates :content, presence: true

	enum status: { pending: 'pending', summarized: 'summarized' }
end
