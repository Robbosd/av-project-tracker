# AnyVan Project Tracker

Single-file project tracker. Vanilla HTML/CSS/JS, Supabase backend, hosted on GitHub Pages.

## Setup

### 1. Run the database schema

In Supabase → SQL Editor, run the contents of `schema.sql`.

### 2. Enable Google OAuth

1. Go to **Supabase → Authentication → Providers → Google**
2. Enable Google and copy the **Redirect URL** shown
3. Go to [Google Cloud Console](https://console.cloud.google.com) → APIs & Services → Credentials
4. Create an OAuth 2.0 Client ID (Web application)
5. Add the Supabase redirect URL to **Authorised redirect URIs**
6. Copy the Client ID and Client Secret back into Supabase

### 3. Enable GitHub Pages

1. Go to the repo → Settings → Pages
2. Source: Deploy from branch → `main` → `/ (root)`
3. Save. The app will be live at `https://robbosd.github.io/av-project-tracker`

### 4. Add the GitHub Pages URL as an allowed redirect

In Supabase → Authentication → URL Configuration:
- Add `https://robbosd.github.io/av-project-tracker` to **Redirect URLs**

## Tech stack

- Frontend: Single `index.html` — no build step, no npm
- Database: Supabase (Postgres)
- Auth: Supabase Auth with Google SSO
- Hosting: GitHub Pages
