# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @guest_calculations_remaining = guest_calculations_remaining
  end

  def calculate
    @name1 = params[:name1]&.strip
    @name2 = params[:name2]&.strip
    @guest_calculations_remaining = guest_calculations_remaining

    if @name1.blank? || @name2.blank?
      flash[:error] = "Please enter both names"
      redirect_to root_path
      return
    end

    # Calculate FLAMES
    @flames_result = calculate_flames(@name1, @name2)
    @percentage = calculate_percentage(@name1, @name2)
    @tarot_message = generate_tarot_message(@flames_result)

    # Save calculation if user is logged in
    if user_signed_in?
      begin
        @calculation = Calculation.create!(
          user: current_user,
          name1: @name1,
          name2: @name2,
          result: @flames_result,
          percentage: @percentage
        )
        
        # Award points for calculation
        current_user.increment!(:points, 10)
        
        # Update streak
        update_user_streak
        
        flash[:success] = "Calculation saved! You earned 10 points."
      rescue => e
        Rails.logger.error "Error saving calculation: #{e.message}"
        flash[:error] = "There was an error saving your calculation."
      end
    else
      # Increment guest calculation count
      increment_guest_calculation
      @guest_calculations_remaining = guest_calculations_remaining
      
      if @guest_calculations_remaining && @guest_calculations_remaining > 0
        flash[:info] = "You have #{@guest_calculations_remaining} calculations remaining. Sign up to get unlimited calculations!"
      elsif @guest_calculations_remaining == 0
        flash[:warning] = "This was your last free calculation! Sign up to continue."
      end
    end

    render :index
  end

  private

  def calculate_flames(name1, name2)
    # Remove spaces and convert to lowercase
    n1 = name1.gsub(/\s+/, '').downcase
    n2 = name2.gsub(/\s+/, '').downcase
    
    # Create frequency hash
    freq = Hash.new(0)
    
    # Count frequency of each character in both names
    (n1 + n2).each_char { |char| freq[char] += 1 }
    
    # Remove characters that appear an even number of times
    freq.delete_if { |char, count| count.even? }
    
    # Sum remaining frequencies
    remaining_count = freq.values.sum
    
    # FLAMES array
    flames = ['F', 'L', 'A', 'M', 'E', 'S']
    
    # If no characters remain, default to 'F'
    return 'F' if remaining_count == 0
    
    # Calculate FLAMES result
    index = 0
    while flames.length > 1
      index = (index + remaining_count - 1) % flames.length
      flames.delete_at(index)
      index = index % flames.length if flames.length > 0
    end
    
    flames.first
  end

  def calculate_percentage(name1, name2)
    # Simple percentage calculation based on name compatibility
    n1 = name1.gsub(/\s+/, '').downcase
    n2 = name2.gsub(/\s+/, '').downcase
    
    # Count common characters
    common_chars = 0
    freq1 = Hash.new(0)
    freq2 = Hash.new(0)
    
    n1.each_char { |char| freq1[char] += 1 }
    n2.each_char { |char| freq2[char] += 1 }
    
    freq1.each do |char, count|
      common_chars += [count, freq2[char]].min
    end
    
    # Calculate percentage
    total_chars = n1.length + n2.length
    base_percentage = (common_chars.to_f / total_chars * 100).round
    
    # Add some randomness based on name combination
    seed = (n1 + n2).sum(&:ord)
    Random.srand(seed)
    modifier = Random.rand(-10..10)
    
    [(base_percentage + modifier), 100].min.clamp(1, 100)
  end

  def generate_tarot_message(flames_result)
    messages = {
      'F' => [
        "The stars align for a beautiful friendship! Your bond is blessed by cosmic forces.",
        "A friendship written in the stars awaits. Trust in the universe's plan.",
        "The crystals whisper of a loyal companion. Cherish this sacred connection."
      ],
      'L' => [
        "The moon blesses your union with eternal love! Your hearts beat as one.",
        "Venus herself smiles upon your love story. This is destiny fulfilled.",
        "The ancient runes speak of a love that transcends time and space."
      ],
      'A' => [
        "Mars influences your connection with passionate affection! Embrace the fire within.",
        "The tarot cards reveal deep affection flowing between your souls.",
        "Your auras dance together in perfect harmony. This affection is divine."
      ],
      'M' => [
        "The universe conspires to bring you together in sacred marriage! Wedding bells echo through the cosmos.",
        "Your destinies intertwine like constellations in the night sky. Marriage awaits.",
        "The crystal ball reveals a future of matrimonial bliss. Prepare for union."
      ],
      'E' => [
        "The shadows speak of rivalry, but within conflict lies growth and understanding.",
        "Mercury's influence brings challenges, but also opportunities for deeper connection.",
        "The cards suggest tension, but remember - diamonds are formed under pressure."
      ],
      'S' => [
        "The cosmic forces indicate a sisterly or brotherly bond. Family of the heart.",
        "Your spirits recognize each other as kindred souls. A sibling connection transcends blood.",
        "The stars reveal a protective, nurturing relationship. You are family."
      ]
    }
    
    messages[flames_result]&.sample || "The universe holds mysterious plans for your connection."
  end
  
  def update_user_streak
    today = Date.current
    last_calculation = current_user.calculations.where('created_at >= ?', today.beginning_of_day).first
    
    if last_calculation && last_calculation.created_at.to_date == today
      # User already calculated today, don't update streak
      return
    end
    
    last_login = current_user.last_calculation_date || today - 1.day
    
    if last_login == today - 1.day
      # Consecutive day, increment streak
      current_user.increment!(:login_streak, 1)
    elsif last_login < today - 1.day
      # Broke streak, reset to 1
      current_user.update!(login_streak: 1)
    end
    
    current_user.update!(last_calculation_date: today)
  end
end