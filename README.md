# Angkiki's Telebot

### TODO:
1. Read incoming user
2. Check current user's command
  * if under Initiators, expect /save
  * ensure that [amount] is a float
  * else, expect Initiators
3. Respond according to current user's command
  * if Initiators, prompt for /save [amount] [description]
  * if /save, respond back with recorded details
  * else, expect Initiators

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
