import openai

# הגדרת פרמטרים של Azure OpenAI
openai.api_type = "azure"
openai.api_base = "https://yitsh-m52s9raw-swedencentral.openai.azure.com/"  # כתובת ה-Endpoint שלך
openai.api_version = "2024-05-01-preview"  # גרסת ה-API המתאימה
openai.api_key = "8LjsqhK7Ga6NCNqGUgdb6Z16Tbx6MmEbwXpQOzRRfyatj4EGsYtAJQQJ99ALACfhMk5XJ3w3AAAAACOGcrjj"  # הכנס את מפתח ה-API שלך

def chat_with_ai(prompt, model_deployment="gpt-4"):
    """
    פונקציה לניהול שיחה עם Azure OpenAI
    :param prompt: הודעת המשתמש
    :param model_deployment: שם ה-Deployment
    :return: תגובת המודל או הודעת שגיאה
    """
    try:
        response = openai.ChatCompletion.create(
            engine=model_deployment,
            messages=[
                {"role": "system", "content": """You are a helpful assistant. prompt = Generate three trivia questions in the following JSON format:  

{
  "triviaQuestions": [
    {
      "id": 1,
      "question": "Your question here",
      "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
      "correctAnswerIndex": 0
    },
    {
      "id": 2,
      "question": "Your question here",
      "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
      "correctAnswerIndex": 0
    },
    {
      "id": 3,
      "question": "Your question here",
      "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
      "correctAnswerIndex": 0
    }
  ]
}

Ensure the questions and correct answers are valid."""
},
                {"role": "user", "content": ""},
            ]
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"An error occurred: {str(e)}"

def test_chat():
    """
    תכנית בדיקה המאפשרת למשתמש לנהל שיחה עם הצ'אט.
    """
    print("Welcome to the Azure OpenAI Chatbot! Type 'exit' to quit.")
    while True:
        user_input = input("You: ")
        if user_input.lower() == "exit":
            print("Goodbye!")
            break
        response = chat_with_ai(user_input)
        print(f"AI: {response}")

if __name__ == "__main__":
    # הפעלת תכנית הבדיקה
    test_chat()
