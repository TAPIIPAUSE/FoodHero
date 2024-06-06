const express = require("express");

const app = express();

const port = 3000;

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

//api
app.get("/", (req, res) => {
  res.send("Hello FoodHero! 🍜");
});
