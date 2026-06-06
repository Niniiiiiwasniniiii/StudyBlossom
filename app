import streamlit as st
import json
import os
import time
import random
from datetime import datetime, date, timedelta
import google.generativeai as genai

# ── Page config ──────────────────────────────────────────────────────────────
st.set_page_config(
    page_title="StudyBlossom 🌸",
    page_icon="🌸",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ── Cute pink theme CSS ───────────────────────────────────────────────────────
st.markdown("""
<style>
@import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Quicksand:wght@400;600;700&display=swap');

html, body, [class*="css"] {
    font-family: 'Nunito', sans-serif;
}

/* Pastel pink gradient background */
.stApp {
    background: linear-gradient(135deg, #fff0f5 0%, #fce4ec 30%, #f8bbd9 60%, #fff0f5 100%);
    background-attachment: fixed;
}

/* Sidebar */
[data-testid="stSidebar"] {
    background: linear-gradient(180deg, #ff8fab 0%, #ffb3c6 50%, #ffc8dd 100%) !important;
    border-right: none;
}
[data-testid="stSidebar"] * { color: #5a0028 !important; font-family: 'Nunito', sans-serif !important; }
[data-testid="stSidebar"] .stRadio label { font-weight: 700; font-size: 15px; }

/* Cards */
.pink-card {
    background: rgba(255, 255, 255, 0.85);
    border-radius: 20px;
    padding: 1.5rem;
    margin-bottom: 1rem;
    border: 2px solid #ffb3c6;
    box-shadow: 0 4px 15px rgba(255, 143, 171, 0.2);
    backdrop-filter: blur(10px);
}
.pink-card-dark {
    background: linear-gradient(135deg, #ff8fab, #ffb3c6);
    border-radius: 20px;
    padding: 1.5rem;
    margin-bottom: 1rem;
    color: white;
    box-shadow: 0 4px 20px rgba(255, 107, 157, 0.4);
}
.metric-card {
    background: rgba(255,255,255,0.9);
    border-radius: 16px;
    padding: 1.2rem;
    text-align: center;
    border: 2px solid #ffc8dd;
    box-shadow: 0 3px 12px rgba(255,143,171,0.2);
}
.metric-card h3 { font-size: 2rem; margin: 0; color: #c9184a; }
.metric-card p  { margin: 0; color: #ff4d6d; font-weight: 700; font-size: 0.85rem; }

/* Buttons */
.stButton > button {
    background: linear-gradient(135deg, #ff8fab, #ff4d6d) !important;
    color: white !important;
    border: none !important;
    border-radius: 25px !important;
    font-family: 'Nunito', sans-serif !important;
    font-weight: 700 !important;
    padding: 0.5rem 1.5rem !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 3px 10px rgba(255,77,109,0.3) !important;
}
.stButton > button:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 6px 16px rgba(255,77,109,0.4) !important;
}

/* Inputs */
.stTextInput > div > div > input,
.stTextArea > div > div > textarea,
.stSelectbox > div > div {
    border-radius: 12px !important;
    border: 2px solid #ffb3c6 !important;
    font-family: 'Nunito', sans-serif !important;
    background: rgba(255,255,255,0.9) !important;
}
.stTextInput > div > div > input:focus,
.stTextArea > div > div > textarea:focus {
    border-color: #ff8fab !important;
    box-shadow: 0 0 0 2px rgba(255,143,171,0.3) !important;
}

/* Progress bars */
.stProgress > div > div > div > div {
    background: linear-gradient(90deg, #ff8fab, #ff4d6d) !important;
    border-radius: 10px !important;
}

/* Tabs */
.stTabs [data-baseweb="tab-list"] {
    background: rgba(255,255,255,0.7);
    border-radius: 16px;
    padding: 4px;
    gap: 4px;
}
.stTabs [data-baseweb="tab"] {
    border-radius: 12px !important;
    font-family: 'Nunito', sans-serif !important;
    font-weight: 700 !important;
    color: #c9184a !important;
}
.stTabs [aria-selected="true"] {
    background: linear-gradient(135deg, #ff8fab, #ff4d6d) !important;
    color: white !important;
}

/* Selectbox label */
label { color: #880e4f !important; font-weight: 700 !important; }

/* Headings */
h1, h2, h3 { font-family: 'Quicksand', sans-serif !important; color: #880e4f !important; }

/* Badges */
.badge {
    display: inline-block;
    background: linear-gradient(135deg, #ff8fab, #ff4d6d);
    color: white;
    border-radius: 20px;
    padding: 4px 14px;
    font-size: 0.8rem;
    font-weight: 700;
    margin: 2px;
}
.badge-outline {
    display: inline-block;
    border: 2px solid #ff8fab;
    color: #c9184a;
    border-radius: 20px;
    padding: 4px 14px;
    font-size: 0.8rem;
    font-weight: 700;
    margin: 2px;
}

/* Streak fire */
.streak-display {
    font-size: 3rem;
    text-align: center;
    margin: 0.5rem 0;
}

/* Timer display */
.timer-display {
    font-family: 'Quicksand', sans-serif;
    font-size: 4rem;
    font-weight: 700;
    text-align: center;
    color: #c9184a;
    text-shadow: 0 2px 8px rgba(201,24,74,0.2);
}

/* Quote box */
.quote-box {
    background: linear-gradient(135deg, rgba(255,143,171,0.3), rgba(255,184,210,0.3));
    border-left: 4px solid #ff8fab;
    border-radius: 0 16px 16px 0;
    padding: 1rem 1.5rem;
    font-style: italic;
    color: #880e4f;
    font-size: 1.1rem;
    font-weight: 600;
}

/* Checkbox */
.stCheckbox > label { color: #880e4f !important; font-weight: 600 !important; }

/* Multiselect */
.stMultiSelect [data-baseweb="tag"] {
    background: #ff8fab !important;
    border-radius: 10px !important;
}

/* Expander */
.streamlit-expanderHeader {
    background: rgba(255,179,198,0.3) !important;
    border-radius: 12px !important;
    color: #880e4f !important;
    font-weight: 700 !important;
}

/* Alert/info boxes */
.stAlert {
    border-radius: 12px !important;
}

/* Divider */
hr { border-color: #ffb3c6 !important; }

/* Number input */
.stNumberInput > div > div > input {
    border-radius: 12px !important;
    border: 2px solid #ffb3c6 !important;
    font-family: 'Nunito', sans-serif !important;
}

/* Time input */
.stTimeInput > div > div > input {
    border-radius: 12px !important;
    border: 2px solid #ffb3c6 !important;
}

/* Radio */
.stRadio > div { gap: 8px; }
.stRadio label { color: #880e4f !important; font-weight: 600 !important; }
</style>
""", unsafe_allow_html=True)

# ── Data persistence helpers ──────────────────────────────────────────────────
DATA_FILE = "study_data.json"

MOTIVATION_QUOTES = [
    ("✨", "She believed she could, so she did."),
    ("🌸", "Bloom where you are planted."),
    ("💪", "Hard work beats talent when talent doesn't work hard."),
    ("🦋", "Every expert was once a beginner."),
    ("🌟", "Your only limit is your mind."),
    ("🎀", "Study now, shine forever."),
    ("💖", "Be proud of how hard you're trying."),
    ("🌺", "Small steps every day lead to big results."),
    ("⭐", "You are capable of amazing things."),
    ("🍓", "Discipline is choosing between what you want now and what you want most."),
    ("🦄", "Dream big, study bigger."),
    ("🌙", "Tonight's effort is tomorrow's success."),
    ("🎯", "Focus on progress, not perfection."),
    ("💐", "You didn't come this far to only come this far."),
    ("🌈", "Every page you read makes you smarter."),
]

DEFAULT_SUBJECTS = [
    {"name": "Mathematics", "icon": "📐", "color": "#ff8fab", "tasks": [], "materials": []},
    {"name": "English", "icon": "📚", "color": "#ffb347", "tasks": [], "materials": []},
    {"name": "Science", "icon": "🔬", "color": "#77dd77", "tasks": [], "materials": []},
    {"name": "History", "icon": "🏛️", "color": "#b39ddb", "tasks": [], "materials": []},
    {"name": "Geography", "icon": "🌍", "color": "#80deea", "tasks": [], "materials": []},
    {"name": "Physics", "icon": "⚛️", "color": "#f48fb1", "tasks": [], "materials": []},
    {"name": "Chemistry", "icon": "🧪", "color": "#a5d6a7", "tasks": [], "materials": []},
    {"name": "Biology", "icon": "🧬", "color": "#ce93d8", "tasks": [], "materials": []},
    {"name": "Computer Science", "icon": "💻", "color": "#90caf9", "tasks": [], "materials": []},
    {"name": "Art", "icon": "🎨", "color": "#ffcc80", "tasks": [], "materials": []},
    {"name": "Music", "icon": "🎵", "color": "#f48fb1", "tasks": [], "materials": []},
    {"name": "PE", "icon": "⚽", "color": "#a5d6a7", "tasks": [], "materials": []},
]

def load_data():
    if os.path.exists(DATA_FILE):
        try:
            with open(DATA_FILE, "r") as f:
                return json.load(f)
        except:
            pass
    return {
        "subjects": DEFAULT_SUBJECTS,
        "goals": [],
        "streak": 0,
        "last_study_date": None,
        "total_study_minutes": 0,
        "pomodoro_sessions": 0,
        "reminders": [],
        "study_log": [],
        "flashcards": {},
        "quizzes": {},
    }

def save_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2, default=str)

