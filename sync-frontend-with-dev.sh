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
echo Switch from "dev" branch to "frontend-dev"
echo ==================================
git checkout frontend-dev || exit_on_error "Failed to switch to 'frontend-dev' branch."

echo ==================================
echo Pull latest changes from origin/frontend-dev
echo ==================================
git pull origin frontend-dev || exit_on_error "Failed to pull the latest changes for 'frontend-dev' branch."

echo =======================================
echo Switch back from "frontend-dev" branch to "dev"
echo =======================================
git checkout dev || exit_on_error "Failed to switch back to 'dev' branch."

echo ==============================
echo Merge "frontend-dev" branch into "dev"
echo ==============================
git merge frontend-dev || exit_on_error "Failed to merge 'frontend-dev' branch into 'dev'."

echo =====================
echo Push the "dev" branch
echo =====================
git push --progress origin dev || exit_on_error "Failed to push 'dev' branch."

echo -e "\n\nSuccessfully merged 'frontend-dev' into 'dev', pushed both branches, and switched back to 'dev'."

