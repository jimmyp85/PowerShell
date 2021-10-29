# Folder Redirection Registry Fix

## Introduction

This script has been written to quickly correct registry entries that were not changed when a change was made to a folder redirection group policy. This prevented the correct user folders from being accessed over the network and presents an error when logging on or accessing one of these folders.

## How it works

The script backups up the registry keys being changed, changes them to the path you enter in the script and then show you the new values so you can make sure they are changed correctly.

## Changes to make

Change \\SERVER\FOLDER to the correct location.
You can remove or add any additonal locations as needed.
$Username has been put in the script to detect your username if the server folder users your username to house your desktop and documents folders.

## How to run

Save the script in a location on the server and edit it with the locations you need.
Open PowerShell as an administrator and CD to the location you have saved the script.
run the script in PowerShell - .\FolderRedirFix.ps1
