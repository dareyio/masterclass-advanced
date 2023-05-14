db = db.getSiblingDB('finmoneydb');

// Create a collection for accounts
db.createCollection('accounts');

// Insert sample account data
db.accounts.insertMany([
  {
    name: 'Dare Olufunmilayo',
    accountNumber: '1234567890',
    balance: 5000
  },
  {
    name: 'Jamiu Ayinde',
    accountNumber: '0987654321',
    balance: 35000
  },
  {
    name: 'Fred Achiever Okereke',
    accountNumber: '0987654321',
    balance: 35000
  }
]);
