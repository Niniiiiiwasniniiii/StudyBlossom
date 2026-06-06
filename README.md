# 🌸 StudyBlossom

A full-featured study planner for high school students, built with Python & Streamlit.
Uses **Google Gemini AI** (free!) for flashcards and quizzes.

## ✨ Features

- 📚 **Subjects** — 12 built-in subjects + add your own custom subjects
- ✅ **Task tracker** — tasks with priorities and due dates per subject
- 🍅 **Pomodoro timer** — focus/break timer with session tracking
- 🎯 **Goals** — set and track study goals with deadlines
- 🔔 **Reminders** — set study reminders by subject, time, and day
- 🃏 **AI Flashcards** — upload notes → Gemini generates flashcards instantly
- 📝 **AI Quiz** — auto-generated quizzes from your study material
- 🔥 **Streak badge** — tracks your daily study streak
- 💬 **Motivation quotes** — rotating inspirational quotes


##  Get Your Gemini API Key


1. Go to **https://aistudio.google.com/app/apikey**
2. Sign in with your Google account
3. Click **"Create API key"**
4. Copy the key 


## 🚀 Run Locally

### 1. Install dependencies
```bash
pip install -r requirements.txt
```

### 2. Set your Gemini API key

# Windows
set GEMINI_API_KEY=AIza...
```

### 3. Run the app
```bash
streamlit run app.py (or whatever the name you have saved it as/file location)
```

Opens at `http://localhost:8501` 🌸
however this only works when you have your cmd opened. read below for a permanent one!
---

## ☁️ Deploy to Streamlit Cloud ( Sharing!)

### Step 1: Push to GitHub
```bash
git init
git add .
git commit -m "🌸 StudyBlossom "
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/study-blossom.git
git push -u origin main
```

### Step 2: Deploy
1. Go to **https://share.streamlit.io**
2. Sign in with GitHub
3. Click **"New app"** → select your repo → file: `app.py` (my case it was, StudyBlossom.py)
4. Under **Advanced settings → Secrets**, add:
   ```
   GEMINI_API_KEY = ...
   ```
5. Click **Deploy!**

Your shareable link will look like:
`https://studyblossm.streamlit.app/` 🎉
(i customised it! you can too!)
---

## 📁 Project Structure

```
study_planner/
├── app.py              ← Main app
├── requirements.txt    ← Dependencies
├── README.md           ← This file
├── .gitignore          ← Keeps secrets safe
└── .streamlit/
    └── secrets.toml    ← Local secrets (never commit this!)
```

Made with 💖 and Python
