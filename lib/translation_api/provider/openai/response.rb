# frozen_string_literal: true

class TranslationAPI
  module Provider
    class OpenAI
      class Response
        def initialize(response)
          @response = response
        end

        def translated_text
          @response.dig("choices", 0, "message", "content")
        end

        def dig_used_tokens(type:)
          case type
          when :input
            @response.dig("usage", "prompt_tokens")
          when :output
            @response.dig("usage", "completion_tokens")
          else
            raise ArgumentError, "Invalid token type: #{type}"
          end
        end
      end
    end
  end
end
