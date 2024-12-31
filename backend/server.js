import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import {
  getWhissperClient,
  GetJSONFiled as GetResJSON,
  logWithTimestamp,
  FinalVersionFormFilled,
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

logWithTimestamp(`Server starting in dev mode`);

app.get("/", (req, res) => res.send("API Endpoint is served"));

const PromptForTranscription = `
You are provided with an hebrew audio conversation, transcript it into hebrew transcript.
If the values are numbers such as אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע עשר אפס transcript it to an regular number representation like 1 2 3 4 5 6 7 8 9 0 etc
If the numbers are in a row, make sure to write it a single number rather single digits all by themselves

Here is an example
"אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע"
Im expecting you to provide the transcript as:
"123456789"

Here is another example:
"תשע שבע ארבע שלוש"
Im expecting you to provide the transcript as:
"9743"

If the numbers are not in a row, for example there is a stop between the digits and the conversation switched, present it as a digits and not as single number`;

//Accepts an audio file path and returns its transcript in Hebrew
const GetAudioTranscription = async (audioPath) => {
  try {
    const client = getWhissperClient();
    const result = await client.audio.transcriptions.create({
      model: "whisper",
      language: "he",
      prompt: PromptForTranscription,
      file: createReadStream(audioPath),
    });
    return result;
  } catch (err) {
    logWithTimestamp(`ERROR: Location: Func-GetAudioTranscription, Msg:${err}`);
    throw new Error("GetAudioTranscription: Unable to transcript the audio");
  }
};

// API Endpoint: POST Upload audio and initiate transcription
app.post("/transcribe", upload.single("audio"), async (req, res) => {
  try {
    logWithTimestamp("=============== Transcribe Endpoint ===============");
    logWithTimestamp("Step One: Getting audio file ...");
    if (!req.file) return res.status(400).send("No audio file uploaded");

    const audioFilePath = req.file.path;
    logWithTimestamp(`Step Two: Audio accepted, File name: ${audioFilePath}`);

    logWithTimestamp(`Step Three: Requesting Transcription`);
    const result = await GetAudioTranscription(audioFilePath);

    logWithTimestamp(`Step Four: Transcription accepted`);
    logWithTimestamp(`Transcription:`);
    console.log(result);

    res.on("finish", () => {
      logWithTimestamp("Step Five: Server responded");
      console.log("===================================================");
    });

    res.json(result);
  } catch (err) {
    logWithTimestamp(`ERROR: Location: POST /transcribe, Msg:${err}`);
    res.on("finish", () => {
      logWithTimestamp("Step Seven: Server responded");
      console.log("===================================================");
    });
    res.status(500);
  }
});

// API Endpoint: POST Upload audio and initiate audio analyzing
app.post("/analyze", upload.single("audio"), async (req, res) => {
  try {
    logWithTimestamp("=============== Analyze Endpoint ===============");
    logWithTimestamp("Step One: Getting audio file ...");
    if (!req.file) return res.status(400).send("No audio file uploaded");

    // Get the trascription
    const audioFilePath = req.file.path;
    logWithTimestamp(`Step Two: Audio accepted, File name: ${audioFilePath}`);

    logWithTimestamp(`Step Three: Requesting Transcription`);
    const resultText = await GetAudioTranscription(audioFilePath);
    logWithTimestamp(`Step Four: Transcription accepted`);
    logWithTimestamp(`Transcription:`);
    logWithTimestamp(JSON.stringify(resultText, null, 2));

    // Get the result JSON
    logWithTimestamp(`Step Five: Requesting an analyze`);
    const result = await GetResJSON(resultText.text);
    logWithTimestamp(`Step Six: Analyze accepted`);
    res.on("finish", () => {
      logWithTimestamp("Step Seven: Server responded");
      console.log("===================================================");
    });
    res.status(200).json(result);
  } catch (err) {
    logWithTimestamp(`ERROR: Location: POST /analyze, Msg:${err}`);
    res.on("finish", () => {
      logWithTimestamp("Step Seven: Server responded");
      console.log("===================================================");
    });
    res.status(500);
  }
});

// API Endpoint: POST Upload a part audio for analyzing (Show case for the finals)
app.post("/final", upload.single("audio"), async (req, res) => {
  try {
    logWithTimestamp("=============== Final Endpoint ===============");
    if (!req.file) return res.status(400).send("No audio file uploaded");
    logWithTimestamp("Step One: Getting audio file ...");
    // Only on production
    const audioFilePath = req.file.path;
    const resultText = GetAudioTranscription(audioFilePath);

    logWithTimestamp("Step Four: Transcript succefully been generated ...");
    const result = await FinalVersionFormFilled(resultText.text);

    logWithTimestamp(
      "Step Eight: Formatting info data into proper JSON file ..."
    );
    const formattedResult = ConvertResponseToJSON(result);
    console.log(result);

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
