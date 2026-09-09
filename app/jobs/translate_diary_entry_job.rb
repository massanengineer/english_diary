class TranslateDiaryEntryJob < ApplicationJob
  queue_as :default

    retry_on GeminiTranslationService::RateLimitedError, wait: :polynomially_longer, attempts: 5

  def perform(diary_entry_id)
    diary_entry = DiaryEntry.find(diary_entry_id)
    result = GeminiTranslationService.call(diary_entry.content)

    diary_entry.update(english_content: result["translation"])

    result["vocabulary"].each do |item|
      vocabulary = Vocabulary.find_or_create_by(phrase: item["phrase"]) do |v|
        v.meaning_ja = item["meaning_ja"]
      end
      diary_entry.vocabularies << vocabulary unless diary_entry.vocabularies.include?(vocabulary)
    end

    diary_entry.broadcast_replace_to(
      diary_entry,
      target: ActionView::RecordIdentifier.dom_id(diary_entry, :translation),
      partial: "diary_entries/translation",
      locals: { diary_entry: diary_entry }
    )
  end
end