Hand.destroy_all
Hand.reset_pk_sequence

started_seeding = Time.now

Hand.create( deck_min: 1, deck_max: 52 )

done_seeding = Time.now

puts "♣️ ♦️ ♥️ ♠️ Seeded: #{ done_seeding - started_seeding } secs. ♣️ ♦️ ♥️ ♠️"
