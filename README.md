# README
# Voice Transcription & Summarization App (Rails + Web Speech API)

This is a small Ruby on Rails web application that allows users to **record their voice**, see **live transcription** in the browser, and after stopping recording, the backend generates a **summary** using OpenAI.

---

## 🚀 Features

- **Start / Stop voice recording** in the browser
- **Live transcription** displayed in real-time (using Web Speech API)
- **Summarization using OpenAI GPT model**
- Transcriptions are stored in Postgres / SQLite (used SQLite)
- Basic request tests included (model + controller)

---

## Tech Stack

| Layer       | Technology |
|------------|------------|
| Frontend   | StimulusJS / Web Speech API |
| Backend    | Ruby on Rails 7+ |
| LLM API    | OpenAI (ruby-openai gem) |
| Database   | SQLite / PostgreSQL |

---

## Setup & Installation

### 1. Clone the Repository
```bash
git clone https://github.com/Ssunshine8/voice-transcription-app.git
    cd voice-transcription-app
2. Install Dependencies
    bundle install
3. Database Setup
    rails db:create db:migrate
### API Key Setup (Important)
1. Copy the example credentials file:
    cp config/application.yml.example config/application.yml
2. Open config/application.yml and add your OpenAI key:
    OPENAI_API_KEY: "your-openai-key-here"
###Run the App
    rails server

###Running Tests
bundle exec rspec

