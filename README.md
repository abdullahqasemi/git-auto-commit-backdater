# Git Auto Commit Backdater

Automate the creation of fake Git commits on past dates to populate your Git contribution graph.
This script uses Git's commit date functionality to create backdated commits without modifying your system time.

> ⚠️ **Note:** This script requires write access to the repository files and GitHub authentication.

---

## 🧾 What It Does

- Iterates over a user-defined date range.
- Randomly skips approximately 20% of days for a more natural pattern.
- For each date:
  - Creates 15–20 fake commits with backdated timestamps using Git's environment variables.
- Pushes all commits to the `main` branch.
- Cleans up generated files after pushing.

---

## 🛠️ Requirements

- Linux, macOS, or WSL on Windows
- `git` installed
- `date` utility available
- A Git repository initialized at the specified path
- A remote repository set up (e.g., `origin/main`)
- GitHub authentication configured
- Write access to the repository files

---

## 📝 Usage

Run the script with the following arguments:

```bash
./auto-commit.sh <START_DATE> <END_DATE> <REPO_DIR>
```

- `<START_DATE>`: Start date in `YYYY-MM-DD` format
- `<END_DATE>`: End date in `YYYY-MM-DD` format
- `<REPO_DIR>`: Path to your Git repository

**Example:**

```bash
./auto-commit.sh 2023-09-15 2023-10-20 /path/to/your/repo
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

2. Run the script:

   ```bash
   ./auto-commit.sh <START_DATE> <END_DATE> <REPO_DIR>
   ```

---

## 🔍 Script Breakdown

1. **Set Repository Path**

   Validates and changes to the specified repository directory.

2. **Loop Over Dates**

   Iterates through each day between `START_DATE` and `END_DATE`, randomly skipping about 20% of days.

3. **For Each Day**

   - Creates multiple files with timestamped content.
   - Uses Git environment variables (`GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE`) to backdate commits without changing system time.
   - Creates a file inside a `src/` directory to simulate changes.
   - Makes 15–20 commits with timestamps fixed at `12:00:00` using `GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE`.

5. **Push and Clean Up**

   ```bash
   git push origin main
   ```

   Pushes all commits to the main branch and cleans up generated files.

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
