class HandsController < ApplicationController
  
  def hold
    hand_to_hold = Hand.find( params[ :id ] )
    hold_card = hand_to_hold.cards_array[ params[ :hold_card ].to_i ]
    if hand_to_hold.hold_array.include?( hold_card )
      hand_to_hold.update( hold_cards: hand_to_hold.hold_array - Array.new( 1, hold_card ) )
    else
      hand_to_hold.update( hold_cards: hand_to_hold.hold_array.push( hold_card ) )
    end
    redirect_to hand_path( hand_to_hold )
  end
  
  def draw
    hand_to_draw = Hand.find( params[ :id ] )
    hand_to_draw.draw
    redirect_to hand_path( hand_to_draw )
  end

  def deal
    new_deal = Hand.create( hold_cards: [], deck_min: 1, deck_max: 52 )
    redirect_to hand_path( new_deal )
  end
  
  def show
    @this_hand = Hand.find( params[ :id ] )
  end
  
end
