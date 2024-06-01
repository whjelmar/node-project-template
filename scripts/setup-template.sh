#!/bin/bash

# Function to replace placeholders in a file
replace_placeholders() {
  local filePath=$1
  local projectName=$2
  local shortDescription=$3
  local longDescription=$4
  local currentDate=$5
  local timestamp=$6
  local currentYear=$7
  local author=$8
  local authorEmail=$9

  sed -i.bak \
      -e "s/{{PROJECT_NAME}}/$projectName/g" \
      -e "s/{{SHORT_DESCRIPTION}}/$shortDescription/g" \
      -e "s/{{LONG_DESCRIPTION}}/$longDescription/g" \
      -e "s/{{CURRENT_DATE}}/$currentDate/g" \
      -e "s/{{TIMESTAMP}}/$timestamp/g" \
      -e "s/{{CURRENT_YEAR}}/$currentYear/g" \
      -e "s/{{AUTHOR}}/$author/g" \
      -e "s/{{AUTHOR_EMAIL}}/$authorEmail/g" \
      $filePath

  # Remove the backup file created by sed
  rm "${filePath}.bak"
}

# Parameters
projectName=$1
shortDescription=$2
longDescription=$3
author=${4:-"Walter Hjelmar"}
authorEmail=${5:-"walter@hjelmar.com"}
currentDate=${6:-$(date +"%Y-%m-%d")}
timestamp=${7:-$(date --iso-8601=seconds)}
currentYear=${8:-$(date +"%Y")}

# Function to walk the file system and replace placeholders
process_files() {
  local path=$1
  find "$path" -type f | while read -r file; do
    replace_placeholders "$file" "$projectName" "$shortDescription" "$longDescription" "$currentDate" "$timestamp" "$currentYear" "$author" "$authorEmail"
  done
}

# Process all files in the repository
process_files ..

echo "Placeholders replaced successfully."

# Remove setup scripts and POST_CREATE.md
rm ../POST_CREATE.md
rm setup-template.sh
rm setup-template.ps1

# Commit the removal of setup scripts
git rm ../POST_CREATE.md
git rm setup-template.sh
git rm setup-template.ps1
git commit --message "fix: removing repository cloning scripts"

# Add all changes and commit
git add --all
git commit --message "fix: removing boilerplate cruft"

echo "Cleanup completed successfully."
