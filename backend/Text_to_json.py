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
                {"role": "system", "content": """You are a helpful assistant.You will receive a Hebrew transcript of a voice recording describing an emergency medical event. Your task is to extract the relevant data and return it in the following JSON format. Only use the specified fields and structure, and ensure accurate and clear mapping of the information.

JSON Format:

{
  "patientDetails": {
    "idOrPassport": "תעודת זהות/דרכון",
    "firstName": "שם פרטי",
    "lastName": "שם משפחה",
    "age": "גיל המטופל",
    "gender": "מין המטופל",
    "city": "יישוב המטופל",
    "street": "רחוב המטופל",
    "houseNumber": "מספר בית המטופל",
    "phone": "טלפון המטופל",
    "email": "דוא\"ל המטופל"
  },
  "smartData": {
    "findings": {
      "diagnosis": "אבחון המקרה שנמצא",
      "patientStatus": "סטטוס המטופל (לדוגמה: יציב/לא יציב)",
      "mainComplaint": "תלונה עיקרית",
      "anamnesis": "אנמנזה וסיפור המקרה",
      "medicalSensitivities": "רגישויות רפואיות"
    },
    "medicalMetrics": {
      "bloodPressure": {
        "value": "לחץ דם",
        "time": "זמן בדיקה"
      },
      "consciousnessLevel": "רמת הכרה",
      "breathingRate": "קצב נשימה",
      "breathingCondition": "מצב הנשימה",
      "skinCondition": "מצב העור",
      "lungAuscultation": "האזנה לריאות",
      "lungCondition": "מצב הריאות (ימנית/שמאלית)",
      "CO2Level": "רמת CO2 (ETCO2)"
    },
    "treatment": "טיפול"
  }
}

Instructions:
1. Only include fields relevant to the transcript. If information is not provided, omit the field.
2. Map the Hebrew transcript data to the appropriate fields in the JSON structure.
3. Ensure the output is valid JSON and contains all extracted details in the specified structure."""
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
