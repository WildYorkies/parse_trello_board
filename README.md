# Don't want to pay for Trello Business Class just to get your board data in CSV?

Use this script to download your card data!

It will even grab your custom fields (new trello power up) and put them in their own column!

## Instructions

Go to your Trello board. Click:

- "Show Menu" in the upper right
- "More"
- "Print and Export"
- "Export JSON"

Download this ruby script and place it in the same directory as your JSON file.

Open your command prompt or terminal and run

`ruby parse_trello_json.rb yourJSONfile.json`

You will find that there is now a CSV file called `trello_cards.csv` in the same directory as other files.

Open an issue if you have one!
