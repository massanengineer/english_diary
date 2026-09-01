class TranslateDiaryEntryJob < ApplicationJob
  queue_as :default

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
  end
end