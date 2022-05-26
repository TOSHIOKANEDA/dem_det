items = [
  'carrier',
  'free_calc',
  'one'
]

items.each do |i|
  path = Rails.root.join("db/seeds", i + ".rb")
  if File.exist?(path)
    require path
  end
end
