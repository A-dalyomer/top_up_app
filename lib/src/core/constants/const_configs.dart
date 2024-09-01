/// Constant app configuration variables that would never change
class ConstConfigs {
  /// Supported transaction options for a beneficiary recharge
  static const List<int> transactionOptions = [5, 10, 20, 30, 50, 75, 100];

  /// User constant verified flag to be changed easily
  static const bool userVerified = true;

  /// Initial new user balance
  static const double userInitialBalance = 4000;
}
