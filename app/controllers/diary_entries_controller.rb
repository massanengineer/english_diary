class DiaryEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @diary_entries = current_user.diary_entries.order(entry_date: :desc)
  end

  def show
    @diary_entry = current_user.diary_entries.find(params[:id])
  end

  def new
    @diary_entry = current_user.diary_entries.new(entry_date: params[:entry_date])
  end

  def create
    @diary_entry = current_user.diary_entries.new(diary_entry_params)
    if @diary_entry.save
      redirect_to @diary_entry, notice: "日記を保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @diary_entry = current_user.diary_entries.find(params[:id])
  end

  def update
    @diary_entry = current_user.diary_entries.find(params[:id])
    if @diary_entry.update(diary_entry_params)
      redirect_to @diary_entry, notice: "日記を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diary_entry = current_user.diary_entries.find(params[:id])
    @diary_entry.destroy
    redirect_to diary_entries_path, notice: "日記を削除しました"
  end

  def translate
    @diary_entry = current_user.diary_entries.find(params[:id])
    TranslateDiaryEntryJob.perform_later(@diary_entry.id)
    redirect_to @diary_entry, notice: "AI変換を開始しました。数秒後にページを更新してみてください"
  end

  def calendar
    @year = (params[:year] || Date.today.year).to_i
    @month = (params[:month] || Date.today.month).to_i

    start_date = Date.new(@year, @month, 1)
    end_date = start_date.end_of_month

    entries = current_user.diary_entries.where(entry_date: start_date..end_date)
    @entries_by_date = entries.index_by(&:entry_date)

    prev_month_date = start_date.prev_month
    next_month_date = start_date.next_month
    @prev_year, @prev_month = prev_month_date.year, prev_month_date.month
    @next_year, @next_month = next_month_date.year, next_month_date.month
  end

  private

  def diary_entry_params
    params.require(:diary_entry).permit(:content, :entry_date)
  end
end