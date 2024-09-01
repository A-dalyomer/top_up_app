# UAE Top-Up Application

This Flutter application allows users to top up UAE phone numbers with credit for making local phone calls.

## Core Features

- **Beneficiaries**
    - Add up to 5 active beneficiaries.
    - Each beneficiary has a nickname with a maximum length of 20 characters.
    - View and manage existing beneficiaries with a horizontal list view.

- **Transactions**
    - Top-up amounts available (AED 5, AED 10, AED 20, AED 30, AED 50, AED 75, AED 100).
    - Enforced top-up limits based on user verification status:
        - Verified users: Up to AED 1,000 per month per beneficiary.
        - Unverified users: Up to AED 500 per month per beneficiary.
        - A total limit of AED 3,000 per month for all beneficiaries.
    - AED 1 charge applied for each top-up transaction.
    - Users can only top up with an amount equal to or less than their balance.

- **User Balance Handling**
    - The user’s balance is debited before the top-up transaction is attempted.
    - On mock server, also the user balance is debited before top-up transaction is attempted.
    - On app side, if transaction did not success, the user balance is reAdded

## Development Process

### 1. Requirement Analysis
- Analyzed the features, acceptance criteria and UI requirement for the project.
- Planned the overall architecture and flow of the application.

### 2. Initial Setup
- Added essential dependencies:
  - State manage with provider.
  - Encrypted locale storage with flutter_secure_storage.
  - API requests and mock client with http.
  - DI with get_it.
  - Localization with easy_localization.
  - Login screen top icon with flutter_svg.
  - For tests and logic uses, equatable is used to compare entity instances.
- Set up the project structure with necessary folders and files.

### 3. Core Logic Development
- Started with creating core entities and models for transaction, beneficiary and user.
- Implemented core logic for API requests.
- Core logic for handling transactions, user and beneficiaries.
- App configuration manager to handle variable configurations and transaction limits.
- Created Mocked server for a mocked API responses.

### 4. UI Development
- Started after core logic development is done.
- First with login screen and its login states and logic.
- Then moved to home screen UI widgets one by one with its states and logic too.
- Implemented the horizontal list view UI for beneficiaries with the required constraints.

### 5. Unit Testing
- Developed unit tests for core logic and UI components.
- Focused on critical areas like top-up limits, balance handling, and beneficiary management.

### 6. Finalization
- Conducted code cleanup and final checkups with the requirements.
- Added general project documentation.

### 7. Additional notes
- An API token can be easily added now through an interceptor or even directly in 'ApiRequestRepository'
- We can also apply a global requests encryption algorithm through the 'ApiRequestRepository' since it handles every request in the app
- To change the user verification flag, user initial balance and recharge options, head to [Configs](/lib/src/core/constants/const_configs.dart).

## Github repo

The project is uploaded to a private repository on [Github link](https://github.com/A-dalyomer/top_up_app.git).
Also an APK will be provided there as a release.
I have added "rafina.akhtar email" to the repo too.
