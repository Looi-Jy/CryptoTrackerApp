# CryptoTrackerApp

A simple crypto currencies app.

# Architecture overview
The project follows the MVVM (Model-View-ViewModel) architecture pattern.

It is organized into three main modules:
Data – Handles networking and Core Data persistence.
Domain – Contains models, view models, and use cases.
UI – Includes all SwiftUI and UIKit views.

Below is a simplified architecture diagram.

<img width="904" height="617" alt="Diagram" src="https://github.com/user-attachments/assets/4511d352-dc0a-4e40-b4cc-5d34cc99a9fe" />


# Features implemented

The app supports both SwiftUI and UIKit for the main list view.
On iOS 17 and above, the UI is built using SwiftUI.
On earlier versions, it falls back to UIKit.

Key features include:
Local search
Pull-to-refresh
Add/remove favorites
Network indicator
Offline support using Core Data

Below is a link of a short demo video showcasing the implementation.

https://drive.google.com/file/d/1fN8z6pQXJHore2vCkn7MFVA__UP1xdG9/view?usp=sharing

<img width="700" height="682" alt="Demo" src="https://github.com/user-attachments/assets/ca4cd18d-ae5f-4772-8a2a-e276edf426f4" />
