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
  AiModelNotes: {},
};

//The Whissper Ai connection object
const WhissperManager = {
  endpoint:
    "https://ai-bakuradz3720ai884010610452.openai.azure.com/openai/deployments/whisper/audio/transcriptions?api-version=2024-06-01",
  apiKey:
    "2A8YacGI00iW1Q7sVM6SwuJp9B2f65vgm07WO4oU6kclqy2kTrShJQQJ99BAACHYHv6XJ3w3AAAAACOGNVIv",
};

// Required Azure OpenAI deployment name and API version
const apiVersion = "2024-08-01-preview";
const deploymentName = "whisper";

//The fieled auto fill Ai connection object
const GroqManager = new Groq({
  apiKey: "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",
});

function getWhissperClient() {
  return new AzureOpenAI({
    endpoint: WhissperManager.endpoint,
    apiKey: WhissperManager.apiKey,
    apiVersion,
    deployment: deploymentName,
  });
}

//Converts the values to a JSON
function extractAndParseJSON(input) {
  try {
    // Extract content between backticks
    const jsonMatch = input.match(/```([\s\S]*?)```/);
    if (!jsonMatch) throw new Error("No JSON found between backticks");

    // Clean the string
    const jsonString = jsonMatch[1]
      .replace(/^Here is.*?:\n*/g, "") // Remove header text
      .replace(/\n/g, "") // Remove newlines
      .trim(); // Remove extra whitespace

    // Parse to JSON
    return JSON.parse(jsonString);
  } catch (error) {
    throw new Error(`Failed to parse JSON: ${error.message}`);
  }
}

const GroqPrompt = `You are a medical data extraction system.
Given a trascript which simulates a trascript of a medical call, Extract information from the Hebrew transcript and fill the medical form template.
the template is a json object which is structured like that:
${JSON.stringify(medicalTemplate, null, 2)}

In the AiModelNotes tag, it would be you ONLY place that you are able to place your comments about the response.
Since im converting you response into a JSON object, i need you response to be clean with not comments out side of the JSON structure
If you has something to add and share, you can craete a new tag inside of the AiModelNotes tag, that inside of its you can place you string of content and comment about the response

When you give me the JSON object it self, please put it inside of the \`\`\`\`\`\` mark, in order for me then get the actual response using regex and to convert it into a valid JSON formated reponse

Make sure to fit the values properly to thier field's
Use empty string for missing information.
All values should be in Hebrew.
If you dont know the values, please write that u dont know to analye is rather to say random values

I have a specifcal request about the "anamnesis" field, dont skip it! ITS IMPORTANT:
Create a detailed medical anamnesis by organizing the provided information as follows: start with patient identification, then describe symptom timeline and progression, state the chief complaint, list relevant medical history and medications, detail current status including vital signs, and end with treatments given and patient response. Use professional medical language and present as flowing paragraphs.
Here is an example of an trascript and a good response which i request from you to provide:
The trascript:
יוסי מאיחוד הצלה. שלום, מה שלומך? איך אני יכול לעזור לך? אני מרגיש לחץ חזק בחזה, זה התחיל לפני בערך חצי שעה. שם מלא בבקשה. חיים לוי. תעודת זהות? 123456789. בן כמה אתה? 58. כתובת? רחוב הרצל 25, ירושלים. האם יש לך רקע רפואי כלשהו או מחלות רקע? כן, יש לי סוכרת ולחץ דם גבוה. האם אתה נוטל תרופות? כן, גלוקומין ולוסרטן. האם אתה מעשן? כן, בערך קופסה ביום. האם יש לך אלרגיות לתרופות או חומרים אחרים? לא. אתה זוכר מתי הייתה הפעם האחרונה שאכלת או שתית? אכלתי ארוחת בוקר בערך בשמונה בבוקר, שתיתי קפה לפני שעה. הלחץ בחזה מלווה בהקרנה ליד שמאל או ללסת? כן, זה מקרין ליד שמאל וללסת.
האם אתה מרגיש סחרחורת או קוצר נשימה? כן, יש לי תחושת סחרחורת וקצת קשה לי לנשום. האם יש לך היסטוריה של בעיות בלב או התקף לב? לא, אף פעם לא היה לי התקף לב. האם זה התחיל תוך כדי מאמץ או במנוחה? זה התחיל בזמן שהייתי במנוחה, ישבתי בבית על הספה. האם אתה מרגיש כאב נוסף או תופעות נלוות אחרות? כן, אני מרגיש חולשה חזקה וזיעה קרה.
בדיקת מדדים: לחץ דם 145/95. דופק 110. רמת סוכר 210. חמצן בדם 92%. המטופל במצב יציב אך נראה סובל מאוד.

The response in JSON which im expecting you to deliver (It starts and end in """ mark):

"""
Here is your response:

\`\`\`
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
      "anamnesis": "חיים לוי, בן 58, פנה עקב תחושת לחץ חזק בחזה שהחלה במנוחה, עם הקרנה ליד שמאל וללסת, מלווה בסחרחורת, קוצר נשימה, חולשה וזיעה קרה. רקע רפואי כולל סוכרת ולחץ דם גבוה, מעשן כקופסה ביום, לוקח גלוקומין ולוסרטן. בדיקות: לחץ דם 145/95, דופק 110, סוכר 210, סטורציה 92%.",
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
\`\`\`
Note that .....

"""

This is how am i expectin you to deliver the response
        `;
