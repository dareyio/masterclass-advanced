const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.urlencoded({ extended: false }));

// In-memory array to store todo items
let todos = [];

// Serve the static files in the public directory
app.use(express.static('public'));

// Route to get all todos
app.get('/todos', (req, res) => {
  res.send(todos);
});

// Route to create a new todo
app.post('/todos', (req, res) => {
  const todo = {
    id: todos.length + 1,
    title: req.body.title,
    completed: false,
  };
  todos.push(todo);
  res.redirect('/');
});

// Route to update a todo
app.put('/todos/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const todo = todos.find((todo) => todo.id === id);
  if (!todo) {
    return res.status(404).send('Todo not found');
  }
  todo.completed = req.body.completed;
  res.send(todo);
});

// Route to delete a todo
app.delete('/todos/:id', (req, res) => {
  const id = parseInt(req.params.id);
  todos = todos.filter((todo) => todo.id !== id);
  res.status(204).send();
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
