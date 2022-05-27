0.upto(CARRIERS.size) {|c|
  break if CARRIERS[c].blank?
  name = CARRIERS[c]
  Carrier.create!(name: name, active_flg: 0)
}
