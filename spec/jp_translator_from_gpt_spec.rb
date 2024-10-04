# frozen_string_literal: true

RSpec.describe JpTranslatorFromGpt do
  let(:translator) { JpTranslatorFromGpt::Translator.new }

  it "バージョンが存在するか" do
    expect(JpTranslatorFromGpt::VERSION).not_to be_nil
  end

  describe "Translator" do
    describe "#initialize" do
      it "OpenAI::Clientのインスタンス変数が生成される" do
        expect(translator.instance_variable_get(:@client)).to be_an_instance_of(OpenAI::Client)
      end
    end

    describe "#translate" do
      let(:text) { "Hello, world!" }
      let(:response) do
        {
          "choices" => [
            { "message" => { "content" => "こんにちは、世界！" } }
          ]
        }
      end

      it "翻訳されたテキストが返る" do
        allow(translator).to receive(:chat_to_api).and_return(response)
        # 不要な出力を抑制
        allow(translator).to receive(:puts)
        allow(JpTranslatorFromGpt::Writer).to receive(:write_logs)

        expect(translator.translate(text)).to be_a(String)
      end

      it "Writer#write_logsが呼ばれる" do
        allow(translator).to receive(:chat_to_api).and_return(response)
        # 不要な出力を抑制
        allow(translator).to receive(:puts)
        allow(JpTranslatorFromGpt::Writer).to receive(:write_logs)

        translator.translate(text)

        expect(JpTranslatorFromGpt::Writer).to have_received(:write_logs).with(response)
      end
    end
  end

  describe "Writer" do
    describe "#write_logs" do
      let(:response) do
        {
          "choices" => [
            { "message" => { "content" => "こんにちは、世界！" } }
          ],
          "usage" => {
            "prompt_tokens" => 10,
            "completion_tokens" => 10
          }
        }
      end
      let(:file_path) { "spec/fixtures/files/fixture.txt" }
      let(:file_mock) { instance_double(File) }

      before do
        allow(JpTranslatorFromGpt::Writer).to receive(:text_path).and_return(file_path)
        allow(File).to receive(:open).with(file_path, "a").and_yield(file_mock)
        allow(File).to receive(:open).with(file_path, "w").and_yield(file_mock)
        # 実際の書き込みをモック
        allow(file_mock).to receive(:puts)
      end

      it "翻訳結果が書き込まれる" do
        JpTranslatorFromGpt::Writer.write_logs(response)

        expect(file_mock).to have_received(:puts).with("こんにちは、世界！")
      end

      it "使用したトークン数の入力が書き込まれる" do
        JpTranslatorFromGpt::Writer.write_logs(response)

        expect(file_mock).to have_received(:puts).with("input: 10")
      end

      it "使用したトークン数の出力が書き込まれる" do
        JpTranslatorFromGpt::Writer.write_logs(response)

        expect(file_mock).to have_received(:puts).with("output: 10")
      end

      it "トークン数に応じた金額が書き込まれる" do
        JpTranslatorFromGpt::Writer.write_logs(response)
        calculator = JpTranslatorFromGpt::Calculator
        input_rate = calculator.get_token_rate("gpt-4o-mini", "input")
        output_rate = calculator.get_token_rate("gpt-4o-mini", "output")
        expected_cost = format("$%.8f", (input_rate + output_rate) * 10)

        expect(file_mock).to have_received(:puts).with(expected_cost)
      end
    end
  end
end
