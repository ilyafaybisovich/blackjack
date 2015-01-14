def say(msg)
  puts
  puts msg
end

SUITS = ["Hearts","Clubs","Spades","Diamonds"]
CARDS = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]

deck = SUITS.product(CARDS) 
deck.shuffle!

def show_hand(hand)
  puts 
  hand.each do |card|
    puts "=> #{card[1]} of #{card[0]}"
  end
end

def hit(hand, deck)
  a = deck.pop
  hand << a
end

def score(hand)
  total = 0
  values = []
  value = 0
  hand.each do |card|
    if card[1] == "Ace"
      total += 1 
    elsif (card [1] == "Jack" || card [1] == "Queen" || card [1] == "King")
      total+=10
    else 
      total+=card[1].to_i
    end
  end
  total += 10 if (total<12 && values.include?(1))
  total
end

def mean(deck)
  sum = 0
  deck.each do |card|
    if card[1] == "Ace"
      sum += 1 
    elsif (card [1] == "Jack" || card [1] == "Queen" || card [1] == "King")
      sum+=10
    else 
      sum+=card[1].to_i
    end
  end
  mean = sum.to_f/deck.length
  mean.round(2)
end

def dealer_first_card(hand)
  say ("One of the dealer's cards is")
  say ("=> #{hand[0][1]} of #{hand[0][0]}")
end

begin
  system 'clear'

  your_hand = []
  dealers_hand = []

  compare = false
  bust = false
  win = false
  stay = false
  
  hit(your_hand, deck)
  hit(your_hand, deck)
  puts "You were initially dealt these cards:"
  show_hand(your_hand)
  say("Your score is #{score(your_hand)}.")
  hit(dealers_hand, deck)
  hit(dealers_hand, deck)
  
  begin 
    if score(your_hand) > 21
      bust = true
    elsif score(your_hand) == 21
      win = true
    else 
      begin 
        dealer_first_card(dealers_hand)
        say("The mean face value of the remaining cards is #{mean(deck)}")
        say("Do you want to hit or stay? (H/S)")
        decision = gets.chomp.downcase
        if decision ==  'h'
          system 'clear'
          puts "You decided to hit another card. This is your new hand:"
          hit(your_hand, deck)
          show_hand(your_hand)
          say("Your score is #{score(your_hand)}") 
        elsif decision == 's'
          system 'clear'
          puts "You decided to stay with the following hand:"
          show_hand(your_hand)
          say("Your score is #{score(your_hand)}")
          say("It is now the dealer's turn.") 
          stay = true
        end
      end until decision == 'h' || decision == 's'
    end
  end until bust || win || stay

  say("The score is more than 21 so you are bust.") if bust
  say("You hit a blackjack!") if win

  if stay
    begin    
      if score(dealers_hand) < 17
        hit(dealers_hand, deck)
      elsif score(dealers_hand) > 21
        say("The dealer busted.")
        win = true
      elsif score(dealers_hand) == 21
        say("The dealer hit a blackjack with the following hand:")
        show_hand(dealers_hand)
        bust = true
      elsif (score(dealers_hand) + mean(deck).round(2)) > 21
        compare = true
      else
        hit(dealers_hand, deck) 
      end
    end until bust || win || compare
  end

  if compare
    say("The dealer decided to stay too and you are now going to compare hands.")
    say("Dealer's hand is:")
    show_hand(dealers_hand) 
    say("Dealer's score is #{score(dealers_hand)}.")
  end 

  if bust || (compare && score(your_hand)-score(dealers_hand)<0)
    say("Dealer wins.") 
  end

  if win || (compare && score(your_hand)-score(dealers_hand)>0)
    say("You won.") 
  end

  if compare && score(your_hand)-score(dealers_hand)==0
    say("There is a standoff.")
  end

  say("Do you want to play again? (Y/N)")
  play_again = gets.chomp.downcase
end while play_again == "y" 