def update_streak(data):
    today = str(date.today())
    yesterday = str(date.today() - timedelta(days=1))
    last = data.get("last_study_date")
    if last == today:
        return data
    elif last == yesterday:
        data["streak"] = data.get("streak", 0) + 1
    elif last != today:
        if last != yesterday:
            data["streak"] = 1
    data["last_study_date"] = today
    return data

# ── Session state init ────────────────────────────────────────────────────────
if "data" not in st.session_state:
    st.session_state.data = load_data()
if "timer_running" not in st.session_state:
    st.session_state.timer_running = False
if "timer_start" not in st.session_state:
    st.session_state.timer_start = None
if "timer_mode" not in st.session_state:
    st.session_state.timer_mode = "focus"
if "timer_seconds_left" not in st.session_state:
    st.session_state.timer_seconds_left = 25 * 60
if "quote_idx" not in st.session_state:
    st.session_state.quote_idx = random.randint(0, len(MOTIVATION_QUOTES) - 1)

data = st.session_state.data

# ── Sidebar ───────────────────────────────────────────────────────────────────
with st.sidebar:
    st.markdown("## 🌸 StudyBlossom")
    st.markdown("---")

    # Streak badge
    streak = data.get("streak", 0)
    fire = "🔥" * min(streak, 5) if streak > 0 else "❄️"
    st.markdown(f"""
    <div style='text-align:center; background:rgba(255,255,255,0.4); border-radius:16px; padding:1rem; margin-bottom:1rem;'>
        <div style='font-size:2rem'>{fire}</div>
        <div style='font-size:1.6rem; font-weight:800; color:#5a0028'>{streak}</div>
        <div style='font-size:0.8rem; font-weight:700; color:#7b0035'>day streak</div>
    </div>
    """, unsafe_allow_html=True)

    # Daily quote
    emoji, quote = MOTIVATION_QUOTES[st.session_state.quote_idx]
    st.markdown(f"""
    <div style='background:rgba(255,255,255,0.35); border-radius:12px; padding:0.8rem; margin-bottom:1rem; font-size:0.82rem; font-style:italic; color:#5a0028; font-weight:600;'>
        {emoji} "{quote}"
    </div>
    """, unsafe_allow_html=True)
    if st.button("✨ New Quote"):
        st.session_state.quote_idx = random.randint(0, len(MOTIVATION_QUOTES) - 1)
        st.rerun()

    st.markdown("---")
    nav = st.radio("Navigate", [
        "🏠 Dashboard",
        "📚 Subjects",
        "🍅 Pomodoro",
        "🎯 Goals",
        "🔔 Reminders",
        "🃏 Flashcards & Quizzes",
    ], label_visibility="collapsed")

    st.markdown("---")
    total_min = data.get("total_study_minutes", 0)
    pomo = data.get("pomodoro_sessions", 0)
    st.markdown(f"""
    <div style='font-size:0.8rem; color:#5a0028; font-weight:700;'>
        📖 Total study time: <b>{total_min} min</b><br>
        🍅 Pomodoros done: <b>{pomo}</b>
    </div>
    """, unsafe_allow_html=True)

