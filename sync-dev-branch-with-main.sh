#!/bin/bash

# Function to print a message and exit the script with a status code
function exit_on_error {
    echo "$1"
    exit 1
}

# Get the count of pending changes
pending_changes=$(git status --porcelain | wc -l)

# Check if there are any pending changes
if [ $pending_changes -ne 0 ]; then
  exit_on_error "You have $pending_changes pending changes."
fi

echo =====================
echo Push the "dev" branch
echo =====================
git push --progress origin dev || exit_on_error "Failed to push 'dev' branch."


echo ==================================
echo Switch from "dev" branch to "main"
echo ==================================
git checkout main || exit_on_error "Failed to switch to 'main' branch."

echo ==================================
echo Pull latest changes from origin/main
echo ==================================
git pull origin main || exit_on_error "Failed to pull the latest changes for 'main' branch."

echo ==============================
echo Merge "dev" branch into "main"
echo ==============================
git merge dev || exit_on_error "Failed to merge 'dev' branch into 'main'."

echo ======================
echo Push the "main" branch
echo ======================
git push --progress origin main || exit_on_error "Failed to push 'main' branch."

echo =======================================
echo Switch back from "main" branch to "dev"
echo =======================================
git checkout dev || exit_on_error "Failed to switch back to 'dev' branch."

echo ==============================
echo Merge "main" branch into "dev"
echo ==============================
git merge main || exit_on_error "Failed to merge 'main' branch into 'dev'."

echo =====================
echo Push the "dev" branch
echo =====================
git push --progress origin dev || exit_on_error "Failed to push 'dev' branch."

echo -e "\n\nSuccessfully merged 'dev' into 'main', pushed both branches, and switched back to 'dev'."

