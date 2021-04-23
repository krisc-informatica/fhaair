# fhaair

An example exercise for the Mobile Information Systems course at FH-Aachen in the summer semester 2021

## Step 1: project creation

- The solution that is shared here has been created with the following command: 'flutter create --org de.fh_aachen.mis fhaair'
- When you want to distribute an app, the package name (org) cannot be the default name 'com.example'. So, here I have chosen the package name de.fh_aachen.mis. A package name cannot contain '-' as in fh-aachen
- The project name is fhaair (Fachhochschule Aachen Air)

## Step 2: API key in assets folder

In this step we move the api key to an asset 'ambee.json'. We keep this file out of git (.gitignore: assets/ambee.json). We load and parse this file when needed.

- see: https://flutter.dev/docs/development/ui/assets-and-images

## Step 3: Nicer layout for data

- We used https://medium.com/flutter-community/flutter-weather-app-using-provider-c168d59af837 as a reference for the layout of the app.