# ── DASHBOARD ─────────────────────────────────────────────────────────────────
if nav == "🏠 Dashboard":
    st.markdown("# 🌸 Welcome back, Study Star!")
    today_str = date.today().strftime("%A, %B %d %Y")
    st.markdown(f"<p style='color:#c9184a; font-weight:600; margin-top:-0.5rem;'>📅 {today_str}</p>", unsafe_allow_html=True)

    # Stats row
    c1, c2, c3, c4 = st.columns(4)
    subjects_count = len(data["subjects"])
    goals_done = sum(1 for g in data["goals"] if g.get("done"))
    goals_total = len(data["goals"])
    tasks_today = sum(1 for s in data["subjects"] for t in s.get("tasks", []) if not t.get("done"))

    with c1:
        st.markdown(f"""<div class='metric-card'><h3>{data.get('streak',0)}🔥</h3><p>Day Streak</p></div>""", unsafe_allow_html=True)
    with c2:
        st.markdown(f"""<div class='metric-card'><h3>{data.get('total_study_minutes',0)}</h3><p>Minutes Studied</p></div>""", unsafe_allow_html=True)
    with c3:
        st.markdown(f"""<div class='metric-card'><h3>{goals_done}/{goals_total}</h3><p>Goals Done</p></div>""", unsafe_allow_html=True)
    with c4:
        st.markdown(f"""<div class='metric-card'><h3>{tasks_today}</h3><p>Pending Tasks</p></div>""", unsafe_allow_html=True)

    st.markdown("---")
    col_l, col_r = st.columns([2, 1])

    with col_l:
        st.markdown("### 📋 Today's Task Overview")
        any_tasks = False
        for subj in data["subjects"]:
            pending = [t for t in subj.get("tasks", []) if not t.get("done")]
            if pending:
                any_tasks = True
                st.markdown(f"""
                <div class='pink-card'>
                    <b>{subj['icon']} {subj['name']}</b>
                    <span class='badge'>{len(pending)} pending</span><br>
                    {''.join(f"<span class='badge-outline'>• {t['title']}</span>" for t in pending[:3])}
                    {'<br><small>...and more</small>' if len(pending) > 3 else ''}
                </div>
                """, unsafe_allow_html=True)
        if not any_tasks:
            st.success("🎉 No pending tasks — you're all caught up! Amazing!")

        # Active reminders
        st.markdown("### 🔔 Reminders")
        now = datetime.now()
        active = [r for r in data.get("reminders", []) if r.get("active", True)]
        if active:
            for r in active[:3]:
                st.markdown(f"""<div class='pink-card'>⏰ <b>{r['subject']}</b> — {r['message']} <span style='color:#ff8fab;'>@ {r['time']}</span></div>""", unsafe_allow_html=True)
        else:
            st.info("No reminders set. Add some in the Reminders tab!")

    with col_r:
        st.markdown("### 🎀 Streak Badge")
        streak = data.get("streak", 0)
        if streak == 0:
            badge_emoji, badge_text, badge_color = "❄️", "Just Starting", "#90caf9"
        elif streak < 3:
            badge_emoji, badge_text, badge_color = "🌱", "Seedling", "#a5d6a7"
        elif streak < 7:
            badge_emoji, badge_text, badge_color = "🌸", "Blossoming", "#f48fb1"
        elif streak < 14:
            badge_emoji, badge_text, badge_color = "🔥", "On Fire!", "#ff8fab"
        elif streak < 30:
            badge_emoji, badge_text, badge_color = "⭐", "Star Student", "#ffcc80"
        else:
            badge_emoji, badge_text, badge_color = "👑", "Study Queen", "#ce93d8"

        st.markdown(f"""
        <div style='background:linear-gradient(135deg,{badge_color}88,{badge_color}44); border:2px solid {badge_color}; border-radius:20px; padding:1.5rem; text-align:center;'>
            <div style='font-size:3rem'>{badge_emoji}</div>
            <div style='font-weight:800; font-size:1.2rem; color:#5a0028;'>{badge_text}</div>
            <div style='color:#880e4f; font-weight:600;'>{streak} day{'s' if streak!=1 else ''} strong!</div>
        </div>
        """, unsafe_allow_html=True)

        st.markdown("### 💖 Goals Progress")
        if goals_total > 0:
            pct = goals_done / goals_total
            st.progress(pct)
            st.markdown(f"<p style='text-align:center;color:#c9184a;font-weight:700;'>{goals_done}/{goals_total} completed</p>", unsafe_allow_html=True)
        else:
            st.info("Add goals in the Goals tab!")

