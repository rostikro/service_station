# Service Station

Service Station is a simple application built with Flutter. With its help, you can easily organize the calculation of the cost of services for a company. In this example, the company is a service station. You can use this app for any other purpose.

## Getting Started

Once you have cloned, you need to run `pub get` to install the required plugins specified in the `pubspec.yaml` file.

### Firebase configuration

First, you need to create a Firebase database. Next, configure `Firestore Database` and `Storage`. In `Storage` create a folder `images`. In this folder, upload a picture with the name `default_image.jpg`. This image will be displayed by default in the work tiles, if the user does not want to change it to his own.

Next, configure the `google-services.json` file. Move your downloaded `google-services.json` file into your module (app-level) root directory. For more detailed instructions, you can read the official documentation: [Firebase docs](https://firebase.google.com/docs/android/setup?authuser=0&hl=en#add-config-file)