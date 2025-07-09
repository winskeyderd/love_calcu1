class NameSearch < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
 
  scope :most_popular, -> { order(search_count: :desc) }
  
  # New scope for leaderboard - groups by first name only
  scope :leaderboard_by_first_name, -> {
    select('first_name, SUM(search_count) as search_count')
    .group(:first_name)
    .order('search_count DESC')
  }
 
  def self.record_search(first_name, last_name)
    name_search = find_or_initialize_by(
      first_name: first_name.downcase.strip,
      last_name: last_name.downcase.strip
    )
   
    if name_search.persisted?
      name_search.increment!(:search_count)
    else
      name_search.search_count = 1
      name_search.save!
    end
   
    name_search
  end
 
  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end
  
  # New method for display name in leaderboard
  def display_name
    first_name.titleize
  end
end