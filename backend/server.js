import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import { getWhissperClient } from "./config/openAI.js";

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

app.get("/", (req, res) => res.send("API Endpoint is served"));

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

// API Endpoint: POST Upload audio and initiate transcription
app.post("/getJsonFields", upload.single("audio"), async (req, res) => {
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

app.post("/analyze", async (req, res) => {
  try {
    const { transcript, subjects } = req.body;

    if (!transcript || !subjects) {
      return res.status(400).send("Transcript and subjects are required");
    }

    const result = await extractSubjects(transcript, subjects);
    res.json(JSON.parse(result));
  } catch (err) {
    console.error("Error analyzing transcript:", err.message);
    res.status(500).send("Server Error");
  }
});

// ...existing code...

app.listen(port, () => console.log(`Server is running on port: ${port}`));
