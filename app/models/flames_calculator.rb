# app/models/flames_calculator.rb
class FlamesCalculator
  FLAMES_MEANINGS = {
    'F' => { 
      meaning: 'Friends', 
      tip: 'You share a strong platonic bond. Focus on building trust and supporting each other.',
      tarot_message: 'The cards reveal a harmonious friendship written in the stars. Your bond transcends the ordinary.'
    },
    'L' => { 
      meaning: 'Lovers', 
      tip: 'There\'s romantic potential here. Take time to understand each other\'s love languages.',
      tarot_message: 'The universe whispers of passionate love. Your hearts dance to the same celestial rhythm.'
    },
    'A' => { 
      meaning: 'Affection', 
      tip: 'You care deeply for each other. Show appreciation through small gestures and kind words.',
      tarot_message: 'A gentle warmth surrounds your connection. The cosmos blesses you with tender affection.'
    },
    'M' => { 
      meaning: 'Marriage', 
      tip: 'You might be soulmates! Communication and compromise will be key to your success.',
      tarot_message: 'The eternal bond of marriage glows in your future. Two souls destined to become one.'
    },
    'E' => { 
      meaning: 'Enemies', 
      tip: 'You may have conflicts, but these can lead to growth. Practice patience and understanding.',
      tarot_message: 'The cards show challenges that forge strength. Even enemies can become allies through understanding.'
    },
    'S' => { 
      meaning: 'Siblings', 
      tip: 'You have a familial bond. Loyalty and unconditional support define your relationship.',
      tarot_message: 'The sacred bond of family flows through your connection. You are kindred spirits.'
    }
  }.freeze

  def initialize(name1, name2)
    @name1 = name1.gsub(/\s+/, '').downcase
    @name2 = name2.gsub(/\s+/, '').downcase
    @flames_sequence = ['F', 'L', 'A', 'M', 'E', 'S']
  end

  def calculate
    # Find common letters and their counts
    common_letters = find_common_letters
    
    # Calculate step counts for each name
    person1_steps = calculate_step_count(@name1, common_letters)
    person2_steps = calculate_step_count(@name2, common_letters)
    combined_steps = person1_steps + person2_steps

    # Run FLAMES iterations for each
    person1_result = run_flames_iterations(person1_steps)
    person2_result = run_flames_iterations(person2_steps)
    combined_result = run_flames_iterations(combined_steps)

    {
      person1: {
        name: @name1,
        steps: person1_steps,
        result: person1_result[:letter],
        meaning: FLAMES_MEANINGS[person1_result[:letter]][:meaning],
        tip: FLAMES_MEANINGS[person1_result[:letter]][:tip],
        tarot_message: FLAMES_MEANINGS[person1_result[:letter]][:tarot_message],
        debug_info: person1_result[:debug_info]
      },
      person2: { 
        name: @name2,
        steps: person2_steps,
        result: person2_result[:letter],
        meaning: FLAMES_MEANINGS[person2_result[:letter]][:meaning],
        tip: FLAMES_MEANINGS[person2_result[:letter]][:tip],
        tarot_message: FLAMES_MEANINGS[person2_result[:letter]][:tarot_message],
        debug_info: person2_result[:debug_info]
      },
      combined: {
        steps: combined_steps,
        result: combined_result[:letter],
        meaning: FLAMES_MEANINGS[combined_result[:letter]][:meaning],
        tip: FLAMES_MEANINGS[combined_result[:letter]][:tip],
        tarot_message: FLAMES_MEANINGS[combined_result[:letter]][:tarot_message],
        debug_info: combined_result[:debug_info]
      }
    }
  end

  private

  def find_common_letters
    name1_chars = @name1.chars
    name2_chars = @name2.chars
    
    common = []
    name1_chars.each do |char|
      if name2_chars.include?(char) && !common.include?(char)
        common << char
      end
    end
    
    common
  end

  def calculate_step_count(name, common_letters)
    total_count = 0
    
    common_letters.each do |letter|
      count_in_name = name.count(letter)
      total_count += count_in_name
    end
    
    total_count == 0 ? 1 : total_count # Avoid zero steps
  end

  def run_flames_iterations(step_count)
    landed_letters = []
    
    # Run 12 iterations to collect letter frequencies
    12.times do |iteration|
      # Start position for this iteration
      start_position = iteration % @flames_sequence.length
      
      # Calculate final position after step_count steps
      final_position = (start_position + step_count - 1) % @flames_sequence.length
      
      # Record the letter we landed on
      landed_letters << @flames_sequence[final_position]
    end
    
    # Find the most frequent letter(s) and handle ties
    result = find_winner_with_tiebreaker(landed_letters, step_count)
    
    {
      letter: result[:winner],
      debug_info: result[:debug_info]
    }
  end

  def find_winner_with_tiebreaker(landed_letters, step_count)
    # Count frequency of each letter
    frequency = Hash.new(0)
    landed_letters.each { |letter| frequency[letter] += 1 }
    
    # Find the maximum frequency
    max_frequency = frequency.values.max
    
    # Get all letters with the maximum frequency
    tied_letters = frequency.select { |_, freq| freq == max_frequency }.keys.sort
    
    debug_info = {
      frequency_count: frequency,
      max_frequency: max_frequency,
      tied_letters: tied_letters,
      tiebreaker_used: false
    }
    
    # If there's only one winner, return it
    if tied_letters.length == 1
      return {
        winner: tied_letters.first,
        debug_info: debug_info
      }
    end
    
    # If there are multiple letters with the same frequency, run tiebreaker
    debug_info[:tiebreaker_used] = true
    
    # Create a mini FLAMES sequence with only the tied letters
    tiebreaker_sequence = tied_letters
    
    # Run one final iteration with the step count
    final_position = (step_count - 1) % tiebreaker_sequence.length
    winner = tiebreaker_sequence[final_position]
    
    debug_info[:tiebreaker_sequence] = tiebreaker_sequence
    debug_info[:tiebreaker_position] = final_position
    debug_info[:tiebreaker_winner] = winner
    
    {
      winner: winner,
      debug_info: debug_info
    }
  end
end