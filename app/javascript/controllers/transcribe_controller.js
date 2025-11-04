import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
	static targets = ["live", "final", "summary", "startBtn", "stopBtn"]

	connect() {
		this.recognition = null
		this.partial = ''
	}

	start() {
		if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
			alert('Your browser does not support the Web Speech API. Use Chrome or Edge.');
			return
		}


		const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
		this.recognition = new SpeechRecognition();
		this.recognition.lang = 'en-US';
		this.recognition.interimResults = true;
		this.recognition.continuous = true;

		this.recognition.onresult = (event) => {
			let interim = '';
			let final = this.finalTarget.textContent || '';

			for (let i = event.resultIndex; i < event.results.length; ++i) {
				const res = event.results[i];
				if (res.isFinal) {
					final += res[0].transcript + ' ';
				} else {
					interim += res[0].transcript;
				}
			}
			this.liveTarget.textContent = interim;
			this.finalTarget.textContent = final.trim();
		};
		this.recognition.onerror = (e) => console.error('Speech error', e);
		this.recognition.start();
		this.startBtnTarget.disabled = true;
		this.stopBtnTarget.disabled = false;
	}

	stop() {
		if (!this.recognition) return;
			this.recognition.stop();

			this.startBtnTarget.disabled = false;
			this.stopBtnTarget.disabled = true;
		
			const text = this.finalTarget.textContent.trim();
  		if (!text) return;
			const token = document.querySelector('meta[name="csrf-token"]').content;
			
			fetch('/transcriptions', {
		    method: 'POST',
		    headers: { 
		      'Content-Type': 'application/json',
		      'Accept': 'application/json',
		      'X-CSRF-Token': token 
		    },
		    body: JSON.stringify({ text: text })
		  })
		  .then(r => r.json())
		  .then(data => {
		    if (data.summary) {
		      this.summaryTarget.textContent = data.summary;
		    }
		  })
			.catch(err => console.error(err));
		}
	}
	