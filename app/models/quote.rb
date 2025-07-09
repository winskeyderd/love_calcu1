class Quote < ApplicationRecord
  validates :quote, presence: true
  validates :author, presence: true

  scope :active, -> { where(active: true) }

  def self.current
    # Return a random active quote (or nil if none)
    active.order("RANDOM()").first
  end
end
