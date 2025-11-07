abstract class BankAccount {
  int _accountNumber;
  String _accountHolder;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  // Getters and Setters
  int get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  set accountHolder(String name) => _accountHolder = name;
  set balance(double amount) => _balance = amount;

  // Abstract methods (implemented differently in child classes)
  void withdraw(double amount);
  void deposit(double amount);

  // Display common info
  void displayInfo() {
    print('Account Number: $_accountNumber');
    print('Holder Name: $_accountHolder');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
  }
}

//Interface for interest-bearing accounts
abstract class InterestBearing {
  double calculateInterest();
}

//Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 500.0;
  static const double _interestRate = 0.02;
  int _withdrawCount = 0;
  static const int _withdrawLimit = 3;

  SavingsAccount(int accNo, String holder, double balance)
      : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Savings Account.");
  }

  @override
  void withdraw(double amount) {
    if (_withdrawCount >= _withdrawLimit) {
      print("Withdrawal limit reached (3 per month).");
    } else if (balance - amount < _minBalance) {
      print("Cannot withdraw. Must maintain minimum balance of \$$_minBalance.");
    } else {
      balance -= amount;
      _withdrawCount++;
      print("Withdrawn \$${amount.toStringAsFixed(2)} from Savings Account.");
    }
  }

  @override
  double calculateInterest() {
    return balance * _interestRate;
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(int accNo, String holder, double balance)
      : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Checking Account.");
  }

  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= _overdraftFee;
      print("Overdraft! Charged \$$_overdraftFee fee.");
    }
    print("Withdrawn \$${amount.toStringAsFixed(2)} from Checking Account.");
  }
}

//Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 10000.0;
  static const double _interestRate = 0.05;

  PremiumAccount(int accNo, String holder, double balance)
      : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Premium Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < _minBalance) {
      print("Cannot go below minimum balance of \$$_minBalance.");
    } else {
      balance -= amount;
      print("Withdrawn \$${amount.toStringAsFixed(2)} from Premium Account.");
    }
  }

  @override
  double calculateInterest() {
    return balance * _interestRate;
  }
}

//Bank class — Composition
class Bank {
  final List<BankAccount> _accounts = [];

  // Create new account
  void addAccount(BankAccount account) {
    _accounts.add(account);
    print(" Account created for ${account.accountHolder}.");
  }

  // Find account by number
  BankAccount? findAccount(int accNo) {
    for (var acc in _accounts) {
      if (acc.accountNumber == accNo) return acc;
    }
    print("Account not found!");
    return null;
  }

  // Transfer money between accounts
  void transfer(int fromAccNo, int toAccNo, double amount) {
    var from = findAccount(fromAccNo);
    var to = findAccount(toAccNo);

    if (from != null && to != null) {
      from.withdraw(amount);
      to.deposit(amount);
      print(" Transferred \$${amount.toStringAsFixed(2)} from ${from.accountHolder} to ${to.accountHolder}");
    }
  }

  // Generate report
  void generateReport() {
    for (var acc in _accounts) {
      acc.displayInfo();
    }
  }
}

// ⿧ Main function
void main() {
  Bank bank = Bank();

  // Create accounts
  var savings = SavingsAccount(1001, "Ram", 1500);
  var checking = CheckingAccount(1002, "Shyam", 800);
  var premium = PremiumAccount(1003, "Hari", 20000);

  // Add accounts to bank
  bank.addAccount(savings);
  bank.addAccount(checking);
  bank.addAccount(premium);

  // Perform operations
  savings.withdraw(200);
  savings.deposit(100);
  print(" Interest for Ram: \$${savings.calculateInterest().toStringAsFixed(2)}");

  checking.withdraw(900); // triggers overdraft
  checking.deposit(200);

  premium.withdraw(5000);
  print(" Interest for Shyam: \$${premium.calculateInterest().toStringAsFixed(2)}");

  // Transfer between accounts
  bank.transfer(1003, 1002, 1000);

  // Generate final report
  bank.generateReport();
}
