require 'httparty'

class VideosController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    url = params[:url]
    response = HTTParty.post('https://api.assemblyai.com/v2/transcript',
      headers: {
        'Authorization' => '478b6faca69f41f88e9ded3c308e9e5f',
        'Content-Type' => 'application/json'
      },
      body: {
        'audio_url' => url
      }.to_json
    )

    video = Video.create(url: url, status: 'processing', transcript_id: response['id'])

    render json: { message: 'Video is being processed.', status: 'processing' }, status: :ok
  end

  def show
    video = Video.find(params[:id])

    if video.status == 'completed'
      transcript_response = HTTParty.get("https://api.assemblyai.com/v2/transcript/#{video.transcript_id}",
        headers: {
          'Authorization' => '478b6faca69f41f88e9ded3c308e9e5f'
        }
      )

      transcript_text = transcript_response['text']
      flagged_words = %w[bloody hell shit]
      if flagged_words.any? { |word| transcript_text.include?(word) }
        render json: { message: 'This video contains flagged words.', flagged_words: flagged_words }, status: :unprocessable_entity
      else
        render json: { message: 'Video transcription is completed.', transcript: transcript_text }, status: :ok
      end
    else
      render json: { message: 'Video transcription is still being processed.', status: 'processing' }, status: :ok
    end
  end
end

