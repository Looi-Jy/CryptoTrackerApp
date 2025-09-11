# CryptoTrackerApp

A simple crypto currencies app.

# Architecture overview
The project follows the MVVM (Model-View-ViewModel) architecture pattern.

It is organized into three main modules:
Data – Handles networking and Core Data persistence.
Domain – Contains models, view models, and use cases.
UI – Includes all SwiftUI and UIKit views.

Below is a simplified architecture diagram.
<img width="1044" height="423" alt="Screenshot 2025-09-09 at 9 30 45 PM" src="https://github.com/user-attachments/assets/e726b1bd-d59e-4719-9607-67071167cc01" />


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
