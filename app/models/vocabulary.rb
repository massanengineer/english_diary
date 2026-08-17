class Vocabulary < ApplicationRecord
  validates :phrase, presence: true, uniqueness: true

  has_many :diary_entry_vocabularies
  has_many :diary_entries, through: :diary_entry_vocabularies
end