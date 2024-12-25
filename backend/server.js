import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import {
  getWhissperClient,
  getJsonFieldsFilled,
  formatModelResponse,
} from "./config/openAI.js";

const port = process.env.PORT || 5000;
const app = express();

//Configuration of the local storgae
const storage = multer.diskStorage({
  destination: "uploads/",
  filename: function (req, file, cb) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
    const random = crypto.randomBytes(4).toString("hex");
    const originalName = file.originalname;
    cb(null, `${timestamp}_${random}_${originalName}`);
  },
});
const upload = multer({ storage: storage });

console.log(`Server starting in ${env} mode`);

app.get("/", (req, res) => {
  res.send("API Endpoint is served");
});

// API Endpoint: POST Upload audio and initiate transcription
app.post("/transcribe", upload.single("audio"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send("No audio file uploaded");
    }

    // You will need to set these environment variables or edit the following values
    const audioFilePath = req.file.path;
    const client = getWhissperClient();
    const result = await client.audio.transcriptions.create({
      model: "whisper",
      language: "he",
      prompt: "Provide the text result in hebrew",
      file: createReadStream(audioFilePath),
    });
    console.log(res.json(result));

    return res.json(result.text);
  } catch (err) {
    console.error("Error initiating transcription:", err.message);
    res.status(500).send("Server Error");
  }
});

app.post("/analyze", upload.single("audio"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send("No audio file uploaded");
    }
    console.log("Step One");
    // Only on production
    const audioFilePath = req.file.path;
    console.log("Step Two");
    const client = getWhissperClient();
    console.log("Step Three");
    const resultText = await client.audio.transcriptions.create({
      model: "whisper",
      language: "he",
      prompt: "Provide the text result in hebrew",
      file: createReadStream(audioFilePath),
    });
    console.log("Step Foud");
    const result = await getJsonFieldsFilled(resultText.text);
    // res.json(JSON.parse(result));
    console.log("Step Five");
    const formattedResult = formatModelResponse(result);

    console.log("About To return");

    res.setHeader("Content-Type", "application/json");
    res.send(formattedResult);
  } catch (err) {
    console.error("Error analyzing transcript:", err.message);
    res.status(500).send("Server Error");
  }
});

app.listen(port, () => console.log(`Server is running on port: ${port}`));