//Getting the values from the Ai filed in the JSON fields
async function GetJSONFiled(txt) {
  try {
    const completion = await GroqManager.chat.completions.create({
      messages: [
        {
          role: "system",
          content: GroqPrompt,
        },
        {
          role: "user",
          content: `Here is the transcript which im requesting from you to provide the JSON by its values: ${txt}`,
        },
      ],
      model: "llama3-8b-8192",
    });
    console.log(completion.choices[0].message.content);
    return extractAndParseJSON(completion.choices[0].message.content);
  } catch (err) {
    logWithTimestamp(`ERROR: Location: Func-GetJSONFiled, Msg:${err}`);
    throw new Error("GetJSONFiled: Unable to analyze the transcript");
  }
}

//Returns the JSON form filled with partial values to show case the product in the Hackathon
async function FinalVersionFormFilled(trans) {
  try {
    logWithTimestamp("Step Five: Connecting to Groq -> llama3 Model ...");
    logWithTimestamp("Step Six: Processing form filling ...");

    const completion = await GroqManager.chat.completions.create({
      messages: [
        {
          role: "system",
          content: `
You are about to get a hebrew speech of an indevidual about a medical event, it would include values of the following subjects:
Full name,
(Israeli)Id
(In israel)City
Allergies - (Either does he have an allergie or not)
Type of pain
blood presure

im expecting you to return a JSON formated response which the keys would be the fields and the corresponding values for the keys would fit the fields
Here is the structure of the JSON repsonse file:
{
  "name": "",
  "age": "",
  "id": "",
  "city": "",
  "allergies": "",
  "pain": "",
  "bloodPressure": ""
}

The values that you'll expect from the request would be categorized by the fields
here is the dataset for each field, the options are saparated by the | sign:

name: דניאל כהן | משה גת | יוסי לוי | דן בנט
age: 20 | 13 | 47 | 60
id:  1234 | 6758 | 4879 | 5193
city: ירושלים | צפת | אשקלון | תל אביב
allergies: כן | לא
pain: ראש | כתף | יד שבורה | דימום
bloodPressure:  180/40 | 160/70 | 120/35 | 90/130

To help you analize better the given request, here are two samples of speechs that you'll might recive and the response json that im expecting you to deliver in these cases

Case 1:
The Request
שלום, מה השם שלך דניאל כהן בן כמה אתה 20 תעודת זהות בבקשה? 1234 מאיפה אתה ירושלים יש לך אלרגיות כלשהן כן איפה כואב לך בכתף
לחץ הדם שלך נמדד, זה 160 על 70 בסדר תודה, אני אעביר את המידע לצוות
The expected response:
{
  "name": "דניאל כהן",
  "age": 20,
  "id": "1234",
  "city": "ירושלים",
  "allergies": "כן",
  "pain": "כתף",
  "bloodPressure": "160/70"
}

Case 2:
The reqeust
שלום, מה השם שלך משה גת בן כמה אתה 13 תעודת זהות בבקשה 4879 מאיפה אתה צפת יש לך אלרגיות כלשהן לא
איפה כואב לך בראש לחץ הדם שלך נמדד זה 120 על 35 בסדר תודה אני אעביר את המידע לצוות
The expected response
  {
    "name": "משה גת",
    "age": 13,
    "id": 4879,
    "city": "צפת",
    "allergies": "לא",
    "pain": "ראש",
    "bloodPressure": "120/35"
  },
        `,
        },
        {
          role: "user",
          content: `Here is the transcript which im requesting from you to provide the JSON by its values: ${trans}`,
        },
      ],
      model: "llama3-8b-8192",
    });
    logWithTimestamp("Step Seven: Form data been recived succefully ...");
    return completion.choices[0].message.content;
  } catch (e) {
    console.log(e);
  }
}

async function processTextWithLlama(text) {
  try {
    const completion = await GroqManager.chat.completions.create({
      messages: [
        {
          role: "system",
          content: `
          This is a WhatsApp group chat logs of the college group Im willing to make a funny summery for this year in context of the group
          Your task is to provide a funny summery for each meaninful user which was participating noticly in the group Provide a funny summery
          for each user as shown in hebrew which would be funny and driven by the context of that particular's user's messages`,
        },
        {
          role: "user",
          content: text,
        },
      ],
      model: "llama-3.3-70b-versatile",
    });
    return completion.choices[0].message.content;
  } catch (err) {
    logWithTimestamp(`ERROR: Location: Func-processTextWithLlama, Msg:${err}`);
    throw new Error("processTextWithLlama: Unable to process the text");
  }
}

export {
  getWhissperClient,
  GetJSONFiled,
  logWithTimestamp,
  FinalVersionFormFilled,
  processTextWithLlama, // Export the new function
};
