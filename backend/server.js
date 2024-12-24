import express from "express";
import dotenv from "dotenv";
import { SpeechClient } from "@google-cloud/speech";
import { Storage } from "@google-cloud/storage";
import multer from "multer";
import fs from "fs";
import util from "util";
import path from "path";

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

// Initialize Google Cloud Storage client
const storage = new Storage();
const bucketName = "resqdoc_bucket";

// API Endpoint: GET Upload test and return
app.get("/", (req, res) => {
  res.send("API Endpoint is served");
});

// API Endpoint: POST Upload audio and get transcription
app.post("/transcribe", upload.single("audio"), async (req, res) => {
  try {
    const filePath = req.file.path;
    const fileName = path.basename(filePath);

    // Upload the audio file to Google Cloud Storage
    await storage.bucket(bucketName).upload(filePath, {
      destination: fileName,
    });

    // Construct the URI for the uploaded file
    const gcsUri = `gs://${bucketName}/${fileName}`;

    // Configure the request for Google Cloud Speech-to-Text
    const request = {
      audio: {
        uri: gcsUri,
      },
      config: {
        encoding: "MP3", // Adjust based on your audio file format
        sampleRateHertz: 16000, // Adjust based on your audio file sample rate
        languageCode: "he-IL", // Hebrew language code
      },
    };

    // Transcribe the audio using long-running recognize
    const [operation] = await speechClient.longRunningRecognize(request);
    const [response] = await operation.promise();
    const transcription = response.results
      .map((result) => result.alternatives[0].transcript)
      .join("\n");

    // Clean up the uploaded file
    const unlinkFile = util.promisify(fs.unlink);
    await unlinkFile(filePath);

    // Optionally, delete the file from Google Cloud Storage
    await storage.bucket(bucketName).file(fileName).delete();

    res.json({ transcription });
  } catch (err) {
    console.error("Error transcribing audio:", err.message);
    console.error(err.stack);
    res.status(500).send("Server Error");
  }
});

app.listen(port, () => console.log(`Server is running on port: ${port}`));
