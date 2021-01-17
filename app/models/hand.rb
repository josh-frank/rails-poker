#                    A,  2,  3,  4,  5,  6,  7,  8,  9, 10,  J,  Q,  K,  A
#    clubs = [ nil, 49,  1,  5,  9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49 ]
# diamonds = [ nil, 50,  2,  6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50 ]
#   hearts = [ nil, 51,  3,  7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51 ]
#   spades = [ nil, 52,  4,  8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52 ]

class Hand < ApplicationRecord

    validates :deck_min, numericality: { greater_than: 0, less_than: :deck_max }
    validates :deck_max, numericality: { greater_than: :deck_min, less_than_or_equal_to: 52 }

    after_create :deal
    after_create :not_drawn_yet
    
    def size; self.cards_array.size; end
    
    def cards_array
        self.cards[ 1...-1 ].split( ", " ).map( &:to_i  )
    end

    def hold_array
        return [] if self.hold_cards.nil?
        self.hold_cards[ 1...-1 ].split( ", " ).map( &:to_i  )
    end

    def deck
        ( self.deck_min..self.deck_max ).to_a.reject{ | card_in_deck | self.hold_array.include?( card_in_deck ) }.shuffle
    end

    def card_names
        self.cards_array.map{ | card | Hand.card_names[ card ] }
    end
    
    def to_s
        self.card_names.join( ", " )
    end

    def rank
        HandRank.get( self.cards_array )
    end
    
    def value
        HandRank.category_key( self.rank )
    end
    
    def value_name
        self.value.capitalize.gsub( "_", " " )
    end

    def draw
        raise StandardError.new "Already drawn!" if self.drawn == 1
        self.update( cards: self.hold_array )
        self.update( cards: self.cards_array + self.deck.pop( 5 - self.hold_array.size ) )
        self.update( drawn: true )
    end

    def possible_holds( number_of_hold_cards )
        self.cards_array.size.times.to_a.combination( number_of_hold_cards ).to_a.map{ | hold | hold.map{ | index | self.cards_array[ index ] } }
    end

    def all_possible_holds
        ( 0..self.size ).to_a.collect{ | hold_size | self.possible_holds( hold_size ) }.flatten( 1 )
    end

    def possible_hands( possible_hold )
        deck = ( self.deck_min..self.deck_max ).to_a.reject{ | card_in_deck | possible_hold.include?( card_in_deck ) }
        deck.combination( self.size - possible_hold.length ).to_a.map{ | hand | hand.concat( possible_hold ) }
    end

    def best_hold
        hold_averages = self.all_possible_holds.map do | possible_hold |
            possibility = self.possible_hands( possible_hold )
            [ possible_hold, possibility.sum{ | hand | HandRank.get( hand ) } / possibility.length.to_f ]
        end
        hold_averages.to_h.max_by{ | hold, average | average }.first
    end

    def self.card_names
        ["2 of ", "3 of ", "4 of ", "5 of ", "6 of ", "7 of ", "8 of ", "9 of ", "10 of ", "Jack of ", "Queen of ", "King of ", "Ace of " ].product( [ "Clubs", "Diamonds", "Hearts", "Spades" ] ).map( &:join ).unshift( nil )
    end

    private

    def deal
        self.update( cards: ( self.deck_min..self.deck_max ).to_a.shuffle.pop( 5 ).to_s )
    end
        
    def not_drawn_yet
        self.update( drawn: false )
    end

end
