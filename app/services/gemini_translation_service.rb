require "net/http"
require "uri"

class GeminiTranslationService
  ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent"

  def self.call(japanese_text)
    new(japanese_text).call
  end

  def initialize(japanese_text)
    @japanese_text = japanese_text
  end

  def call
    response = request_gemini
    parse_response(response)
  end

  private

  def request_gemini
    uri = URI(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["x-goog-api-key"] = Rails.application.credentials.dig(:gemini, :api_key)
    request.body = { contents: [{ parts: [{ text: prompt }] }] }.to_json

    http.request(request)
  end

  def prompt
    <<~PROMPT
      あなたは日本語の日記を自然な英語に変換する翻訳者です。
      直訳ではなく、ネイティブが日記に書くような自然な英語に変換してください。
      さらに、変換した英文の中から日本人学習者が覚えておくと役立つ単語・フレーズを3〜4個選び、それぞれ簡単な日本語の意味を付けてください。

      以下のJSON形式のみで回答してください。説明文やコードブロックの記号は一切不要です。
      {"translation": "...", "vocabulary": [{"phrase": "...", "meaning_ja": "..."}]}

      日本語の日記:
      #{@japanese_text}
    PROMPT
  end

  def parse_response(response)
    body = JSON.parse(response.body)
    raw_text = body.dig("candidates", 0, "content", "parts", 0, "text")
    cleaned = raw_text.gsub(/\A```json/, "").gsub(/```\z/, "").strip
    JSON.parse(cleaned)
  end
end
