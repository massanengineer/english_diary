require "rails_helper"

RSpec.describe DiaryEntry, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password") }

  it "is valid with content and entry_date" do
    entry = DiaryEntry.new(user: user, content: "テスト", entry_date: Date.today)
    expect(entry).to be_valid
  end

  it "is invalid without content" do
    entry = DiaryEntry.new(user: user, content: nil, entry_date: Date.today)
    expect(entry).not_to be_valid
  end

  it "is invalid without entry_date" do
    entry = DiaryEntry.new(user: user, content: "テスト", entry_date: nil)
    expect(entry).not_to be_valid
  end

  it "is invalid with a duplicate entry_date for the same user" do
    DiaryEntry.create!(user: user, content: "1件目", entry_date: Date.today)
    duplicate = DiaryEntry.new(user: user, content: "2件目", entry_date: Date.today)
    expect(duplicate).not_to be_valid
  end

  it "allows the same entry_date for different users" do
    DiaryEntry.create!(user: user, content: "1件目", entry_date: Date.today)
    other_user = User.create!(email: "other@example.com", password: "password")
    entry = DiaryEntry.new(user: other_user, content: "別のユーザーの日記", entry_date: Date.today)
    expect(entry).to be_valid
  end
end
