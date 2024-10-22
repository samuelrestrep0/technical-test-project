exports.getUsers = (req, res) => {
    const users = [
      { id: 1, name: 'John Doe' },
      { id: 2, name: 'Jane Doe' },
    ];
    res.json(users);
  };
  