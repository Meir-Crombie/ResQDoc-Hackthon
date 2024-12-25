import { AzureOpenAI } from "openai";
import Groq from "groq-sdk";

//This function prints to the screen with the current time
function logWithTimestamp(message) {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${message}`);
}

//The template of the form
export const medicalTemplate = {
  patientDetails: {
    idOrPassport: "",
    firstName: "",
    lastName: "",
    age: "",
    gender: "",
    city: "",
    street: "",
    houseNumber: "",
    phone: "",
    email: "",
  },
  smartData: {
    findings: {
      diagnosis: "",
      patientStatus: "",
      mainComplaint: "",
      anamnesis: "",
      medicalSensitivities: "",
      statusWhenFound: "",
      CaseFound: "",
    },
    medicalMetrics: {
      bloodPressure: { value: "", time: "" },
      "Heart Rate": "",
      "Lung Auscultation": "",
      consciousnessLevel: "",
      breathingRate: "",
      breathingCondition: "",
      skinCondition: "",
      lungCondition: "",
      CO2Level: "",
    },
  },
};

//The Whissper Ai connection object
const Whissper = {
  endpoint:
    "https://bakur-m52vpsgt-swedencentral.openai.azure.com/openai/deployments/whisper/audio/transcriptions?api-version=2024-06-01",
  apiKey:
    "7vwrlTuBlvTSTJ8AqFj2JbCZZhjkM2LslT8bNKldnJbu2qMNwdiZJQQJ99ALACfhMk5XJ3w3AAAAACOG16Ho",
};
// Required Azure OpenAI deployment name and API version
const apiVersion = "2024-08-01-preview";
const deploymentName = "whisper";

//The fieled auto fill Ai connection object
const groq = new Groq({
  apiKey: "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",
});

function getWhissperClient() {
  return new AzureOpenAI({
    endpoint: Whissper.endpoint,
    apiKey: Whissper.apiKey,
    apiVersion,
    deployment: deploymentName,
  });
}

//Getting the values from the Ai filed in the JSON fields
async function getJsonFieldsFilled(txt) {
  logWithTimestamp("Step Five: Connecting to Groq -> llama3 Model ...");
  logWithTimestamp("Step Six: Processing form filling ...");
  const completion = await groq.chat.completions.create({
    messages: [
      {
        role: "system",
        content: `
You are a medical data extraction system.
Given a trascript which simulates a trascript of a medical call, Extract information from the Hebrew transcript and fill the medical form template.
the template is a json object which is structured like that:
${medicalTemplate}
Return a JSON object and only a JSON object because im taking the result and converting into JSON object, dont provide any comments and if u really need put it in a new JSON key-value pair called "notations", which matching the template structure with extracted values which fit the template's fields context.
Make sure to fit the values properly to thier field's
Use empty string for missing information.
All values should be in Hebrew.
If you dont know the values, please write that u dont know to analye is rather to say random values


Here is an example of an trascript and a good response which i request from you to provide:

The trascript:
יוסי מאיחוד הצלה. שלום, מה שלומך? איך אני יכול לעזור לך? אני מרגיש לחץ חזק בחזה, זה התחיל לפני בערך חצי שעה. שם מלא בבקשה. חיים לוי. תעודת זהות? 123456789. בן כמה אתה? 58. כתובת? רחוב הרצל 25, ירושלים. האם יש לך רקע רפואי כלשהו או מחלות רקע? כן, יש לי סוכרת ולחץ דם גבוה. האם אתה נוטל תרופות? כן, גלוקומין ולוסרטן. האם אתה מעשן? כן, בערך קופסה ביום. האם יש לך אלרגיות לתרופות או חומרים אחרים? לא. אתה זוכר מתי הייתה הפעם האחרונה שאכלת או שתית? אכלתי ארוחת בוקר בערך בשמונה בבוקר, שתיתי קפה לפני שעה. הלחץ בחזה מלווה בהקרנה ליד שמאל או ללסת? כן, זה מקרין ליד שמאל וללסת.
האם אתה מרגיש סחרחורת או קוצר נשימה? כן, יש לי תחושת סחרחורת וקצת קשה לי לנשום. האם יש לך היסטוריה של בעיות בלב או התקף לב? לא, אף פעם לא היה לי התקף לב. האם זה התחיל תוך כדי מאמץ או במנוחה? זה התחיל בזמן שהייתי במנוחה, ישבתי בבית על הספה. האם אתה מרגיש כאב נוסף או תופעות נלוות אחרות? כן, אני מרגיש חולשה חזקה וזיעה קרה.
בדיקת מדדים: לחץ דם 145/95. דופק 110. רמת סוכר 210. חמצן בדם 92%. המטופל במצב יציב אך נראה סובל מאוד.

The response in JSON which im expecting you to deliver:

{
  "patientDetails": {
    "idOrPassport": "123456789",
    "firstName": "חיים",
    "lastName": "לוי",
    "age": "58",
    "gender": "זכר",
    "city": "ירושלים",
    "street": "הרצל",
    "houseNumber": "25",
    "phone": "",
    "email": ""
  },
  "smartData": {
    "findings": {
      "diagnosis": "חשד לאירוע לבבי",
      "patientStatus": "יציב אך סובל",
      "mainComplaint": "לחץ חזק בחזה עם הקרנה ליד שמאל וללסת",
      "anamnesis": "סובל מסוכרת ולחץ דם גבוה, מעשן קופסה ביום, נוטל גלוקומין ולוסרטן",
      "medicalSensitivities": "אין רגישויות ידועות",
      "statusWhenFound": "תעוקת חזה",
      "CaseFound": "חשד לאירוע לבבי"
    },
    "medicalMetrics": {
      "bloodPressure": { "value": "145/95", "time": "" },
      "Heart Rate": "110",
      "Lung Auscultation": "תקין",
      "consciousnessLevel": "מלאה",
      "breathingRate": "לא ידוע",
      "breathingCondition": "קוצר נשימה",
      "skinCondition": "מזיע זיעה קרה", 
      "lungCondition": "",
      "CO2Level": "92"
    }
  }
}
        `,
      },
      {
        role: "user",
        content: `Here is the transcript which im requesting from you to provide the JSON by its values: ${txt}`,
      },
    ],
    model: "llama3-8b-8192",
  });
  logWithTimestamp("Step Seven: Form data been recived succefully ...");
  return completion.choices[0].message.content;
}

//Converting to a valid value
function formatModelResponse(modelResponse) {
  try {
    // Initialize response structure
    let formattedResponse = {
      response: {},
    };

    // Split response by newlines to separate JSON and notes
    const lines = modelResponse.split("\n");
    let jsonStartIndex = -1;
    let jsonEndIndex = -1;
    let noteCounter = 65; // ASCII for 'A'

    // Find JSON boundaries
    lines.forEach((line, index) => {
      if (line.trim().startsWith("{")) jsonStartIndex = index;
      if (line.trim().endsWith("}")) jsonEndIndex = index;
    });

    // Extract and parse JSON
    if (jsonStartIndex !== -1 && jsonEndIndex !== -1) {
      const jsonString = lines
        .slice(jsonStartIndex, jsonEndIndex + 1)
        .join("\n");
      formattedResponse.response = JSON.parse(jsonString);
    }

    // Add notes
    lines.forEach((line, index) => {
      if (index < jsonStartIndex || index > jsonEndIndex) {
        const trimmedLine = line.trim();
        if (
          trimmedLine &&
          !trimmedLine.startsWith("{") &&
          !trimmedLine.endsWith("}")
        ) {
          formattedResponse[`Note${String.fromCharCode(noteCounter)}`] =
            trimmedLine;
          noteCounter++;
        }
      }
    });

    return JSON.stringify(formattedResponse, null, 2);
  } catch (error) {
    throw new Error(`Failed to format response: ${error.message}`);
  }
}

export {
  getWhissperClient,
  formatModelResponse,
  getJsonFieldsFilled,
  logWithTimestamp,
};
