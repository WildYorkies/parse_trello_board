require 'json'
require 'csv'

filename = ARGV.first

cards = Array.new
lists = Hash.new
members = Hash.new
custom_fields = Hash.new

File.open(filename, 'r') do | f |
  
  json = f.read
  board = JSON.parse(json)
  
  # Build lists hash
  board['lists'].each { | list | lists[list['id']] = list['name'] }
  # Build members hash
  board['members'].each { | member | members[member['id']] = member['fullName'] }
  # Build custom_fields hash
  board['pluginData'].each do | data |
    values = JSON.parse(data['value'])
    values['fields'].each do | value |
      custom_fields[value['id']] = value['n']
    end
  end
  # Build cards array 
  cards = board['cards']

end

cards.each do | card |

  # Enrich card data
  card['listName'] = lists[card['idList']]
  card['memberNames'] = card['idMembers'].map { |mem| members[mem] }

  custom_fields.values.each { | field | card[field] = nil }
  unless card['pluginData'].empty?
    card['pluginData'].each do | data |
      cust_fields = JSON.parse(data['value'])
      cust_fields['fields'].each do | key, val |
        card[custom_fields[key.to_i]] = val
      end
    end
  end

  # Delete the unwanted data
  card.delete("idList") { |el| "#{el} not found" }
  card.delete("idMembers") { |el| "#{el} not found" }
  card.delete("checkItemStates") { |el| "#{el} not found" }
  card.delete("closed") { |el| "#{el} not found" }
  card.delete("dateLastActivity") { |el| "#{el} not found" }
  card.delete("descData") { |el| "#{el} not found" }
  card.delete("idBoard") { |el| "#{el} not found" }
  card.delete("idMembersVoted") { |el| "#{el} not found" }
  card.delete("idShort") { |el| "#{el} not found" }
  card.delete("idAttachmentCover") { |el| "#{el} not found" }
  card.delete("manualCoverAttachment") { |el| "#{el} not found" }
  card.delete("pos") { |el| "#{el} not found" }
  card.delete("shortLink") { |el| "#{el} not found" }
  card.delete("badges") { |el| "#{el} not found" }
  card.delete("email") { |el| "#{el} not found" }
  card.delete("shortUrl") { |el| "#{el} not found" }
  card.delete("subscribed") { |el| "#{el} not found" }
  card.delete("pluginData") { |el| "#{el} not found" }

end

CSV.open('trello_cards.csv', 'wb') do | csv |
  csv << cards.first.keys
  cards.each do | card |
    csv << card.values
  end
end
