class DiaryEntryVocabulary < ApplicationRecord
  belongs_to :diary_entry
  belongs_to :vocabulary
end
