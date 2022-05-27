CARRIERS = [ "ONE", "WanHai", "Hasco", "Sinotrans", "JJ"]
MAX = 999999
items = ['carrier','free_calc']

CARRIERS.each do |c|
  items.push(c.downcase)
end

items.each do |i|
  path = Rails.root.join("db/seeds", i + ".rb")
  if File.exist?(path)
    require path
  end
end
