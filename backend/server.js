import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import {
  getWhissperClient,
  getJsonFieldsFilled,
  formatModelResponse,
  logWithTimestamp,
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

// function logWithTimestamp(message) {
//   const timestamp = new Date().toISOString();
//   console.log(`[${timestamp}] ${message}`);
// }

logWithTimestamp(`Server starting in dev mode`);

app.get("/", (req, res) => {
  res.send("API Endpoint is served");
});

// API Endpoint: POST Upload audio and initiate transcription
app.post("/transcribe", upload.single("audio"), async (req, res) => {
  try {
    logWithTimestamp("=============== Transcribe Endpoint ===============");
    logWithTimestamp("Step One: Getting audio file ...");
    if (!req.file) {
      return res.status(400).send("No audio file uploaded");
    }
    const audioFilePath = req.file.path;

    logWithTimestamp("Step Two: Connecting to Whissper Model ...");
    const client = getWhissperClient();

    logWithTimestamp("Step Three: Processsing audio transcript ...");
    const result = await client.audio.transcriptions.create({
      model: "whisper",
      language: "he",
      prompt: "Provide the text result in hebrew",
      file: createReadStream(audioFilePath),
    });

    logWithTimestamp("Step Four: Transcript succefully been generated ...");
    logWithTimestamp("Step Five: Server responded");
    res.json({ text: result.text });
  } catch (err) {
    logWithTimestamp("Error initiating transcription:", err.message);
    res.status(500).send("Server Error");
  }
});

app.post("/analyze", upload.single("audio"), async (req, res) => {
  try {
    logWithTimestamp("=============== Analyze Endpoint ===============");
    if (!req.file) {
      return res.status(400).send("No audio file uploaded");
    }
    logWithTimestamp("Step One: Getting audio file ...");
    // Only on production
    const audioFilePath = req.file.path;
    logWithTimestamp("Step Two: Connecting to Whissper Model ...");
    const client = getWhissperClient();

    logWithTimestamp("Step Three: Processsing audio transcript ...");
    const resultText = await client.audio.transcriptions.create({
      model: "whisper",
      language: "he",
      prompt: "Provide the text result in hebrew",
      file: createReadStream(audioFilePath),
    });

    logWithTimestamp("Step Four: Transcript succefully been generated ...");
    const result = await getJsonFieldsFilled(resultText.text);

    logWithTimestamp(
      "Step Eight: Formatting info data into proper JSON file ..."
    );
    const formattedResult = formatModelResponse(result);

    logWithTimestamp(
      "Step Nine: Form data been converted into JSON succefully ..."
    );
    logWithTimestamp("Step Ten: Server responded");
    res.setHeader("Content-Type", "application/json");
    res.send(formattedResult);
  } catch (err) {
    logWithTimestamp("Error analyzing transcript:", err.message);
    res.status(500).send("Server Error");
  }
});

app.get("/analyzeDemo", async (req, res) => {
  try {
    logWithTimestamp("=============== Analyze Endpoint ===============");
    logWithTimestamp("Step One: Getting audio file ...");
    // Only on production
    const audioFilePath = "./AudioFinal.m4a";
    logWithTimestamp("Step Two: Connecting to Whissper Model ...");
    const client = getWhissperClient();

    logWithTimestamp("Step Three: Processsing audio transcript ...");
    const resultText = await client.audio.transcriptions.create({
      model: "whisper",
      language: "he",
      prompt: "Provide the text result in hebrew",
      file: createReadStream(audioFilePath),
    });

    logWithTimestamp("Step Four: Transcript succefully been generated ...");
    const result = await getJsonFieldsFilled(resultText.text);

    logWithTimestamp(
      "Step Eight: Formatting info data into proper JSON file ..."
    );
    const formattedResult = formatModelResponse(result);

    logWithTimestamp(
      "Step Nine: Form data been converted into JSON succefully ..."
    );
    logWithTimestamp("Step Ten: Server responded");
    res.setHeader("Content-Type", "application/json");
    res.send(formattedResult);
  } catch (err) {
    logWithTimestamp("Error analyzing transcript:", err.message);
    res.status(500).send("Server Error");
  }
});

app.listen(port, () => logWithTimestamp(`Server is running on port: ${port}`));
