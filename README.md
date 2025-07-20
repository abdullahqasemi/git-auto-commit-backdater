# Git Auto Commit Backdater

Automate the creation of fake Git commits on past dates (excluding Sundays) to populate your Git contribution graph.
This script temporarily changes your system date to simulate commits on different days.

> ⚠️ **Use with caution:** This script modifies your system time and should only be used in isolated or local projects, **not** production repositories.

---

## 🧾 What It Does

- Disables network time synchronization (NTP) to allow manual system time changes.
- Iterates over a user-defined date range.
- Skips Sundays.
- For each date:
  - Sets the system time.
  - Creates 15–20 fake commits with fixed timestamps.
- Restores your system's actual date and re-enables NTP.
- Pushes all commits to the `main` branch.

---

## 🛠️ Requirements

- Linux (or WSL on Windows)
- `git` installed
- `timedatectl` and `date` utilities available
- Sudo privileges (required to change system date)
- A Git repository initialized at the specified path
- A remote repository set up (e.g., `origin/main`)

---

## 📝 Usage

Run the script with the following arguments:

```bash
sudo ./auto-commit.sh <START_DATE> <END_DATE> <REPO_DIR>
```

- `<START_DATE>`: Start date in `YYYY-MM-DD` format
- `<END_DATE>`: End date in `YYYY-MM-DD` format
- `<REPO_DIR>`: Path to your Git repository

**Example:**

```bash
sudo ./auto-commit.sh 2023-09-15 2023-10-20 /path/to/your/repo
```

Make sure:

- The dates follow the `YYYY-MM-DD` format.
- `REPO_DIR` points to a valid Git repository.
- You have a remote branch set up (e.g., `origin/main`).

---

## 🚀 How to Run

1. Make the script executable:

   ```bash
   chmod +x auto-commit.sh
   ```

2. Run the script with sudo (required to change system time):

   ```bash
   sudo ./auto-commit.sh <START_DATE> <END_DATE> <REPO_DIR>
   ```

---

## 🔍 Script Breakdown

1. **Disable NTP**

   ```bash
   sudo timedatectl set-ntp false
   ```

   Allows manual changes to system time.

2. **Set Repository Path and Save Actual Date**

   ```bash
   ACTUAL_DATE=$(date -I)
   ```

   Saves the real date to restore later.

3. **Loop Over Dates**

   Iterates through each day between `START_DATE` and `END_DATE`, skipping Sundays.

4. **For Each Day**

   - Sets the system time to the current loop date.
   - Creates a file inside a `src/` directory to simulate changes.
   - Makes 15–20 commits with timestamps fixed at `12:00:00` using `GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE`.

5. **Restore System Time and Push**

   ```bash
   sudo timedatectl set-ntp true
   git push origin main
   ```

---

## 📌 Notes

- **Skipping Sundays:** Uses `date +%u` to identify Sunday as day 7.
- **Time Format:** Commits are fixed at `12:00:00` for consistency.
- **Files Created:** Commits modify files inside a `src/` directory to simulate real changes.
- **Branch:** Assumes commits are pushed to the `main` branch.

---

## ⚠️ Disclaimer

This script is intended for educational or personal fun use (e.g., spicing up your GitHub profile).  
Do **not** use it to mislead others about your actual contribution history.

---
