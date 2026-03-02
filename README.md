# Mini TaskHub – Personal Task Tracker

A premium Flutter personal task tracking app built with Supabase for authentication and database management.

## ✨ Features
- **Modern UI**: Designed based on premium Figma templates with soft gradients and glassmorphism-inspired elements.
- **Authentication**: Secure email/password login and signup via Supabase.
- **Task Management**: Create, delete (swipe-to-delete), and toggle completion of tasks.
- **Category Overview**: Visual summary of tasks by category (Project, Work, Daily, Groceries).
- **Responsive**: Adapts to different screen sizes.

## 🚀 Setup Instructions

### 1. Prerequisites
- Flutter SDK (^3.10.1)
- Dart SDK
- Supabase account

### 2. Environment Variables
Create a `.env` file in the root directory with your Supabase credentials:
```env
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

### 3. Database Setup
Run the following SQL in your Supabase SQL Editor to create the `tasks` table:
```sql
create table public.tasks (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  title text not null,
  description text,
  category text default 'Daily Tasks',
  is_completed boolean default false,
  user_id uuid references auth.users not null,
  start_time text,
  end_time text,
  priority text default 'Medium'
);

-- Row Level Security (RLS)
alter table public.tasks enable row level security;

create policy "Users can manage their own tasks"
  on public.tasks for all
  using (auth.uid() = user_id);
```

### 4. Running the App
```bash
flutter pub get
flutter run
```

---

## 💡 Hot Reload vs Hot Restart

### Hot Reload (`r`)
- **Mechanism**: Injects updated source code files into the running Dart Virtual Machine (VM).
- **State**: Preserves the **app state** (e.g., text entered in fields, scroll position).
- **Use Case**: Best for UI changes, styling tweaks, and small logic updates.
- **Speed**: Very fast (usually < 1s).

### Hot Restart (`R`)
- **Mechanism**: Recompiles the app and restarts the Dart VM from scratch.
- **State**: **Loses app state**, resetting the app to its initial configuration.
- **Use Case**: Required when changes involve `main()`, global variables, static fields, or plugin initializations.
- **Speed**: Slower than hot reload but faster than a full build/deploy.

---

## 🛠 Tech Stack
- **Framework**: Flutter
- **Backend**: Supabase (Auth & DB)
- **State Management**: Provider
- **UI & Animations**: Google Fonts, Flutter Animate, Flutter Slidable, Dotenv
