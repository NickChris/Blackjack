# Totalling card values
def calc_total(cards) #cards = player's or dealer's array of cards
  hand = cards.map{ |x| x[0] }
  total = 0

  hand.each do |val|
    if val == 'Ace'           
      total += 11
    elsif val.to_i == 0     
      total += 10
    else                    
      total += val.to_i
    end
  end

  hand.select{|e| e == 'Ace'}.count.times do
    total -= 10 if total > 21 
  end

  total
end

def say(msg)
  puts "==> #{msg}"
end

puts "~*~*~*~*~*~ Hi and welcome to Blackjack ~*~*~*~*~*~"
say "What is your name?"
player_name = gets.chomp.downcase.capitalize

# Loop to continue game
play_again = true
while play_again == true
  suits = ["Hearts", "Diamonds", "Spades", "Clubs"]
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']

  # Use 3 decks
  deck = []
  3.times do 
    deck << cards.product(suits)
  end
  deck.flatten!(1)
  deck.shuffle!

  #Starting Cards
  player_hand = []
  dealer_hand = []
  player_total = calc_total(player_hand)
  dealer_total = calc_total(dealer_hand)

  2.times{player_hand << deck.pop}
  2.times{dealer_hand << deck.pop}

  #Output initial deal
  puts "------ Dealer's hand ------"
  puts dealer_hand[0][0] + " of " + dealer_hand[0][1]
  puts dealer_hand[1][0] + " of " + dealer_hand[1][1]

  say "Dealer's total is #{calc_total(dealer_hand)}" 
  puts

  puts "------ #{player_name}'s hand ------"
  puts player_hand[0][0] + " of " + player_hand[0][1]
  puts player_hand[1][0] + " of " + player_hand[1][1]
    
  say "#{player_name}'s total is #{calc_total(player_hand)} "
  puts

  # Player hit/stay loop
  if calc_total(player_hand) == 21
    say "Winner! Winner!! You have blackjack!"
  end

  while calc_total(player_hand) < 21
    say "Would you like to 1) Hit or 2) Stay?"
    hit_choice = gets.chomp
    if !['1', '2'].include?(hit_choice)
      puts "Sorry, you must enter 1 or 2"
      next
    elsif hit_choice == '1'
      player_hand << deck.pop
      puts player_hand.last[0] + " of " + player_hand.last[1]
      puts
      say "#{player_name}'s total is #{calc_total(player_hand)}."
        if calc_total(player_hand) == 21
          say "You have 21, and is the dealer's turn."
          break
        elsif calc_total(player_hand) > 21
          say "Sorry #{player_name}, you have busted. Better luck next time."
          puts
          break
        end            
    elsif hit_choice == '2'
      say "#{player_name} stands with #{calc_total(player_hand)}."
      puts
      break
    end
  end

  # Dealer hit/stay loop
  if calc_total(dealer_hand) == 21 && calc_total(player_hand) != 21
    say "Sorry #{player_name}, dealer hit blackjack. You lose."
  end


  while calc_total(dealer_hand) < 17
    say "Dealer has #{calc_total(dealer_hand)} and must hit..."
    dealer_hand << deck.pop
    puts dealer_hand.last[0] + " of " + dealer_hand.last[1] 
    say "Dealer now has #{calc_total(dealer_hand)}."
    puts
    if calc_total(dealer_hand) > 21
      say "Dealer busts with #{calc_total(dealer_hand)}! #{player_name} Wins!!!"
      puts
      break
    end
  end

  if calc_total(player_hand) <= 21 && calc_total(dealer_hand) <= 21
    if (calc_total(player_hand) > calc_total(dealer_hand))
      say "#{player_name} wins with #{calc_total(player_hand)}!!"
    elsif calc_total(player_hand) == calc_total(dealer_hand)
      say "#{calc_total(player_hand)} to #{calc_total(dealer_hand)}"
      say "Game is a push."
    else
      say "Dealer wins with #{calc_total(dealer_hand)}"
    end
  end

  #option to stop play again loop
  choose = true
  while choose == true
    say "Would you like to play again? 1) Yes 2) No"
    play_choice = gets.chomp
    if !['1', '2'].include?(play_choice)
      puts "Sorry, you must enter 1 or 2"
      choose = true
      next 
    elsif play_choice == '1'
      puts
      puts
      choose = false
      play_again = true
      break
    elsif play_choice = '2'
      say "Thanks for playing #{player_name}"
      choose = false
      play_again = false
      break
    end
  end
end