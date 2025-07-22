#!/bin/bash

# Usage: ./auto-commit.sh <START_DATE> <END_DATE> <REPO_DIR>
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <START_DATE: YYYY-MM-DD> <END_DATE: YYYY-MM-DD> <REPO_DIR>"
  exit 1
fi

START_DATE="$1"
END_DATE="$2"
REPO_DIR="$3"

echo "Starting auto-commit from $START_DATE to $END_DATE in repo $REPO_DIR"

cd "$REPO_DIR" || { echo "Repo dir not found"; exit 1; }

mkdir -p src

CURRENT_DATE="$START_DATE"

OS="$(uname)"

increment_date() {
  local date="$1"
  if [[ "$OS" == "Darwin" ]]; then
    date -j -f "%Y-%m-%d" "$date" "+%Y-%m-%d" -v+1d
  else
    date -I -d "$date + 1 day"
  fi
}

while [[ "$CURRENT_DATE" < "$END_DATE" ]]; do
    echo "Current date: $CURRENT_DATE"

    # Randomly skip ~20% of days
    SKIP_CHANCE=$(( RANDOM % 100 ))
    if [[ $SKIP_CHANCE -lt 20 ]]; then
        echo "Randomly skipping day: $CURRENT_DATE"
        CURRENT_DATE=$(increment_date "$CURRENT_DATE")
        continue
    fi

    NUM_COMMITS=$((15 + RANDOM % 6))
    echo "Making $NUM_COMMITS commits on $CURRENT_DATE"

    for ((i=1; i<=NUM_COMMITS; i++)); do
        FILENAME="src/file-${CURRENT_DATE//-/}-$i.txt"
        echo "Commit $i on $CURRENT_DATE" > "$FILENAME"
        git add "$FILENAME"

        HOUR=12
        MINUTE=00
        SECOND=$((10 + i))
        COMMIT_TIME="${CURRENT_DATE}T$(printf "%02d:%02d:%02d" $HOUR $MINUTE $SECOND)"

        GIT_AUTHOR_DATE="$COMMIT_TIME" GIT_COMMITTER_DATE="$COMMIT_TIME" \
          git commit -m "Commit $i on $CURRENT_DATE" --quiet
    done

    CURRENT_DATE=$(increment_date "$CURRENT_DATE")
done

echo "All commits done. Now pushing..."

git push origin main

echo "Cleaning up generated files..."

if [ -d "src" ]; then
  rm -f src/file-*.txt
  git add -u src/
  if ! git diff --cached --quiet; then
    git commit -m "Cleanup: remove generated files"
    git push origin main
    echo "Cleanup committed and pushed."
  else
    echo "No changes to commit after cleanup."
  fi
else
  echo "No src directory found, skipping cleanup."
fi

echo "Done."
