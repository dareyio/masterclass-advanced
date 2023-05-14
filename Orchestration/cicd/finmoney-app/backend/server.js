const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

// Create an instance of Express
const app = express();

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect('mongodb://mongo:27017/finmoneydb', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((error) => {
    console.error('Failed to connect to MongoDB', error);
  });

// Define a sample API route for money transfer
app.post('/api/transfer', async (req, res) => {
  // Handle money transfer logic
  // ...
});

// Define API route for login
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;

  // Perform login validation and authentication logic
  if (username === 'admin' && password === 'admin') {
    // Valid credentials, login successful
    res.json({ message: 'Login successful' });
  } else {
    // Invalid credentials, login failed
    res.status(401).json({ error: 'Invalid credentials' });
  }
});

// Start the server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server started on port ${port}`);
});
