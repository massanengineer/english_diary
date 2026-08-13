class CreateDiaryEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :diary_entries do |t|
      t.text :content
      t.date :entry_date

      t.timestamps
    end
  end
end
