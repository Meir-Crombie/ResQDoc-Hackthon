import { AzureOpenAI } from "openai";
const endpoint =
  "https://bakur-m52qaj9o-eastus2.cognitiveservices.azure.com/openai/deployments/whisper/audio/transcriptions?api-version=2024-06-01";
const apiKey =
  "FAcc8bJXrvh6ZA3Bh22r9hYonU4HehnZPTNDj5bNChUrCotnMthTJQQJ99ALACHYHv6XJ3w3AAAAACOG4lUF";

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
export { getClient };
