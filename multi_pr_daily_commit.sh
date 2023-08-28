#!/bin/bash

# Start and end date
START_DATE="2023-08-28"
END_DATE="2023-09-15"
sudo timedatectl set-ntp false
# Local repo path
REPO_DIR="/home/master/Documents/projects/test-commit"
cd "$REPO_DIR" || exit 1

# Store actual current system time
ACTUAL_DATE=$(date -I)
mkdir -p src
CURRENT_DATE="$START_DATE"

while [[ "$CURRENT_DATE" < "$END_DATE" ]]; do
    # Skip Sundays
    DAY_OF_WEEK=$(date -d "$CURRENT_DATE" +%u)
    if [[ "$DAY_OF_WEEK" -eq 7 ]]; then
        echo "Skipping Sunday: $CURRENT_DATE"
        CURRENT_DATE=$(date -I -d "$CURRENT_DATE + 1 day")
        continue
    fi

    echo "Processing date: $CURRENT_DATE"

    # Change system date
    sudo date -s "$CURRENT_DATE"

    # Random number of commits (15 to 20)
    NUM_COMMITS=$((RANDOM % 6 + 15))

    for ((i = 1; i <= NUM_COMMITS; i++)); do
        echo "Commit $i on $CURRENT_DATE" > "src/file-${CURRENT_DATE//-/}-$i.txt"
        git add .
        GIT_COMMITTER_DATE="$CURRENT_DATE 12:00:00" \
        GIT_AUTHOR_DATE="$CURRENT_DATE 12:00:00" \
        git commit -m "Commit $i on $CURRENT_DATE"
    done

    # Move to next day
    CURRENT_DATE=$(date -I -d "$CURRENT_DATE + 1 day")
done

# Reset system date
echo "Resetting system date to actual: $ACTUAL_DATE"
sudo timedatectl set-ntp true
# Push all changes
git push origin main

echo "All commits done and pushed!"
