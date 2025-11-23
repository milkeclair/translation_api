# frozen_string_literal: true

require "json"

class TranslationAPI
  module Provider
    class Gemini
      class Response
        REQUEST_FAILED_MESSAGE = "Request failed with status"

        attr_reader :response

        def initialize(response)
          @response = response
        end

        def translated_text
          failed_message = "#{REQUEST_FAILED_MESSAGE} #{@response.status}"
          raise ArgumentError, failed_message unless @response.status == 200

          body_json.dig("candidates", 0, "content", "parts", 0, "text")
        end

        def dig_used_tokens(type:)
          case type
          when :input
            body_json.dig("usageMetadata", "promptTokenCount")
          when :output
            body_json.dig("usageMetadata", "candidatesTokenCount")
          else
            raise ArgumentError, "Invalid token type: #{type}"
          end
        end

        private

        def body_json
          @body_json ||= JSON.parse(@response.body)
        end
      end
    end
  end
end
