# frozen_string_literal: true

require_relative "writer"
require_relative "openai"
require_relative "deepl"

module TranslationAPI
  class Mediator
    # @param [Boolean] output_logs ログを出力するかどうか
    # @param [String] language 翻訳先の言語
    # @param [Symbol] agent 翻訳エージェント
    # @param [Array<String>] except_words 除外する単語のリスト
    # @return [TranslationAPI::Mediator]
    def initialize(
      output_logs: true, language: "japanese", agent: :openai, except_words: []
    )
      @output_logs = output_logs
      @language = language
      @agent = agent
      @except_words = except_words
    end

    # テキストを翻訳する
    #
    # @param [String] text 翻訳するテキスト
    # @return [String] 翻訳されたテキスト
    def translate(text)
      agent = init_agent
      agent.translate(text)
    end

    # エージェントのインスタンスを初期化する
    #
    # @return [Object] 翻訳エージェントのインスタンス
    def init_agent
      agent_class.new(
        output_logs: @output_logs, except_words: @except_words, language: @language
      )
    end

    # エージェントのクラスを返す
    #
    # @return [Class] エージェントのクラス
    def agent_class
      case @agent
      when :openai
        OpenAI
      when :deepl
        DeepL
      else
        class_name = camelize(@agent.to_s)
        Object.const_get("TranslationAPI::#{class_name}")
      end
    end

    # スネークケースの文字列をキャメルケースに変換する
    #
    # @param [String] str スネークケースの文字列
    # @return [String] キャメルケースの文字列
    def camelize(str)
      str.split("_").map(&:capitalize).join
    end
  end
end
