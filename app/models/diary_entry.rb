class DiaryEntry < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :entry_date, presence: true, uniqueness: { scope: :user_id }

  has_many :diary_entry_vocabularies
  has_many :vocabularies, through: :diary_entry_vocabularies
end