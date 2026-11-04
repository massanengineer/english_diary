class CreateDiaryEntryVocabularies < ActiveRecord::Migration[8.1]
  def change
    create_table :diary_entry_vocabularies do |t|
      t.references :diary_entry, null: false, foreign_key: true
      t.references :vocabulary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
