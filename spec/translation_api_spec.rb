# frozen_string_literal: true

RSpec.describe TranslationAPI do
  it "バージョンが存在すること" do
    expect(TranslationAPI::VERSION).not_to be_nil
  end
end
