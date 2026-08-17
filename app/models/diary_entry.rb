class DiaryEntry < ApplicationRecord
  validates :content, presence: true
  validates :entry_date, presence: true, uniqueness: true

  has_many :diary_entry_vocabularies
  has_many :vocabularies, through: :diary_entry_vocabularies
end
#uniqueness: true属性の値が一意であり、重複していないこと