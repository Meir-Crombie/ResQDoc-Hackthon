import { AzureOpenAI } from "openai";

const Whissper = {
  endpoint:
    "https://bakur-m52vpsgt-swedencentral.openai.azure.com/openai/deployments/whisper/audio/transcriptions?api-version=2024-06-01",
  apiKey:
    "7vwrlTuBlvTSTJ8AqFj2JbCZZhjkM2LslT8bNKldnJbu2qMNwdiZJQQJ99ALACfhMk5XJ3w3AAAAACOG16Ho",
};

const GPT4 = {
  endpoint:
    "https://bakur-m52vpsgt-swedencentral.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-08-01-preview",
  apiKey:
    "7vwrlTuBlvTSTJ8AqFj2JbCZZhjkM2LslT8bNKldnJbu2qMNwdiZJQQJ99ALACfhMk5XJ3w3AAAAACOG16Ho",
};

// Required Azure OpenAI deployment name and API version
const apiVersion = "2024-08-01-preview";
const deploymentName = "whisper";
function getWhissperClient() {
  return new AzureOpenAI({
    endpoint: Whissper.endpoint,
    apiKey: Whissper.apiKey,
    apiVersion,
    deployment: deploymentName,
  });
}

// Create separate client for GPT-4
function getGPT4Client() {
  return new AzureOpenAI({
    endpoint: GPT4.endpoint,
    apiKey: GPT4.apiKey,
    apiVersion,
    deployment: "gpt-4", // Make sure this matches your GPT-4 deployment name
  });
}

export { getWhissperClient, getGPT4Client };
