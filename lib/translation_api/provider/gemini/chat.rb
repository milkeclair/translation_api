# frozen_string_literal: true

require "faraday"
require_relative "response"

class TranslationAPI
  module Provider
    class Gemini
      class Chat
        API_KEY_ERROR_MESSAGE = "API key is not found."

        def initialize(model:, prompt:)
          validate_api_key!

          @model  = model
          @prompt = prompt
        end

        def call(text)
          Response.new(request(text))
        end

        private

        def request(text)
          connection.post("/v1beta/models/#{@model.name}:generateContent") do |request|
            request.body = body(text)
          end
        end

        def connection
          Faraday.new(
            url: "https://generativelanguage.googleapis.com",
            headers: {
              "Content-Type" => "application/json",
              "x-goog-api-key" => ENV["GEMINI_API_KEY"]
            }
          )
        end

        def body(text)
          {
            contents: [
              {
                parts: [
                  {
                    text: @prompt.system_prompt + @prompt.user_prompt + text
                  }
                ]
              }
            ]
          }.to_json
        end

        def validate_api_key!
          raise ArgumentError, API_KEY_ERROR_MESSAGE unless ENV["GEMINI_API_KEY"]
        end
      end
    end
  end
end
