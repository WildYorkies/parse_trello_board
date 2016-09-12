# author = github.com/WildYorkies
# license = MIT
# ruby version = 2.2

require 'json'
require 'csv'

board = Hash.new
filename = ARGV.first
File.open(filename, 'r') do |f|
  json = f.read
  board = JSON.parse(json)
end

lists = Hash.new
board['lists'].each { |list| lists[list['id']] = list['name'] }

members = Hash.new
board['members'].each { |member| members[member['id']] = member['fullName'] }

custom_fields = Hash.new
board['pluginData'].each do |data|
  values = JSON.parse(data['value'])
  values['fields'].each do |value|
    custom_fields[value['id']] = value['n']
  end
end

cards = board['cards']
cards.each do |card|

  # Replace IDs for names
  card['listName'] = lists[card['idList']]
  card['memberNames'] = card['idMembers'].map { |mem| members[mem] }
  card['memberNames'] = card['memberNames'].join(' | ')
  card['labelNames'] = card['labels'].map { |label| label['name'] }
  card['labelNames'] = card['labelNames'].join(' | ')
  card['attachmentLinks'] = card['attachments'].map { |att| att['url'] }
  card['attachmentLinks'] = card['attachmentLinks'].join(' | ')
  card['cardLink'] = card['url']
  card['cardReminder'] = card['due']


  # Create keys for custom fields, fill in the value if there is one
  custom_fields.values.each { |field| card[field] = nil }
  unless card['pluginData'].empty?
    card['pluginData'].each do |data|
      cust_fields = JSON.parse(data['value'])
      cust_fields['fields'].each do |key, val|
        card[custom_fields[key.to_i]] = val
      end
    end
  end

  # Delete the unwanted data
  card.delete("attachments") { |el| "#{el} not found" }
  card.delete("url") { |el| "#{el} not found" }
  card.delete("due") { |el| "#{el} not found" }
  card.delete("labels") { |el| "#{el} not found" }
  card.delete("idLabels") { |el| "#{el} not found" }
  card.delete("idList") { |el| "#{el} not found" }
  card.delete("idChecklists") { |el| "#{el} not found" }
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

CSV.open('trello_cards.csv', 'w') do |csv|
  csv << cards.first.keys
  cards.each { |card| csv << card.values }
end