# ── SUBJECTS ──────────────────────────────────────────────────────────────────
elif nav == "📚 Subjects":
    st.markdown("# 📚 My Subjects")

    tab1, tab2 = st.tabs(["📖 All Subjects", "➕ Add Custom Subject"])

    with tab1:
        for i, subj in enumerate(data["subjects"]):
            with st.expander(f"{subj['icon']} {subj['name']}  —  {len([t for t in subj.get('tasks',[]) if not t.get('done')])} pending tasks"):
                col_a, col_b = st.columns([3, 1])

                with col_a:
                    st.markdown(f"**Add a task for {subj['name']}:**")
                    task_title = st.text_input("Task", key=f"task_{i}", placeholder="e.g. Chapter 5 exercises")
                    task_due = st.date_input("Due date", key=f"due_{i}", value=date.today())
                    task_priority = st.selectbox("Priority", ["🔴 High", "🟡 Medium", "🟢 Low"], key=f"prio_{i}")

                    if st.button("Add Task ✅", key=f"add_task_{i}"):
                        if task_title.strip():
                            data["subjects"][i]["tasks"].append({
                                "title": task_title.strip(),
                                "due": str(task_due),
                                "priority": task_priority,
                                "done": False,
                                "created": str(date.today())
                            })
                            save_data(data)
                            st.success("Task added! 🎀")
                            st.rerun()

                with col_b:
                    st.markdown("**Tasks:**")
                    tasks = subj.get("tasks", [])
                    if not tasks:
                        st.caption("No tasks yet!")
                    for j, task in enumerate(tasks):
                        done = st.checkbox(
                            f"{task['priority']} {task['title']} *(due {task['due']})*",
                            value=task.get("done", False),
                            key=f"task_done_{i}_{j}"
                        )
                        data["subjects"][i]["tasks"][j]["done"] = done

                if st.button("💾 Save Tasks", key=f"save_{i}"):
                    save_data(data)
                    st.success("Saved! 💕")

    with tab2:
        st.markdown("### ✨ Create Your Own Subject")
        st.markdown("<div class='pink-card'>", unsafe_allow_html=True)
        new_name = st.text_input("Subject Name", placeholder="e.g. Latin, Psychology, Drama…")
        new_icon = st.text_input("Choose an emoji icon", placeholder="e.g. 🎭", max_chars=4, value="📖")
        new_color = st.color_picker("Pick a color", value="#ff8fab")

        if st.button("🌸 Create Subject"):
            if new_name.strip():
                data["subjects"].append({
                    "name": new_name.strip(),
                    "icon": new_icon or "📖",
                    "color": new_color,
                    "tasks": [],
                    "materials": []
                })
                save_data(data)
                st.success(f"Subject '{new_name}' created! 🎉")
                st.rerun()
            else:
                st.error("Please enter a subject name!")
        st.markdown("</div>", unsafe_allow_html=True)

