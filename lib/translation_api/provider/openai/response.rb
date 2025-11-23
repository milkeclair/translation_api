# frozen_string_literal: true

class TranslationAPI
  module Provider
    class OpenAI
      class Response
        def initialize(response)
          @response = response
        end

        def translated_text
          @response["choices"][0]["message"]["content"]
        end

        def dig_used_tokens(type:)
          case type
          when :input
            @response["usage"]["prompt_tokens"]
          when :output
            @response["usage"]["completion_tokens"]
          else
            raise ArgumentError, "Invalid token type: #{type}"
          end
        end
      end
    end
  end
end
