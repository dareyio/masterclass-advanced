import React, { useState } from 'react';
import axios from 'axios';

function MoneyTransfer() {
  const [amount, setAmount] = useState('');
  const [recipient, setRecipient] = useState('');

  const handleTransfer = async () => {
    try {
      const transferData = {
        amount: parseFloat(amount),
        recipient: recipient
      };

      const response = await axios.post('/api/transfer', transferData);
      console.log('Transfer response:', response.data);

      setAmount('');
      setRecipient('');
    } catch (error) {
      console.error('Error:', error);
    }
  };

  return (
    <div className="money-transfer">
      <h2>Money Transfer</h2>
      <input
        type="text"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <input
        type="text"
        placeholder="Recipient"
        value={recipient}
        onChange={(e) => setRecipient(e.target.value)}
      />
      <button onClick={handleTransfer}>Transfer</button>
    </div>
  );
}

export default MoneyTransfer;
