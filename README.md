# Mini TaskHub – Personal Task Tracker

A premium, feature-rich Flutter personal task tracking app powered by **Supabase**. Designed with a focus on aesthetics, smooth interactions, and real-time synchronization.

---

## ✨ Features

### 🛠 Core Functionality
- **Authentication**: Secure email/password login and signup via Supabase Auth.
- **Task Management**: Fully managed tasks with Creation, Editing, Toggling, and Deletion.
- **Native Interactions**: Fluid **Swipe-to-Delete** using native mobile patterns.
- **Form Validation**: Robust validation for emails, passwords, and required fields.

### 🚀 Premium Experience
- **Real-time Sync**: Uses **Supabase Realtime Streams**. Changes made on the dashboard reflect instantly without refreshing.
- **Dynamic Dashboard**: Visual category cards (Work, Project, etc.) that update their counts live as you manage tasks.
- **Dark Mode**: A beautiful, premium Dark Theme toggle for night-time productivity.
- **Glassmorphism Design**: Soft gradients and translucent elements for a state-of-the-art look.
- **Micro-Animations**: Uses `flutter_animate` for smooth transitions and entry effects.

---

## 🚀 Setup Instructions

### 1. Prerequisites
- Flutter SDK (^3.10.x)
- Supabase Account

### 2. Environment Variables
Create a `.env` file in the root directory:
```env
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

### 3. Database Setup (Supabase)
1. Run the following SQL in your Supabase SQL Editor:
```sql
create table public.tasks (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  title text not null,
  description text,
  category text,
  is_completed boolean default false,
  user_id uuid references auth.users not null,
  start_time text,
  end_time text,
  date text,
  priority text default 'Low'
);

-- Enable Realtime (This is CRITICAL for the app's real-time feature)
alter publication supabase_realtime add table tasks;

-- Row Level Security (RLS)
alter table public.tasks enable row level security;
create policy "Users can manage their own tasks" on public.tasks for all using (auth.uid() = user_id);
```
2. **Crucial**: Go to **Database > Replication** and ensure the `tasks` table has Realtime toggled **ON**.

---

## 💡 Key Dev Concepts

### ⚡ Real-time Architecture
Unlike traditional apps that "poll" the server, TaskHub maintains a WebSocket connection. When you update a task, the server "pushes" the new list to your phone instantly.

### 🔄 Hot Reload vs Hot Restart
- **Hot Reload (`r`)**: Swaps code but keeps the app state. Great for UI/CSS-like changes.
- **Hot Restart (`R`)**: Destroys state and restarts the app. Required when changing the `main()` function or initializing new Providers.

---

## 🛠 Tech Stack
- **Framework**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL + Realtime)
- **State**: Provider
- **UI**: Google Fonts (Outfit), Flutter Animate, Flutter Slidable, Dotenv
