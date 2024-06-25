global.config = require("./config.json");
const express = require("express");
const app = express();
app.use(express.json());
const port = 3000;

console.log(global.config);


app.post('/product/add', (req, res) => {
    res.send("WORKS");
});

app.post('/product/update', (req, res) => {
    res.send("WORKS");
});

app.post('/product/delete', (req, res) => {
    res.send("WORKS");
});

app.post('/variant/add', (req, res) => {
    res.send("WORKS");
});

app.post('/variant/delete', (req, res) => {
    res.send("WORKS");
});



app.get('/', (req, res) => {
    res.send("WORKS");
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`);
});