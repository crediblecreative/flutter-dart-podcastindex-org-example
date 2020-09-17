# flutter-dart-podcastindex-org-example
This is an example of how to connect to the podcastindex.org API using Flutter/Dart

    1) Replace the Flutter app's auto-generated lib/main.dart with the new version from this repo

    2) Update the lib/main.dart file with  your API key and API secret. If either your API key or API secret contain dollar signs ($) escape them with backslashed (\$).

    3) Replace the pubspec.yaml file with the new version from this repo (this handles package dependencies)

    4) If you're building an Android client, replace the /android/app/src/main/AndroidManifest.xml with the new version from this repo (this contains the permission necessary for the app to access the internet from an Android emulator). 
    
    5) Be sure to change the values CHANGE_TO_APP_NAME in AndroidManifest.xml to match your app's name. If you created the app with the command 'flutter create my_podcast_index_client' change the values to my_podcast_index_client.

## Potential Issues

    1) The Android emulator has no network access: Add 8.8.8.8 to your machine's list of DNS servers. This is Google's own DNS server, which the app is likely trying to access. Another potential issue is that the app is attempting to run through a proxied setup. Open the emulator's Extended Controls, then click Settings, then click the Proxy tab. Here you can select No Proxy.

    2) The web app thows CORS errors: The only remedy is to have a CORS header sent from the API. As of this writing the API endpoint the example is attempting to access should have CORS enabled, so this should not be a problem.