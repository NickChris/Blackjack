suits = ["Hearts", "Diamonds", "Spades", "Clubs"]
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']

deck = cards.product(suits)
deck.shuffle!

#Starting Cards
player_hand = []
dealer_hand = []

player_total = 0
dealer_total = 0

2.times do
	player_hand << deck.pop
end

2.times do
	dealer_hand << deck.pop
end

#Totalling cards

def calc_total(cards) #cards = player's or dealer's array of cards
	hand = cards.map{ |x| x[0] }
	total = 0

	hand.each do |val|
		if val == 'Ace'
			if total + 11 > 21
				total += 1
			else 
				total += 11
			end
		elsif val.to_i == 0
			total += 10
		else
			total += val.to_i
		end
	end

	total
end


#Output
puts "----- Dealer hand -----"
puts dealer_hand[0][0] + " of " + dealer_hand[0][1]
puts dealer_hand[1][0] + " of " + dealer_hand[1][1]

puts "==> Dealer's total is #{calc_total(dealer_hand)}" 
puts

puts "----- Player hand -----"
puts player_hand[0][0] + " of " + player_hand[0][1]
puts player_hand[1][0] + " of " + player_hand[1][1]
	
puts "==> Your total is #{calc_total(player_hand)} "
puts

#hit or stay loop
card_counter = 1
while calc_total(player_hand) <= 21
	puts "==> Would you like to 1) Hit or 2) Stay?"
  hit_choice = gets.chomp
  if hit_choice == '1'
  	player_hand << deck.pop
  	card_counter += 1
  	puts player_hand[card_counter][0] + " of " + player_hand[card_counter][1]
  	puts "==> Your total is #{calc_total(player_hand)} "
  	if calc_total(player_hand) > 21
  		puts "==> Sorry you bust!"
  		break
  	end
  elsif hit_choice == '2'
  	puts "==> You stand with #{calc_total(player_hand)}"
  	card_counter = 1
  	while calc_total(dealer_hand) < 17
  		puts "==> Dealer has #{calc_total(dealer_hand)} and must hit..."
  		dealer_hand << deck.pop
  		card_counter += 1
  		puts dealer_hand[card_counter][0] + " of " + dealer_hand[card_counter][1]
  		puts "==> Dealer now has #{calc_total(dealer_hand)}"
  	end
  	puts
		if calc_total(player_hand) > calc_total(dealer_hand)
			puts "==> You have #{calc_total(player_hand)} and Dealer has #{calc_total(dealer_hand)}"
			puts "==> You Win!!!"
		elsif calc_total(player_hand) == calc_total(dealer_hand)
			puts "==> #{calc_total(player_hand)} to #{calc_total(dealer_hand)}"
			puts "==> It is a push."
		else
			puts "==> Sorry, Dealer wins with #{calc_total(dealer_hand)}"
		end
  	break
  else
  	puts "==> Please enter 1 for 'hit or 2 for 'stay'"
  end
end


