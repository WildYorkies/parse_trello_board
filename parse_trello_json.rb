require 'json'
require 'csv'

filename = ARGV.first

done_list_id = '557061bda6ad0c1728f88ba2'
migrated_cards = Array.new
lists = Hash.new
members = Hash.new

File.open(filename, 'r') do | f |
  
  json = f.read
  board = JSON.parse(json)
  
  board['lists'].each do | list |
   lists[list['id']] = list['name']
  end 

  board['members'].each do | member |
   members[member['id']] = member['fullName']
  end 

  migrated_cards = board["cards"].find_all do | card |
    card['idList'] == done_list_id
  end

end

migrated_cards.each do | card |

  # Enrich card data
  card['listName'] = lists[card['idList']]
  card['memberNames'] = card['idMembers'].map { |mem| members[mem] }

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

end

CSV.open('migrated_cards.csv', 'wb') do | csv |
  
  csv << migrated_cards.first.keys
  
  migrated_cards.each do | card |
    csv << card.values
  end

end
