import express from "express";
import dotenv from "dotenv";
import { SpeechClient } from "@google-cloud/speech";
import multer from "multer";
import fs from "fs";
import util from "util";

// Init the .env file
dotenv.config();

// The port is allocated from the .env file, otherwise it would be 5000
const port = process.env.PORT || 5000;
console.log(port);

const app = express();

// Configure multer for file uploads
const upload = multer({ dest: "uploads/" });

// Initialize Google Cloud Speech client
const speechClient = new SpeechClient();

// API Endpoint: GET Upload test and return
app.get("/", (req, res) => {
  res.send("API Endpoint is served");
});

// API Endpoint: POST Upload audio and get transcription
app.post("/transcribe", upload.single("audio"), async (req, res) => {
  try {
    const filePath = req.file.path;

    // Read the audio file
    const file = fs.readFileSync(filePath);
    const audioBytes = file.toString("base64");

    // Configure the request for Google Cloud Speech-to-Text
    const request = {
      audio: {
        content: audioBytes,
      },
      config: {
        encoding: "LINEAR16", // Adjust based on your audio file format
        sampleRateHertz: 16000, // Adjust based on your audio file sample rate
        languageCode: "he-IL", // Hebrew language code
      },
    };

    // Transcribe the audio
    const [response] = await speechClient.recognize(request);
    const transcription = response.results
      .map((result) => result.alternatives[0].transcript)
      .join("\n");

    // Clean up the uploaded file
    const unlinkFile = util.promisify(fs.unlink);
    await unlinkFile(filePath);

    res.json({ transcription });
  } catch (err) {
    console.error("Error transcribing audio:", err);
    res.status(500).send("Server Error");
  }
});

app.listen(port, () => console.log(`Server is running on port: ${port}`));
