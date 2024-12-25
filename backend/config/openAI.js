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

To help you with the adjusment of the values to thier proper, i've provided the fields' descriptions and a case with an expected return value.


Here is the fields' descriptions:

Patient Details (patientDetails)
Basic information for identifying and contacting the patient:

Smart Medical Data (smartData)
A. Findings (findings)
Medical data and a report on the event:

diagnosis: The medical diagnosis provided to the patient or the initial suspicion.
patientStatus: The patient’s condition at the time of examination (e.g., "Stable," "Critical").
mainComplaint: The primary complaint that prompted the medical intervention (e.g., chest pain, difficulty breathing).
anamnesis:
Anamnesis is a chronological review of the patient’s medical history related to the current event.
Structured Template for Anamnesis:
Patient's Name: [Full Name].

Age: [Patient’s Age].

Timeline of the Medical Issue:

[A chronological description of the progression. Example: "Two days ago, mild chest pain began. Yesterday, the pain worsened and was accompanied by shortness of breath. Today, the patient called for medical assistance."].
Medical Procedures Performed:

[A list of procedures such as blood pressure checks, IV fluids, or other tests].
[Example: "Blood pressure measured (120/80), IV fluids administered."].
Volunteer Summary:

Final Status: [Example: "The patient was semi-conscious and transported to the hospital by ambulance." or "The patient refused transportation."].
Personal Conclusion: [Example: "Based on the findings, this may be a mild cardiac event."].
medicalSensitivities: Known medical sensitivities (e.g., "Allergic to penicillin").

statusWhenFound: Description of the patient’s condition when found (e.g., "Unconscious, pale, and cold skin").

CaseFound: A general description which would categorize the current call by what the volunteer saw when arrived (e.g, a woman having a layber, an animal bite, an unconsciousness, a gunshot)

B. Medical Metrics (medicalMetrics)
Measured medical metrics during the event:

bloodPressure:
value: The patient’s blood pressure reading, typically systolic/diastolic (e.g., "120/80").
time: The time when the blood pressure was measured (e.g., "14:35").
Heart Rate: The patient’s heart rate (e.g., "78 bpm").
Lung Auscultation: Findings from a lung examination (e.g., "Clear bilaterally" or "Wheezing in the lower left lobe").
consciousnessLevel: The patient’s level of consciousness (e.g., "Fully conscious," "Drowsy," "Unconscious").
breathingRate: The number of breaths per minute (e.g., "18 breaths per minute").
breathingCondition: Description of breathing status (e.g., "Normal," "Labored").
skinCondition: The condition of the skin (e.g., "Pale," "Cyanotic," "Sweaty").
lungCondition: Description of the lungs (e.g., "Normal," "Fluid in lungs").
CO2Level: The carbon dioxide level in the blood, measured via capnography (e.g., "35 mmHg").


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
