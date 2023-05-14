import React from 'react';
import Login from './components/login.js';
import MoneyTransfer from './components/MoneyTransfer';

function App() {
  const isLoggedIn = true; // Set this value based on your authentication logic

  return (
    <div className="app">
      {isLoggedIn ? <MoneyTransfer /> : <Login />}
    </div>
  );
}

export default App;
