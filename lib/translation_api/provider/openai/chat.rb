# frozen_string_literal: true

require "openai"
require_relative "response"

class TranslationAPI
  module Provider
    class OpenAI
      class Chat
        API_KEY_ERROR_MESSAGE = "API key is not found."

        def initialize(model:, prompt:)
          validate_api_key!

          @model  = model
          @prompt = prompt
          @client = init_client
        end

        def call(text)
          Response.new(request(text))
        end

        private

        def request(text)
          @client.chat(
            parameters: {
              model: @model.name,
              messages: [
                { role: "system", content: @prompt.system_prompt },
                { role: "user", content: @prompt.user_prompt + text }
              ]
            }
          )
        end

        def init_client
          ::OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
        end

        def validate_api_key!
          raise ArgumentError, API_KEY_ERROR_MESSAGE unless ENV["OPENAI_API_KEY"]
        end
      end
    end
  end
end
