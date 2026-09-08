class GuestSessionsController < ApplicationController
  def create
    user = User.guest
    sign_in user
    redirect_to diary_entries_path, notice: "ゲストとしてログインしました"
  end
end
