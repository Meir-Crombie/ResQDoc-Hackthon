import { AzureOpenAI } from "openai";
const endpoint =
  "https://bakur-m52vpsgt-swedencentral.openai.azure.com/openai/deployments/whisper/audio/transcriptions?api-version=2024-06-01";
const apiKey =
  "7vwrlTuBlvTSTJ8AqFj2JbCZZhjkM2LslT8bNKldnJbu2qMNwdiZJQQJ99ALACfhMk5XJ3w3AAAAACOG16Ho";

// Required Azure OpenAI deployment name and API version
const apiVersion = "2024-08-01-preview";
const deploymentName = "whisper";
function getClient() {
  return new AzureOpenAI({
    endpoint,
    apiKey,
    apiVersion,
    deployment: deploymentName,
  });
}

//This function returns JSON of the fields
export async function extractSubjects(transcript, subjects) {
  const client = getClient();

  const completion = await client.chat.completions.create({
    model: "gpt-35-turbo",
    messages: [
      {
        role: "system",
        content:
          "Extract specific information from the transcript based on given subjects. Return a JSON object where keys are subjects and values are relevant information from the transcript.",
      },
      {
        role: "user",
        content: `Transcript: "${transcript}"\nSubjects: ${subjects.join(
          ", "
        )}`,
      },
    ],
    response_format: { type: "json_object" },
  });

  return completion.choices[0].message.content;
}
export { getClient };
