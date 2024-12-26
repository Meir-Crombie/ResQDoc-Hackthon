import express from "express";
import multer from "multer";
import { createReadStream } from "fs";
import crypto from "crypto";
import {
  getWhissperClient,
  getJsonFieldsFilled,
  formatModelResponse,
  logWithTimestamp,
  getSummeryFilled,
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
      prompt: `
      You are provided with an hebrew audio conversation, transcript it into hebrew transcript.
      If the values are numbers such as אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע עשר אפס transcript it to an regular number representation like 1 2 3 4 5 6 7 8 9 0 etc
      If the numbers are in a row, make sure to write it a single number rather single digits all by themselves

      here is an example
      "אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע"
      Im expecting you to provide the transcript as:
      "123456789"

      If the numbers are not in a row, for example there is a stop between the digits and the conversation switched, present it as a digits and not as single number
      `,
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
      prompt: `
      You are provided with an hebrew audio conversation, transcript it into hebrew transcript.
      If the values are numbers such as אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע עשר אפס transcript it to an regular number representation like 1 2 3 4 5 6 7 8 9 0 etc
      If the numbers are in a row, make sure to write it a single number rather single digits all by themselves

      here is an example
      "אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע"
      Im expecting you to provide the transcript as:
      "123456789"

      If the numbers are not in a row, for example there is a stop between the digits and the conversation switched, present it as a digits and not as single number
      `,
      file: createReadStream(audioFilePath),
    });
    console.log(resultText);

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
      prompt: `
      You are provided with an hebrew audio conversation, transcript it into hebrew transcript.
      If the values are numbers such as אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע עשר אפס transcript it to an regular number representation like 1 2 3 4 5 6 7 8 9 0 etc
      If the numbers are in a row, make sure to write it a single number rather single digits all by themselves

      here is an example
      "אחת שתיים שלוש ארבע חמש שש שבע שמונה תשע"
      Im expecting you to provide the transcript as:
      "123456789"

      If the numbers are not in a row, for example there is a stop between the digits and the conversation switched, present it as a digits and not as single number
      `,
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

app.get("/showCase", async (req, res) => {
  try {
    logWithTimestamp("=============== ShowCase Endpoint ===============");
    logWithTimestamp("Step One: Getting audio file ...");
    // Only on production
    logWithTimestamp("Step Two: Connecting to Whissper Model ...");
    logWithTimestamp("Step Three: Processsing audio transcript ...");

    logWithTimestamp("Step Four: Transcript succefully been generated ...");
    const result = await getJsonFieldsFilled(`
    יש עוד סיכום - חובש 1: שלום, אתה שומע אותי?
פצוע: (בקול חלש) כן...
חובש 1: איך קוראים לך?
פצוע: אורי.
חובש 1: אורי, בן כמה אתה?
פצוע: 22.
חובש 1: אתה זוכר מה קרה?
פצוע: לא ממש… הרגשתי סחרחורת, ופתאום אני פה.

חובש 2: יש לך כאבים? איפה?
פצוע: בעיקר בבטן... מאז אתמול בערב זה כואב.
חובש 2: ושלשולים? הקאות?
פצוע: כן, שלשולים… כל הלילה.

חובש 1: תוכל לומר לי את מספר תעודת הזהות שלך?
פצוע: אה… לא בטוח, רגע… (מגמגם).
חובש 1: לא נורא, אל תדאג. אם תזכור, תגיד לי.

חובש 2: מדדים ראשוניים: לחץ דם 100 על 60, דופק 110. נשימות 22 לדקה, העור חיוור וקר. אורי, שתית מים היום?
פצוע: לא ממש… אולי קצת בבוקר.

(אמא מגיעה למקום): מה קורה איתו? הוא בסדר?
חובש 1: הוא בהכרה, אבל מאוד חלש. כנראה מיובש, ויש לו כאבים בבטן ושלשולים מאז הלילה.
אמא: אוי, הוא אמר לי אתמול שהוא לא מרגיש טוב, אבל לא ידעתי שזה כזה חמור.
חובש 1: יש לך את תעודת הזהות שלו? זה יכול לעזור לנו בהמשך.
אמא: בטח, שנייה… (מחפשת בארנק) הנה, 123456789.
חובש 1: תודה רבה.

חובש 2: אורי, יש לך כאבים נוספים חוץ מהבטן? משהו בראש?
פצוע: נפלתי על הרצפה… אני חושב שקצת קיבלתי מכה בראש.
חובש 1: (בוחן) יש קצת נפיחות במצח, אבל לא נראה חתכים. תוכל לזוז קצת?
פצוע: כן, אבל הכול מסתובב לי.

חובש 2: (לאמא) מה הוא אכל או שתה בימים האחרונים?
אמא: כמעט כלום, הוא לא היה עם תיאבון… אמר שהיה עייף ורק שתה קפה בבוקר.
חובש 2: זה מסביר את ההתייבשות. הוא חייב נוזלים מיידית ובדיקות נוספות בבית חולים.

חובש 1: אורי, תנסה לשתות שלוק מים לאט. איך אתה מרגיש?
פצוע: קצת פחות מסוחרר, אבל עדיין לא בסדר.

אמא: אני יכולה לבוא איתו באמבולנס?
חובש 1: בטח. אנחנו נעלה אותו על האלונקה וניקח אתכם יחד.

סיכום האירוע:
פצוע בן 22 נמצא יושב ברחוב לאחר עילפון. בהגעת הצוות היה בהכרה מלאה אך חלש מאוד, חיוור, מזיע ומתלונן על כאבים בבטן ושלשולים מאז הלילה.
לדבריו, נפל קדימה במהלך העילפון, יש נפיחות במצח ושפשופים קלים ביד ימין. לחץ דם 100/60, דופק 110, חום קל (37.8).
האמא מסרה מספר תעודת זהות: 123456789.
המטופל פונה להמשך טיפול בבית החולים כשהאם מתלווה אליו.
    `);

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

app.post("/summary", express.json(), async (req, res) => {
  try {
    logWithTimestamp("=============== Summary Endpoint ===============");
    console.log(req.body);
    if (!req.body) {
      return res.status(400).json({ error: "No JSON data provided" });
    }

    const jsonData = req.body;

    if (!jsonData.response) {
      return res.status(400).json({ error: "No 'response' field in JSON" });
    }
    logWithTimestamp("Step One: JSON data received and processed");
    logWithTimestamp("Step Two: Transcript succefully been generated ...");
    const result = await getSummeryFilled(jsonData);
    const formattedResult = formatModelResponse(result);
    logWithTimestamp(
      "Step Eight: Formatting info data into proper JSON file ..."
    );
    logWithTimestamp("Step Ten: Server responded");
    res.setHeader("Content-Type", "application/json");
    res.send(formattedResult);
  } catch (error) {
    logWithTimestamp("Error processing JSON:", error.message);
    res.status(500).json({ error: "Failed to process JSON data" });
  }
});
app.listen(port, () => logWithTimestamp(`Server is running on port: ${port}`));
