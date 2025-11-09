# frozen_string_literal: true

require "dotenv"
require "openai"
require_relative "writer"

class TranslationAPI
  module Provider
    class OpenAI
      SYSTEM_CONTENT_BASE = <<~TEXT
        Translate only.
        Return result only, no extra info
        Keep symbols
      TEXT

      # OpenAI APIを使用してテキストを翻訳する
      #
      # @param [Boolean] output_logs ログを出力するかどうか
      # @param [Array<String>] except_words 除外する単語のリスト
      # @param [String] language 翻訳先の言語
      # @return [void]
      def initialize(output_logs: true, except_words: [], language: "japanese")
        # 環境変数の読み込み
        Dotenv.load
        raise "API key is not found" unless ENV["OPENAI_API_KEY"]

        @client = ::OpenAI::Client.new(
          access_token: ENV["OPENAI_API_KEY"],
          log_errors: true # 好み
        )
        @output_logs = output_logs
        @system_content = SYSTEM_CONTENT_BASE + except_option_text(except_words)
        @language = language
      end

      # テキストを日本語に翻訳し、結果をファイルに書き込む
      #
      # @param [String] text 翻訳するテキスト
      # @return [void]
      def translate(text)
        # 空白文字は翻訳する必要がない
        return text if text.strip.empty?

        response = chat_to_api(text)
        Writer.write_logs(self, response) if @output_logs

        response["choices"][0]["message"]["content"]
      end

      # レスポンスから使用したトークン数を取得する
      #
      # @param [Hash] response OpenAI APIからのレスポンス
      # @param [String] token_type トークンの種類 (input or output)
      # @return [Integer] 使用したトークン数
      def self.dig_used_tokens(response, token_type)
        if token_type == "input"
          response["usage"]["prompt_tokens"]
        elsif token_type == "output"
          response["usage"]["completion_tokens"]
        end
      end

      private

      # OpenAI APIにテキストを送信し、翻訳結果を取得する
      #
      # @param [String] text 翻訳するテキスト
      # @return [Hash] OpenAI APIからのレスポンス
      def chat_to_api(text)
        @client.chat(
          parameters: {
            model: ENV["OPENAI_MODEL"] || "gpt-5-mini",
            messages: [
              { role: "system", content: @system_content },
              { role: "user", content: user_prompt_text(text) }
            ]
          }
        )
      end

      # 除外する単語を指定するプロンプト
      #
      # @param [Array<String>] except_words 除外する単語のリスト
      # @return [String] 除外する単語を指定するテキスト
      def except_option_text(except_words)
        return "" if except_words.empty?

        <<~TEXT
          Words listed next are not translated: [#{except_words.join(", ")}]
        TEXT
      end

      # ユーザー入力のプロンプト
      #
      # @param [String] text テキスト
      # @return [String] ユーザー入力のプロンプト
      def user_prompt_text(text)
        <<~TEXT
          Please translate this text to #{@language}: #{text}
        TEXT
      end
    end
  end
end
