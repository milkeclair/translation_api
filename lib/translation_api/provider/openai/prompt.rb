# frozen_string_literal: true

class TranslationAPI
  module Provider
    class OpenAI
      class Prompt
        SYSTEM_PROMPT_BASE = <<~TEXT
          Translate only.
          Return result only, no extra info
          Keep symbols
        TEXT

        def initialize(except_words:, language:, custom_prompt:)
          @except_words  = except_words
          @language      = language
          @custom_prompt = custom_prompt
        end

        def system_prompt
          SYSTEM_PROMPT_BASE + except_option_text
        end

        def user_prompt
          <<~TEXT
            #{@custom_prompt || ""}
            Please translate this text to #{@language}:
          TEXT
        end

        private

        def except_option_text
          return "" if @except_words.empty?

          <<~TEXT
            Words listed next are not translated: [#{@except_words.join(", ")}]
          TEXT
        end
      end
    end
  end
end
