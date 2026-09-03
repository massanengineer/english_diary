class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :diary_entries, dependent: :destroy
  
  def diary_streak
    dates = diary_entries.order(entry_date: :desc).pluck(:entry_date)
    return 0 if dates.empty?

    today = Date.today
    cursor = dates.include?(today) ? today : today - 1
    count = 0

    while dates.include?(cursor)
      count += 1
      cursor -= 1
    end

    count
  end
end
