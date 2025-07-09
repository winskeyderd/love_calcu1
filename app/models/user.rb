class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :user_readings, dependent: :destroy
  has_many :user_cards, dependent: :destroy

  def update_login_streak
    if last_login_date == Date.yesterday
      self.login_streak += 1
    else
      self.login_streak = 1
    end

    self.last_login_date = Date.current
    save
  end

  # Methods for profile template
  def full_name
    # If you have first_name and last_name columns, use them
    # "#{first_name} #{last_name}".strip
    
    # For now, using email as fallback
    email.split('@').first.humanize
  end

  def username
    # If you have a username column, use it
    # Otherwise, extract from email
    email.split('@').first
  end

  def current_streak
    login_streak || 0
  end

  # Methods for rewards functionality
def self.find_for_database_authentication(warden_conditions)
  conditions = warden_conditions.dup
  if username = conditions.delete(:username)
    where(conditions.to_h).where(['lower(username) = ?', username.downcase]).first
  else
    where(conditions.to_h).first
  end
end

 
end