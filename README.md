# Angkiki's Telebot

### TODO:
1. Query: Transaction.where('extract(month from created_at) = ?', 10) for getting all transactions in a month
2. Spendings query command 

### Available Commands:
food - add expense to food
shopping - add expense to shopping
transport - add expense to transport
misc - add expense to misc
save - specify amount & description to save
spendings - total spendings for the current month
cancel - cancel current command

1. Initiators (Categories)
  * /food, /shopping, /misc, transport
2. /save [amount] [description]
  * command state reverts back to /done after this step

### Sequence of Events for Bot:
1. Parse incoming command
2. If valid, check current command step
3. Respond according to current command step and incoming command