# ── POMODORO ──────────────────────────────────────────────────────────────────
elif nav == "🍅 Pomodoro":
    st.markdown("# 🍅 Pomodoro Timer")
    st.markdown("*Focus deeply, rest sweetly.* 🌸")

    col1, col2 = st.columns([1, 1])

    with col1:
        st.markdown("<div class='pink-card'>", unsafe_allow_html=True)
        st.markdown("### ⚙️ Timer Settings")
        focus_min = st.number_input("Focus duration (minutes)", min_value=1, max_value=90, value=25)
        short_break = st.number_input("Short break (minutes)", min_value=1, max_value=30, value=5)
        long_break = st.number_input("Long break (minutes)", min_value=1, max_value=60, value=15)
        study_subject = st.selectbox("Studying:", [f"{s['icon']} {s['name']}" for s in data["subjects"]])
        st.markdown("</div>", unsafe_allow_html=True)

    with col2:
        st.markdown("<div class='pink-card'>", unsafe_allow_html=True)
        mode_labels = {"focus": f"🎯 Focus — {focus_min} min", "short": f"☕ Short Break — {short_break} min", "long": f"💤 Long Break — {long_break} min"}
        mode = st.radio("Mode", list(mode_labels.keys()), format_func=lambda x: mode_labels[x], key="pomo_mode")

        durations = {"focus": focus_min * 60, "short": short_break * 60, "long": long_break * 60}
        total_secs = durations[mode]

        # Timer logic
        if st.session_state.timer_running and st.session_state.timer_start:
            elapsed = time.time() - st.session_state.timer_start
            remaining = max(0, st.session_state.timer_seconds_left - elapsed)
        else:
            remaining = st.session_state.timer_seconds_left if st.session_state.timer_mode == mode else total_secs

        mins_left = int(remaining) // 60
        secs_left = int(remaining) % 60
        st.markdown(f"<div class='timer-display'>{mins_left:02d}:{secs_left:02d}</div>", unsafe_allow_html=True)
        st.progress(1 - (remaining / total_secs) if total_secs > 0 else 0)

        c_start, c_pause, c_reset = st.columns(3)
        with c_start:
            if st.button("▶️ Start"):
                st.session_state.timer_running = True
                st.session_state.timer_start = time.time()
                st.session_state.timer_seconds_left = total_secs
                st.session_state.timer_mode = mode
        with c_pause:
            if st.button("⏸ Pause"):
                if st.session_state.timer_running:
                    elapsed = time.time() - st.session_state.timer_start
                    st.session_state.timer_seconds_left = max(0, st.session_state.timer_seconds_left - elapsed)
                    st.session_state.timer_running = False
                    st.session_state.timer_start = None
        with c_reset:
            if st.button("🔄 Reset"):
                st.session_state.timer_running = False
                st.session_state.timer_start = None
                st.session_state.timer_seconds_left = total_secs

        if remaining == 0 and st.session_state.timer_running:
            st.balloons()
            st.success("🎉 Time's up! Great job!")
            if mode == "focus":
                data["pomodoro_sessions"] = data.get("pomodoro_sessions", 0) + 1
                data["total_study_minutes"] = data.get("total_study_minutes", 0) + focus_min
                data = update_streak(data)
                save_data(data)
            st.session_state.timer_running = False

        if st.session_state.timer_running:
            st.caption("⏱ Timer is running — refresh to update the display")

        st.markdown("</div>", unsafe_allow_html=True)

    # Tips
    st.markdown("---")
    st.markdown("### 🌸 Pomodoro Tips")
    tips = [
        "📵 Put your phone face-down during focus time",
        "💧 Drink water during your breaks",
        "🚶 Stand up and stretch every break",
        "📝 Write down distractions instead of acting on them",
        "🎵 Try lo-fi music to stay focused",
    ]
    for tip in tips:
        st.markdown(f"<div class='pink-card'>{tip}</div>", unsafe_allow_html=True)

