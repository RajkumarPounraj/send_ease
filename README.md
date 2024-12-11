# send_ease

Flutter Send Money project - A simple money send app. This template provides simple UI and scalable project structure.

The app has basic login and wallet screen screens,send money,and transaction screen.

It's configured with Provider for state management, Http for networking, Repository Pattern,MVVM and convenience methods.

The app support offline. using connectivity_plus plugin.

# Requirements

Before running the app, make sure you have the following installed:

Flutter SDK: You can install Flutter by following the official Flutter installation guide.
Dart SDK: Dart comes bundled with the Flutter SDK.
Android Studio or Visual Studio Code: Recommended IDEs for Flutter development.

# Setup and Installation 

Clone the repository:
git clone https://github.com/your-repository-url/flutter-business-logic-app.git
Navigate to the project directory:

cd send_ease

Install dependencies: Run the following command to fetch all necessary dependencies:

flutter pub get

Run the app: Connect your mobile device or start an emulator, and run the app using the following command:

flutter run


# Screens & Business Logic

1st Screen - Login 
Login: User can log in with valid credentials (for this task, we assume simple mock login).
Logout: User can log out of the app and return to the login screen from any other screen.

2nd Screen - Wallet Screen

Balance: Displays the user's current balance, for example: 500.00 PHP.
Show/Hide Balance: Clicking the eye icon toggles the visibility of the balance (e.g., showing ******).
Send Money: Clicking on the "Send Money" button opens the 3rd screen where the user can enter an amount.
View Transactions: Clicking on the "View Transactions" button opens the 4th screen where the user can view their transaction history.
3rd Screen - Send Money
Amount Entry: User can enter the amount to send. The input field only accepts numeric values.
Submit: Clicking the "Submit" button will trigger a bottom sheet to show success or failure of the transaction.
4th Screen - My Transaction 
Transaction List: Displays all past transactions made by the user, showing details such as the amount sent.

# Project Structure

lib/
├── main.dart                   # Main entry point
├── route/                      # Contains the different screens (1st, 2nd, 3rd, 4th)
│    ├── login_view
│    ├── my_wallet_view
│    ├── send_money_view
│    └── transaction_view.
├── core/                    # Contains api,constants etc.
└── custom_widgets/          # Placeholder for loading view  

# API used

The app integrates with the mock API hosted on https://my-json-server.typicode.com.
using data in db.json file.(https://my-json-server.typicode.com/RajkumarPounraj/send_ease)
The API URL is stored in the .env file for easy configuration and secure management.
The flutter_dotenv package is used to load environment variables at runtime.
The API URL is used to make HTTP requests, fetching data from the mock server.

In the root directory of your Flutter project, create or update the .env file. Add the following line to specify the URL of the mock API:
BASEURL=https://my-json-server.typicode.com/RajkumarPounraj/send_ease



# Login Credentials
For development or testing purposes, you can use the following sample login credentials to test the login functionality:

1).Test Login
Username: testuser@gmail.com
Password: password123

2).Test Login
Username: testaccount@gmail.com
Password: password@123









