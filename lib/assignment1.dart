abstract class BankAccount {
  // 🔒 Private fields
  String _accountNumber;
  String _holderName;
  double _balance;

  BankAccount(this._accountNumber, this._holderName, this._balance);

  // ✅ Encapsulation using getters/setters
  String get accountNumber => _accountNumber;
  String get holderName => _holderName;
  double get balance => _balance;

  set balance(double amount) {
    if (amount >= 0) {
      _balance = amount;
    } else {
      throw Exception("Balance cannot be negative");
    }
  }

  // 🧩 Abstract methods (for polymorphism)
  void deposit(double amount);
  void withdraw(double amount);

  // Display account info
  void displayInfo() {
    print('Account Number: $_accountNumber');
    print('Holder Name: $_holderName');
    print('Balance: \$$_balance');
  }
}

