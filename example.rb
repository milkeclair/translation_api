# frozen_string_literal: true

require_relative "lib/translation_api/mediator"

if ARGV.empty?
  puts "引数が必要です: ruby example.rb \"text\""
  exit
end

text = ARGV.join(" ")
translator =
  TranslationAPI::Mediator.new(
    output_logs: true,
    language: "japanese",
    agent: :openai,
    except_words: %w[hoge fuga]
  )
translated_text = translator.translate(text)
p translated_text
