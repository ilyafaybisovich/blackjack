
deck_cards = [2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,"Jack","Jack","Jack","Jack","Queen","Queen","Queen","Queen","King","King","King","King","Ace","Ace","Ace","Ace"]
deck_suits = ["hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades","hearts","clubs","diamonds","spades"]
deck_values = [2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,1,1,1,1]

def show_hand(player_hand)
  player_hand.each do |card|
    puts card
  end
end

def hit(deck_cards, deck_suits, deck_values, player_hand, player_values, player_suits, player_cards)
  card = deck_cards.sample
  suit = deck_suits[deck_cards.index(card)]
  if card == "Ace"
    value = 1  
  elsif (card == "Jack" || card == "Queen" || card == "King")
    value = 10
  else 
    value = card 
  end
  player_values.push(value)
  player_cards.push(card)
  player_suits.push(suit) 
  player_hand.push("#{card} of #{suit}")
  deck_cards.delete_at(deck_cards.index(card))
  deck_suits.delete_at(deck_suits.index(suit))
  deck_values.delete_at(deck_values.index(value))
end

def score(player_values)
   total = 0
   player_values.each do |value|
     total+=value  
   end
   total += 10 if (total<12 && player_values.include?(1))
   total
end

def mean(deck_values)
  sum = 0
  deck_values.each do |card|
    sum+=card
  end
  mean = sum.to_f/deck_values.length
end

begin
  compare = false
  bust = false
  win = false
  stay = false
  
  you_hand = Array.new
  you_values = Array.new
  you_suits = Array.new
  you_cards = Array.new
  dealer_hand = Array.new
  dealer_values = Array.new
  dealer_suits = Array.new
  dealer_cards = Array.new
  
  hit(deck_cards, deck_suits, deck_values, you_hand, you_values, you_suits, you_cards)
  hit(deck_cards, deck_suits, deck_values, you_hand, you_values, you_suits, you_cards)
  puts "You were initially dealt these cards:"
  show_hand(you_hand)
  puts "Your score is #{score(you_values)}"
  
  begin
    if score(you_values) > 21
      bust = true
    elsif score(you_values) == 21
      win = true
    else 
      begin 
        puts "Do you want to hit or stay? (H/S)"
        decision = gets.chomp.downcase
        if decision ==  'h'
          puts "You decided to hit another card. This is your new hand:"
          hit(deck_cards, deck_suits, deck_values, you_hand, you_values, you_suits, you_cards)
          show_hand(you_hand)
          puts "The score is #{score(you_values)}" 
        elsif decision == 's'
          puts "You decided to stay with the following hand:"
          show_hand(you_hand)
          puts "Your score is #{score(you_values)}"
          puts "It is now the dealer's turn." 
          stay = true
        end
      end until decision == 'h' || decision == 's'
    end
  end until bust || win || stay

  puts "The score is more than 21 so you are bust." if bust
  puts "You hit a blackjack!" if win
  puts stay

  if stay
    begin 
      hit(deck_cards, deck_suits, deck_values, dealer_hand, dealer_values, dealer_suits, dealer_cards)
    end until score(dealer_values) > 17 
    begin    
      if score(dealer_values) > 21
          puts "The dealer busted."
          win = true
      elsif score(dealer_values) == 21
        puts "The dealer hit a blackjack with the following hand:"
        show_hand(dealer_hand)
        bust = true
      elsif score(dealer_values) + mean(deck_values) > 21
        compare = true
      else
        hit(deck_cards, deck_suits, deck_values, dealer_hand, dealer_values, dealer_suits, dealer_cards)  
      end
    end until bust || win || compare
  end

  if compare
    puts "The dealer decided to stay too and you are now going to compare hands." 
    puts "Dealer's hand is"
    show_hand(dealer_hand) 
    puts "Dealer's score is #{score(dealer_values)}."
  end 

  puts "Dealer wins." if bust || (compare && score(you_values)-score(dealer_values)<0)
  puts "You won." if win || (compare && score(you_values)-score(dealer_values)>0)
  puts "There is a standoff" if compare && score(you_values)-score(dealer_values)==0
  puts "Do you want to play again? (Y/N)"
  play_again = gets.chomp.downcase
end while play_again == "y"  