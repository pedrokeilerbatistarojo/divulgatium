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
echo Switch from "dev" branch to "deploy-dev-backend"
echo ==================================
git checkout deploy-dev-backend || exit_on_error "Failed to switch to 'deploy-dev-backend' branch."

echo ==================================
echo Pull latest changes from origin/deploy-dev-backend
echo ==================================
git pull origin deploy-dev-backend || exit_on_error "Failed to pull the latest changes for 'deploy-dev-backend' branch."

echo ==============================
echo Merge "dev" branch into "deploy-dev-backend"
echo ==============================
git merge dev || exit_on_error "Failed to merge 'dev' branch into 'deploy-dev-backend'."

echo ======================
echo Push the "deploy-dev-backend" branch
echo ======================
git push --progress origin deploy-dev-backend || exit_on_error "Failed to push 'deploy-dev-backend' branch."

echo =======================================
echo Switch back from "deploy-dev-backend" branch to "dev"
echo =======================================
git checkout dev || exit_on_error "Failed to switch back to 'dev' branch."

echo ==============================
echo Merge "deploy-dev-backend" branch into "dev"
echo ==============================
git merge deploy-dev-backend || exit_on_error "Failed to merge 'deploy-dev-backend' branch into 'dev'."

echo =====================
echo Push the "dev" branch
echo =====================
git push --progress origin dev || exit_on_error "Failed to push 'dev' branch."

echo -e "\n\nSuccessfully merged 'dev' into 'deploy-dev-backend', pushed both branches, and switched back to 'dev'."

