class DiaryEntriesController < ApplicationController
  def index
    @diary_entries = DiaryEntry.order(entry_date: :desc)
  end

  def show
    @diary_entry = DiaryEntry.find(params[:id])
  end

  def new
    @diary_entry = DiaryEntry.new
  end

  def create
    @diary_entry = DiaryEntry.new(diary_entry_params)
    if @diary_entry.save
      redirect_to @diary_entry, notice: "日記を保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @diary_entry = DiaryEntry.find(params[:id])
  end

  def update
    @diary_entry = DiaryEntry.find(params[:id])
    if @diary_entry.update(diary_entry_params)
      redirect_to @diary_entry, notice: "日記を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @diary_entry = DiaryEntry.find(params[:id])
    @diary_entry.destroy
    redirect_to diary_entries_path, notice: "日記を削除しました"
  end

  private

  def diary_entry_params
    params.require(:diary_entry).permit(:content, :entry_date)
  end
end