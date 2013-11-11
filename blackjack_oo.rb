require 'rubygems'
require 'pry'

class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    "#{find_face_value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end

  def find_suit
    ret_suit = case suit
                when 'H' then 'Hearts'
                when 'D' then 'Diamonds'
                when 'S' then 'Spades'
                when 'C' then 'Clubs'
              end
    ret_suit
  end

  def find_face_value
  	ret_val = case face_value
  							when 'J' then 'Jack'
  							when 'Q' then 'Queen'
  							when 'K' then 'King'
  							when 'A' then 'Ace'
  							else
  								face_value
  						end
  	ret_val
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do|card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map{|card| card.face_value }

    total = 0
    face_values.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    face_values.select{|val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Player
	include Hand

	attr_accessor :name, :cards

	def initialize(n)
		@name = n
		@cards = []
	end

	def show_flop
		puts "---- #{name}'s Hand ----"
		puts "First card is #{cards[0]}"
		puts "Second card is #{cards[1]}"
		puts "==> Total is: #{total}"
		puts
	end
end

class Dealer
	include Hand

	attr_accessor :name, :cards

	def initialize
		@name = 'Dealer'
		@cards = []
	end

	def show_flop
		puts "---- Dealer's Hand ----"
		puts "==> Dealer shows #{cards[1]}"
		puts
	end

	def reveal
		puts "Dealer flips his first card over."
		puts "First card is #{cards[0]}"
		puts "Second card is #{cards[1]}"
		puts "==> Total is: #{total}"
		puts
	end
end

class Blackjack
	attr_accessor :deck, :player, :dealer

	BLACKJACK_AMOUNT = 21
	DEALER_HIT_MIN = 17

	def initialize
		@deck = Deck.new
		@player = Player.new("Player1")
		@dealer = Dealer.new
	end

	def set_player_name
		puts "What is your name?"
		player.name = gets.chomp.downcase.capitalize
		puts
	end

	def deal_cards
		player.add_card(deck.deal_one)
		dealer.add_card(deck.deal_one)
		player.add_card(deck.deal_one)
		dealer.add_card(deck.deal_one)
	end

	def show_flop
		player.show_flop
		dealer.show_flop
	end
	def blackjack_or_bust?(player_or_dealer)
		if player_or_dealer.total == Blackjack::BLACKJACK_AMOUNT
			if player_or_dealer.is_a?(Dealer)
				puts "Sorry, dealer hit blackjack. #{player.name} loses."
			else
				puts "==> Congratulations, #{player.name} hit blackjack! You win!"
				puts
			end
			new_game?(player)

		elsif player_or_dealer.is_busted?
			if player_or_dealer.is_a?(Dealer)
				puts "==> Congratulations, dealer busted! #{player.name} wins!"
				puts
			else
				puts "==> Sorry, #{player.name} busted. #{player.name} loses."
				puts
			end
			new_game?(player)
		end			
	end
		
	def player_turn
		puts "#{player.name}'s turn."

	  blackjack_or_bust?(player)

	  while !player.is_busted?
	    puts "Would you like to 1) Hit or 2) Stay?"
	    response = gets.chomp
	    puts

	    if !['1', '2'].include?(response)
	      puts "Sorry, you must enter 1 or 2"
	      next
	    end
	    
	    if response == '2'
	    	puts "==> #{player.name} stays with #{player.total}."
	    	break
	    end

	    new_card = deck.deal_one
	    puts "Dealing card to #{player.name}: #{new_card}"
	    player.add_card(new_card)
	    puts "==> #{player.name}'s total is now: #{player.total}"

	    blackjack_or_bust?(player)
	  end
	end

	def dealer_turn		
		puts "Dealer's turn."
		puts
		dealer.reveal

		blackjack_or_bust?(dealer)

		while dealer.total < DEALER_HIT_MIN
	    puts "Dealer has #{dealer.total} and must hit..."
	    new_card = deck.deal_one
	    puts "Dealing card to dealer: #{new_card}"
	    dealer.add_card(new_card)
	    puts "Dealer total is now: #{dealer.total}"
			puts	    
	    blackjack_or_bust?(dealer)
	  end
	  puts "Dealer stays with #{dealer.total}"
	end

	def who_won?
    if player.total > dealer.total
      puts "==> #{player.name} wins with #{player.total}!!"
    elsif player.total == dealer.total
      puts "#{player.total} to #{dealer.total}"
      puts "==> Game is a push."
    else
      puts "==> Dealer wins with #{dealer.total}"
	  end
	end

	def new_game?(player)
		puts "Would you like to play again? 1) Yes 2) No"
		new_game = gets.chomp
		puts

		if !['1', '2'].include?(new_game)
      puts "Sorry, you must enter 1 or 2"
      new_game?(player)
    end
	    
    if new_game == '1'   
    #done this way so player didnt have to enter name each new game
    	deck = Deck.new
    	player.cards = []
    	dealer.cards = []
    	deal_cards
    	show_flop
			player_turn
			dealer_turn
			who_won?
			new_game?(player)
    end

  	puts "==> Thanks for playing #{player.name}"
    exit
	end

	def start
		set_player_name
		deal_cards
		show_flop
		player_turn
		dealer_turn
		who_won?
		new_game?(player)

	end
end

game = Blackjack.new
game.start