require 'csv'
require 'colorize'

# p String.colors
rows = []

CSV.foreach('tweets.csv', headers: true) do |data|
  rows.push(data) if (data["retweeted_status_id"] == "")
end

puts "rows: #{rows.size}"
rows.each do |row|
  row['text'].downcase!
end

hit_rows = rows

while true
  print "> "
  words = gets.chomp.split(' ')
  command = words[0]
  case command
    when "search"
      if (words.size != 2) then
        puts "引数が不正です"
      else
        search_word = words.slice(1..(words.size-1)).join(" ")
        puts "#{search_word} で検索します".light_green
        hit_rows = rows.find_all { |item| item['text'].include?(search_word) }
        hit_rows.each_with_index do |row, index|
          print "#{index + 1}) ".light_blue
          print row['text'].gsub(/(\r\n|\r|\n)/, " ").slice(0, 100)
          puts ""
        end
        puts "hit rows: #{hit_rows.count}"
      end
    when "exit"
      exit
    else
      puts "command not found"
  end
end
