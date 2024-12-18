import express from "express";
const app = express();

var port = 5000;
app.get("/", (req, res) => {
  res.send("API Endpoint is served");
});

app.listen(port, console.log(`Server is running on port: ${port}`));
