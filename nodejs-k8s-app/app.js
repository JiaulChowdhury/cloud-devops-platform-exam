const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.send('Hello, this is a memory-hungry Node.js application!');
});

app.get('/crash', (req, res) => {
    const memoryLeak = [];
    while (true) {
        memoryLeak.push(new Array(1000000).fill('OOM test'));
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
