class AddEnglishContentToDiaryEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :diary_entries, :english_content, :text
  end
end
