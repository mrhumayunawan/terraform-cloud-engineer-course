#!/bin/sh

# Script for automating git add, commit, and push

echo "Staging all changes..."
git add .

echo "Committing changes with a descriptive message..."
git commit -am "Update: Terraform Cloud Engineer Course Projects"

echo "Pushing changes to the main branch on GitHub..."
git push origin main

echo "Deployment complete!"

