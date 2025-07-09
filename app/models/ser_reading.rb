class UserReading < ApplicationRecord
  belongs_to :user
  
  validates :person1_first, :person1_last, :person2_first, :person2_last, :result, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  
  def person1_name
    "#{person1_first} #{person1_last}"
  end
  
  def person2_name
    "#{person2_first} #{person2_last}"
  end
  
  def formatted_result
    case result
    when 'F' then 'Friends'
    when 'L' then 'Lovers'
    when 'A' then 'Affection'
    when 'M' then 'Marriage'
    when 'E' then 'Enemies'
    when 'S' then 'Siblings'
    else result
    end
  end
end