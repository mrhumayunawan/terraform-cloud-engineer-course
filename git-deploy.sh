#!/bin/sh

echo "Adding files and committing changes locally"
git add .
git commit -am "Update repository: Terraform Cloud Engineer Course Projects"

echo "Pushing changes to GitHub repository"
git push origin main

