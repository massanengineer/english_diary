class DiaryEntry < ApplicationRecord
  validates :content, presence: true
  validates :entry_date, presence: true, uniqueness: true
end
#uniqueness: true属性の値が一意であり、重複していないこと