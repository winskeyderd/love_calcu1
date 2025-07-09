class Quote < ApplicationRecord
  validates :author, presence: true
  
  scope :active, -> { where(active: true) }

  def self.current
    active.order("RANDOM()").first
  end
end
