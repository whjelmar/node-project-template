param (
    [string]$projectName,
    [string]$shortDescription,
    [string]$longDescription,
    [string]$author = "Walter Hjelmar",
    [string]$authorEmail = "walter@hjelmar.com",
    [string]$currentDate = (Get-Date -Format "yyyy-MM-dd"),
    [string]$timestamp = (Get-Date -Format "o"),
    [string]$currentYear = (Get-Date -Format "yyyy")
)

# Function to replace placeholders in a file
function Replace-Placeholders {
    param (
        [string]$filePath,
        [string]$projectName,
        [string]$shortDescription,
        [string]$longDescription,
        [string]$currentDate,
        [string]$timestamp,
        [string]$currentYear,
        [string]$author,
        [string]$authorEmail
    )

    (Get-Content $filePath) -replace "{{PROJECT_NAME}}", $projectName `
                            -replace "{{SHORT_DESCRIPTION}}", $shortDescription `
                            -replace "{{LONG_DESCRIPTION}}", $longDescription `
                            -replace "{{CURRENT_DATE}}", $currentDate `
                            -replace "{{TIMESTAMP}}", $timestamp `
                            -replace "{{CURRENT_YEAR}}", $currentYear `
                            -replace "{{AUTHOR}}", $author `
                            -replace "{{AUTHOR_EMAIL}}", $authorEmail | Set-Content $filePath
}

# Function to walk the file system and replace placeholders
function Process-Files {
    param (
        [string]$path
    )

    Get-ChildItem -Path $path -Recurse -File | ForEach-Object {
        Replace-Placeholders -filePath $_.FullName `
                             -projectName $projectName `
                             -shortDescription $shortDescription `
                             -longDescription $longDescription `
                             -currentDate $currentDate `
                             -timestamp $timestamp `
                             -currentYear $currentYear `
                             -author $author `
                             -authorEmail $authorEmail
    }
}

# Process all files in the repository
Process-Files -path ".."

Write-Host "Placeholders replaced successfully."

# Remove setup scripts and POST_CREATE.md
Remove-Item -Path ../POST_CREATE.md
Remove-Item -Path setup-template.sh
Remove-Item -Path setup-template.ps1

# Commit the removal of setup scripts
git rm ../POST_CREATE.md
git rm setup-template.sh
git rm setup-template.ps1
git commit --message "fix: removing repository cloning scripts"

# Add all changes and commit
git add --all
git commit --message "fix: removing boilerplate cruft"

Write-Host "Cleanup completed successfully."
