class CreateVocabularies < ActiveRecord::Migration[8.1]
  def change
    create_table :vocabularies do |t|
      t.string :phrase
      t.string :meaning_ja

      t.timestamps
    end
  end
end
