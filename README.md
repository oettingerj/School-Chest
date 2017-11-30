DHS School Chest App
====================

This app was developed in 2017 by Josh Oettinger for Deerfield High School's annual charity fundraiser.

### [View in App Store](https://itunes.apple.com/us/app/dhs-school-chest/id1312538858?ls=1&mt=8 "School Chest")

---

### How it works
The app gets all its information (event info, lunches, announcements, coupons) from a Google Firebase-powered backend. If you need access to this server, contact [Josh Oettinger](mailto:joshkyle98@gmail.com "Email Josh Oettinger"). You should not need access to the Firebase account to build the app, though.

### Build Instructions
1.  Fork or clone the repository.
2.  Create a new Xcode project, ideally named **School Chest**
3.  Copy the files in the School Chest directory to your new project.
4.  Copy the `Podfile` to the same directory as your Xcode project.
5.  Run `pod install` in the project directory to install the required dependencies (**CocoaPods**).
6.  Open the Xcode workspace and you're all set!
7.  (Optional) Copy the `swiftlint` file to the same directory as your Xcode project. This contains my SwiftLint preferences and may reduce some annoying warnings generated by the SwiftLint pod.
