class WeeklyCard < ApplicationRecord
  has_many :user_cards, dependent: :destroy
  has_many :users, through: :user_cards
  
  validates :name, presence: true
  validates :description, presence: true
  
  scope :active, -> { where(active: true) }
  
  def self.random_card
    active.sample
  end
end