# ── GOALS ─────────────────────────────────────────────────────────────────────
elif nav == "🎯 Goals":
    st.markdown("# 🎯 My Study Goals")

    col1, col2 = st.columns([1, 1])
    with col1:
        st.markdown("### ✨ Add a New Goal")
        with st.form("goal_form"):
            goal_title = st.text_input("Goal", placeholder="e.g. Score 90+ in Math exam")
            goal_subject = st.selectbox("Subject", ["General"] + [s["name"] for s in data["subjects"]])
            goal_deadline = st.date_input("Target date", value=date.today() + timedelta(days=7))
            goal_notes = st.text_area("Notes", placeholder="How will you achieve this?", height=80)
            submitted = st.form_submit_button("🎀 Add Goal")
            if submitted and goal_title.strip():
                data["goals"].append({
                    "title": goal_title.strip(),
                    "subject": goal_subject,
                    "deadline": str(goal_deadline),
                    "notes": goal_notes,
                    "done": False,
                    "created": str(date.today())
                })
                save_data(data)
                st.success("Goal added! You've got this! 💪")
                st.rerun()

    with col2:
        st.markdown("### 📋 My Goals")
        if not data["goals"]:
            st.info("No goals yet — add one to get started! 🌸")
        else:
            pending_goals = [g for g in data["goals"] if not g.get("done")]
            done_goals = [g for g in data["goals"] if g.get("done")]

            if pending_goals:
                st.markdown("**🎯 In Progress:**")
                for i, goal in enumerate(data["goals"]):
                    if not goal.get("done"):
                        idx = data["goals"].index(goal)
                        col_a, col_b = st.columns([4, 1])
                        with col_a:
                            st.markdown(f"""
                            <div class='pink-card'>
                                <b>{goal['title']}</b><br>
                                <span class='badge-outline'>{goal.get('subject','General')}</span>
                                <span style='color:#ff8fab; font-size:0.8rem;'>📅 {goal['deadline']}</span><br>
                                <small>{goal.get('notes','')}</small>
                            </div>
                            """, unsafe_allow_html=True)
                        with col_b:
                            if st.button("✅", key=f"done_goal_{idx}"):
                                data["goals"][idx]["done"] = True
                                save_data(data)
                                st.balloons()
                                st.rerun()
                            if st.button("🗑", key=f"del_goal_{idx}"):
                                data["goals"].pop(idx)
                                save_data(data)
                                st.rerun()

            if done_goals:
                st.markdown("**✅ Completed:**")
                for goal in done_goals:
                    st.markdown(f"""
                    <div style='opacity:0.6;' class='pink-card'>
                        ✅ <s>{goal['title']}</s> — <span class='badge'>{goal.get('subject','General')}</span>
                    </div>
                    """, unsafe_allow_html=True)

# ── REMINDERS ─────────────────────────────────────────────────────────────────
elif nav == "🔔 Reminders":
    st.markdown("# 🔔 Study Reminders")
    st.info("💡 Set reminders here and check this page daily — or bookmark it on your phone for quick access!")

    col1, col2 = st.columns([1, 1])
    with col1:
        st.markdown("### ➕ Add Reminder")
        with st.form("reminder_form"):
            rem_subject = st.selectbox("Subject", [s["name"] for s in data["subjects"]])
            rem_message = st.text_input("Message", placeholder="e.g. Review Chapter 3 notes")
            rem_time = st.time_input("Reminder time", value=datetime.strptime("17:00", "%H:%M").time())
            rem_days = st.multiselect("Days", ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], default=["Mon","Tue","Wed","Thu","Fri"])
            if st.form_submit_button("🔔 Set Reminder"):
                if rem_message.strip():
                    data["reminders"].append({
                        "subject": rem_subject,
                        "message": rem_message.strip(),
                        "time": str(rem_time)[:5],
                        "days": rem_days,
                        "active": True,
                        "created": str(date.today())
                    })
                    save_data(data)
                    st.success("Reminder set! 🎀")
                    st.rerun()

    with col2:
        st.markdown("### 📋 Active Reminders")
        reminders = data.get("reminders", [])
        if not reminders:
            st.info("No reminders yet!")
        else:
            today_day = date.today().strftime("%a")
            current_time = datetime.now().strftime("%H:%M")
            for i, r in enumerate(reminders):
                is_today = today_day in r.get("days", [])
                is_now = r["time"] <= current_time <= (r["time"][:3] + str(int(r["time"][3:5]) + 5).zfill(2)) if is_today else False
                border = "border: 2px solid #ff4d6d;" if is_now else ""
                active_label = "🟢 Active" if r.get("active", True) else "⚫ Paused"
                st.markdown(f"""
                <div class='pink-card' style='{border}'>
                    <b>⏰ {r['time']}</b> — {r['subject']}<br>
                    {r['message']}<br>
                    <small>📅 {', '.join(r.get('days', []))} &nbsp;|&nbsp; {active_label}</small>
                </div>
                """, unsafe_allow_html=True)
                c1, c2 = st.columns(2)
                with c1:
                    if st.button("Toggle", key=f"tog_{i}"):
                        data["reminders"][i]["active"] = not data["reminders"][i].get("active", True)
                        save_data(data)
                        st.rerun()
                with c2:
                    if st.button("Delete 🗑", key=f"del_rem_{i}"):
                        data["reminders"].pop(i)
                        save_data(data)
                        st.rerun()

