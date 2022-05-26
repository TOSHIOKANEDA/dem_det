carriers = [ "ONE", "Wan Hai", "Hapag", "Sinotrans", "JJ"]
0.upto(carriers.size) {|c|
  break if carriers[c].blank?
  name = carriers[c]
  Carrier.create!(name: name, active_flg: 0)
}