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
    http.open_timeout = 10
    http.read_timeout = 120

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["x-goog-api-key"] = Rails.application.credentials.dig(:gemini, :api_key)
    request.body = { contents: [{ parts: [{ text: prompt }] }] }.to_json

    http.request(request)
  end

  def prompt
    <<~PROMPT
      あなたは英語ネイティブレベルの英語講師兼翻訳者です。

      私が日本語で書いた日記を、**英語ネイティブが実際に書く自然な英語の日記**に変換してください。

      単純な直訳ではなく、日本語の意味・ニュアンス・感情を理解したうえで、英語として自然になるように表現を調整してください。

      ### 基本ルール

      * 日本語を一文ずつ直訳しない
      * 「日本語では自然だが、英語では不自然」な表現は自然な英語に言い換える
      * 英語ネイティブが日記で実際に使う自然な表現を優先する
      * 日記なので、会話文ほどカジュアルすぎず、堅すぎない自然な文章にする
      * 難しすぎる単語や不必要に高度な文法は避ける
      * 私の英語学習レベルはB2程度を想定する
      * B2レベルでも理解・習得しやすい表現を基本にする
      * ただし、ネイティブが日常的によく使うフレーズは積極的に使用する
      * 日本語に主語がない場合は、文脈から自然な主語を補う
      * 日本語特有の表現は、英語で同じニュアンスが伝わるように意訳する
      * 日本語にない情報を勝手に追加しない
      * 元の日記の内容や感情を変えない
      * 必要以上に文章を美しくしたり、文学的にしたりしない
      * 「英語として正しい」だけでなく、「実際に英語ネイティブが書きそうか」を重視する

      ### 重要

      最優先するのは、

      **① 日本語の意味を正確に保つ**
      ↓
      **② 英語として自然にする**
      ↓
      **③ B2レベルの英語学習者でも理解・習得しやすくする**

      という順番です。

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

    if raw_text.nil?
      Rails.logger.error("Gemini API unexpected response: #{response.body}")
      raise "Gemini API unexpected response"
    end

    cleaned = raw_text.gsub(/\A```json/, "").gsub(/```\z/, "").strip
    JSON.parse(cleaned)
  end
end
