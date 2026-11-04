require "rails_helper"

RSpec.describe "DiaryEntries", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:other_user) { User.create!(email: "other@example.com", password: "password") }
  let!(:other_users_entry) do
    DiaryEntry.create!(user: other_user, content: "他人の日記", entry_date: Date.today)
  end

  describe "未ログイン時" do
    it "日記一覧へのアクセスはログイン画面にリダイレクトされる" do
      get diary_entries_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "ログイン時" do
    before { sign_in user }

    it "他人の日記の詳細ページにはアクセスできない" do
      get diary_entry_path(other_users_entry)
      expect(response).to have_http_status(:not_found)
    end

    it "自分の日記の詳細ページにはアクセスできる" do
      my_entry = DiaryEntry.create!(user: user, content: "自分の日記", entry_date: Date.tomorrow)
      get diary_entry_path(my_entry)
      expect(response).to have_http_status(:ok)
    end
  end
end
