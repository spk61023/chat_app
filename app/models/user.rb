class User < ApplicationRecord
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
  scope :all_except, ->(user) {where.not(id: user)}
  after_create_commit { broadcast_append_to "users" }
  after_update_commit { broadcast_update }
  has_many :messages
  enum status: %i[offline away online]
  has_many :notifications, dependent: :destroy, as: :recipient

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end

  def status_to_css
    case status
    when 'online'
      puts "online"
    when 'away'
      puts "away"
    else
      puts "offline"
    end
  end
end
