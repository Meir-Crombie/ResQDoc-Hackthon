import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import { getClient } from "./config/openAI.js";

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
    const client = getClient();
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

app.listen(port, () => console.log(`Server is running on port: ${port}`));
