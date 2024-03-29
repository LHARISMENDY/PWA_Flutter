# Flutter PWA used as a QrCode & Barcode Scanner

## Requirements

You need to have the following software installed:

- Flutter SDK (Stable Channel > 2.0)
- Chrome browser
- Node.js (recommended version 15.14.0 )

## Project Setup

​	To launch this PWA, we can use Firebase, it is a service offered by Google to host our application.

To deploy our application:

1. You must create an account on the service website (https://firebase.google.com/).
2. Create the project of our application on the site : https://console.firebase.google.com/
3. Install Firebase with *Node.js* and the *Node Package Manager*.
4. `firebase login`
5. `firebase init`
6. Select `Hosting`
7. Select `Use an existing project` and fill in the created project
8. Give the path to `build/web`
9. Launch a  *build* of our web app with `flutter build web`
10. Finally, launch the deployment with `firebase deploy`

## Debugging

For *debug* on browser:
`flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`

## How PWAs are integrated with Flutter

​	Since release 1.20, Flutter web includes support for PWA. These PWA are installable and usable offline. No change compared to a classic PWA.

> https://flutter.dev/docs/deployment/web

To make our website installable, it is necessary:

- A manifest, with mandatory fields :
  - `background_color` : the background color in a particular context like loading the application.
  - `display` : specifies how the application is displayed.
  - `icons` : the icon representing the application in the web browser or when loading.
  - `name` ou un `shortname` : the first is the full name and the second is used when there is not enough space.
  - `start_url` : the link to the first item loaded when the application is installed.
- A website to be used from a secure HTTPS domain.
- An icon representing the application. 
- A *service worker* to use the application in disconnected mode.

##### Here our index.html

<img src="doc/manifest.png" alt="manifest" style="zoom: 40%;" />

​	It contains several useful parameters to customize the installed application. To make it PWA on supported browsers, the *serviceWorker* is enabled between the `<script>` tags. This service initially allows you to configure the use of the application's cache for a better experience in offline mode. Flutter generates the `flutter_secure_worker.js` which describes the use of the service, available in: `.build/web/flutter_service_worker.js`

​	Enabling the PWA allows mobile users to *Add to Home Screen* or *A2HS*, a feature of browsers that uses the manifest information to provide an installable version of the application. A splash screen is sometimes generated by some browsers that also use the manifest information.

###### An update on IOS contraints:

​	Progressive Web Apps allow you to benefit from the best of web and mobile applications. It allows to get closer to the capabilities of a native application while having the accessibility of a website.

<img src="doc/capacityandreach.png" alt="capacityandreach" style="zoom:33%;" />

Despite the cross-platform compatibility of PWAs, Apple adds some constraints to their use on iOS. It limits some uses :

- No incentive to install the icon on the home screen although it is possible.
- No possibility to open a link in Safari from a PWA.
- No push notifications, no biometric authentication, etc.




