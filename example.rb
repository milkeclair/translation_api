# frozen_string_literal: true

require_relative "lib/jp_translator_from_gpt"

if ARGV.empty?
  puts "引数が必要です: ruby example.rb \"text\""
  exit
end

text = ARGV.join(" ")
translator =
  JpTranslatorFromGpt::Translator.new(output_logs: false, except_words: ["hoge"])
translator.translate_to_jp(text)
