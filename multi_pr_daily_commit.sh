#!/bin/bash

# Start and end date
START_DATE="2024-04-01"
END_DATE="2024-04-10"

# Local repo path
REPO_DIR="/home/master/Documents/projects/test-commit"
cd "$REPO_DIR" || exit 1

# Ensure you're authenticated with GitHub CLI
if ! gh auth status > /dev/null 2>&1; then
    echo "GitHub CLI not authenticated. Run: gh auth login"
    exit 1
fi

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

    # Optionally change system date (sudo required)
    sudo date -s "$CURRENT_DATE"

    for i in {1..5}; do
        BRANCH_NAME="update-${CURRENT_DATE//-/}-pr$i"
        git checkout -b "$BRANCH_NAME"

        # Dummy file update
        echo "Commit $i on $CURRENT_DATE" > "file-${CURRENT_DATE//-/}-$i.txt"
        git add .
        git commit -m "Commit $i on $CURRENT_DATE"
        git push origin "$BRANCH_NAME"

        # Create PR
        gh pr create \
            --title "PR $i for $CURRENT_DATE" \
            --body "Auto-generated PR #$i for $CURRENT_DATE" \
            --head "$BRANCH_NAME" \
            --base main

        # Wait briefly to allow PR to register
        sleep 3

        # Approve and merge
        gh pr review --approve
        gh pr merge --squash --delete-branch
    done

    # Move to next date
    CURRENT_DATE=$(date -I -d "$CURRENT_DATE + 1 day")
done

echo "All done!"
