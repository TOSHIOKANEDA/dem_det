items = [
  'carrier',
  'free_calc',
  'one',
  'wanhai'
]

MAX = 999999

items.each do |i|
  path = Rails.root.join("db/seeds", i + ".rb")
  if File.exist?(path)
    require path
  end
end
