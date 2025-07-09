class UserCard < ApplicationRecord
  belongs_to :user
  belongs_to :weekly_card
  
  validates :drawn_at, presence: true
  
  scope :recent, -> { order(drawn_at: :desc) }
end
