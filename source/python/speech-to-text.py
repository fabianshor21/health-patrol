import speech_recognition as sr
r = sr.Recognizer()

try:
    with sr.AudioFile('database/health_info/speech-record.wav') as source:
        audio_text = r.listen(source)
        text = r.recognize_google(audio_text, language = "id-ID")
        print(text)
except:
    print('catch_recognizer')

