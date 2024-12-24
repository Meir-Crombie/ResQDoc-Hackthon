import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import { getWhissperClient, getJsonFieldsFilled } from "./config/openAI.js";

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

    // Only on production
    // const audioFilePath = req.file.path;
    // const client = getWhissperClient();
    // const resultText = await client.audio.transcriptions.create({
    //   model: "whisper",
    //   language: "he",
    //   prompt: "Provide the text result in hebrew",
    //   file: createReadStream(audioFilePath),
    // });
    // const resultJson = await getJsonFieldsFilled(resultText.text);

    const hardCodedTrans = `יוסי מאיחוד הצלה. שלום, מה שלומך? אני לא מרגיש טוב, יש לי חום גבוה כבר יומיים וקוצר נשימה. שם מלא? רונית ישראלי. תעודת זהות? 789456123. גיל? 72. כתובת? רחוב הנשיא 15, חיפה. האם יש מחלות רקע? כן, יש לי אסתמה כרונית ויתר לחץ דם. האם את נוטלת תרופות? כן, אני נוטלת ונטולין וקרדילוק. האם יש אלרגיות? אני אלרגית לאנטיביוטיקה מסוג פניצילין.
בדיקת מדדים: חום 39.1. לחץ דם 135/90. דופק 120. חמצן בדם 88%. המטופלת במצב יציב אך נראית עייפה ונאבקת לנשום.`;
    const resultJson = await getJsonFieldsFilled(hardCodedTrans);
    res.json(JSON.parse(resultJson));
  } catch (err) {
    console.error("Error analyzing transcript:", err.message);
    res.status(500).send("Server Error");
  }
});

app.listen(port, () => console.log(`Server is running on port: ${port}`));