# ── FLASHCARDS & QUIZZES ──────────────────────────────────────────────────────
elif nav == "🃏 Flashcards & Quizzes":
    st.markdown("# 🃏 AI Flashcards & Quizzes")
    st.markdown("*Upload your study materials and let AI create flashcards and quizzes for you!* ✨")

    tab_fc, tab_quiz, tab_upload = st.tabs(["🃏 Flashcards", "📝 Quiz", "📤 Upload Materials"])

    with tab_upload:
        st.markdown("### 📤 Upload Study Materials")
        st.markdown("<div class='pink-card'>", unsafe_allow_html=True)
        upload_subject = st.selectbox("Subject for this material:", [s["name"] for s in data["subjects"]], key="up_subj")
        uploaded_file = st.file_uploader("Upload a text file, PDF, or paste text below", type=["txt", "pdf", "md"])
        pasted_text = st.text_area("Or paste your notes here:", height=200, placeholder="Paste your class notes, textbook excerpts, or any study material…")

        if st.button("🌸 Generate Flashcards & Quiz with AI"):
            content = ""
            if uploaded_file:
                try:
                    content = uploaded_file.read().decode("utf-8", errors="ignore")
                except:
                    content = str(uploaded_file.read())
            elif pasted_text.strip():
                content = pasted_text.strip()
            else:
                st.warning("Please upload a file or paste some text!")

            if content:
                with st.spinner("✨ AI is creating your flashcards and quiz…"):
                    try:
                        api_key = os.environ.get("GEMINI_API_KEY") or st.secrets.get("GEMINI_API_KEY", "")
                        if not api_key:
                            st.error("Please set your GEMINI_API_KEY! See the README for instructions.")
                            st.stop()

                        genai.configure(api_key=api_key)
                        model = genai.GenerativeModel("gemini-1.5-flash")

                        prompt = f"""You are a helpful study assistant for a high school student.
Given the following study material about {upload_subject}, create:

1. 8 flashcards (question + answer pairs) covering key concepts
2. 5 multiple choice quiz questions with 4 options each (mark the correct one)

Study material:
---
{content[:4000]}
---

Respond ONLY with valid JSON in this exact format, no markdown fences:
{{
  "flashcards": [
    {{"question": "...", "answer": "..."}}
  ],
  "quiz": [
    {{
      "question": "...",
      "options": ["A) ...", "B) ...", "C) ...", "D) ..."],
      "correct": 0
    }}
  ]
}}
The "correct" field is the 0-based index of the correct option."""

                        response = model.generate_content(prompt)
                        result_text = response.text.strip()
                        if result_text.startswith("```"):
                            result_text = result_text.split("```")[1]
                            if result_text.startswith("json"):
                                result_text = result_text[4:]
                        result = json.loads(result_text)

                        if "flashcards" not in data:
                            data["flashcards"] = {}
                        if "quizzes" not in data:
                            data["quizzes"] = {}
                        data["flashcards"][upload_subject] = result.get("flashcards", [])
                        data["quizzes"][upload_subject] = result.get("quiz", [])
                        save_data(data)
                        st.success(f"🎉 Created {len(result.get('flashcards',[]))} flashcards and {len(result.get('quiz',[]))} quiz questions for {upload_subject}!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Couldn't connect to Gemini AI — make sure your GEMINI_API_KEY is set!\n\n`{e}`")
        st.markdown("</div>", unsafe_allow_html=True)

    with tab_fc:
        st.markdown("### 🃏 Flashcards")
        flashcard_subjects = list(data.get("flashcards", {}).keys())
        if not flashcard_subjects:
            st.info("No flashcards yet! Upload your study material in the 📤 Upload tab to generate them. 🌸")
        else:
            fc_subject = st.selectbox("Choose subject:", flashcard_subjects, key="fc_subj")
            cards = data["flashcards"].get(fc_subject, [])
            if cards:
                if "fc_index" not in st.session_state:
                    st.session_state.fc_index = 0
                if "fc_flipped" not in st.session_state:
                    st.session_state.fc_flipped = False

                idx = min(st.session_state.fc_index, len(cards) - 1)
                card = cards[idx]

                st.markdown(f"**Card {idx+1} of {len(cards)}**")
                if not st.session_state.fc_flipped:
                    st.markdown(f"""
                    <div class='pink-card-dark' style='min-height:150px; display:flex; align-items:center; justify-content:center; text-align:center; font-size:1.2rem; font-weight:700; cursor:pointer;'>
                        ❓ {card['question']}
                    </div>
                    """, unsafe_allow_html=True)
                    if st.button("👀 Reveal Answer"):
                        st.session_state.fc_flipped = True
                        st.rerun()
                else:
                    st.markdown(f"""
                    <div class='pink-card' style='min-height:150px; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;'>
                        <div style='color:#ff8fab; font-size:0.9rem; font-weight:700;'>❓ {card['question']}</div>
                        <hr style='width:100%;'>
                        <div style='font-size:1.1rem; font-weight:700; color:#880e4f;'>✅ {card['answer']}</div>
                    </div>
                    """, unsafe_allow_html=True)
                    if st.button("🔄 Flip Back"):
                        st.session_state.fc_flipped = False
                        st.rerun()

                c1, c2, c3 = st.columns(3)
                with c1:
                    if st.button("⬅️ Previous"):
                        st.session_state.fc_index = max(0, idx - 1)
                        st.session_state.fc_flipped = False
                        st.rerun()
                with c2:
                    if st.button("🔀 Shuffle"):
                        st.session_state.fc_index = random.randint(0, len(cards)-1)
                        st.session_state.fc_flipped = False
                        st.rerun()
                with c3:
                    if st.button("➡️ Next"):
                        st.session_state.fc_index = min(len(cards)-1, idx + 1)
                        st.session_state.fc_flipped = False
                        st.rerun()

    with tab_quiz:
        st.markdown("### 📝 Quiz Yourself!")
        quiz_subjects = list(data.get("quizzes", {}).keys())
        if not quiz_subjects:
            st.info("No quizzes yet! Generate them from the 📤 Upload tab. 🌸")
        else:
            q_subject = st.selectbox("Choose subject:", quiz_subjects, key="q_subj")
            questions = data["quizzes"].get(q_subject, [])
            if questions:
                if "quiz_answers" not in st.session_state:
                    st.session_state.quiz_answers = {}
                if "quiz_submitted" not in st.session_state:
                    st.session_state.quiz_submitted = False

                if not st.session_state.quiz_submitted:
                    for i, q in enumerate(questions):
                        st.markdown(f"<div class='pink-card'><b>Q{i+1}: {q['question']}</b></div>", unsafe_allow_html=True)
                        choice = st.radio("", q["options"], key=f"q_{i}", label_visibility="collapsed")
                        st.session_state.quiz_answers[i] = q["options"].index(choice)

                    if st.button("🎯 Submit Quiz"):
                        st.session_state.quiz_submitted = True
                        st.rerun()
                else:
                    score = 0
                    for i, q in enumerate(questions):
                        user_ans = st.session_state.quiz_answers.get(i, -1)
                        correct = q["correct"]
                        is_correct = user_ans == correct
                        if is_correct:
                            score += 1
                        icon = "✅" if is_correct else "❌"
                        st.markdown(f"""
                        <div class='pink-card'>
                            <b>{icon} Q{i+1}: {q['question']}</b><br>
                            Your answer: <b>{q['options'][user_ans] if user_ans >= 0 else '—'}</b><br>
                            {'✅ Correct!' if is_correct else f"❌ Correct: <b>{q['options'][correct]}</b>"}
                        </div>
                        """, unsafe_allow_html=True)

                    pct = int(score / len(questions) * 100)
                    st.markdown(f"""
                    <div class='pink-card-dark' style='text-align:center;'>
                        <div style='font-size:2rem;'>{'🎉' if pct >= 80 else '📚' if pct >= 60 else '💪'}</div>
                        <div style='font-size:1.5rem; font-weight:800;'>{score}/{len(questions)} correct — {pct}%</div>
                        <div>{'Amazing work! 🌟' if pct >= 80 else 'Good effort! Keep studying! 📖' if pct >= 60 else "Don't give up! Review your notes and try again! 💕"}</div>
                    </div>
                    """, unsafe_allow_html=True)

                    if st.button("🔄 Retry Quiz"):
                        st.session_state.quiz_submitted = False
                        st.session_state.quiz_answers = {}
                        st.rerun()
