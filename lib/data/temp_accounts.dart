class AccountModel {
  String accName;
  String bankLogo;
  String bankName;
  String accNumber;

  AccountModel({
    required this.accName,
    required this.accNumber,
    required this.bankName,
    required this.bankLogo,
  });
}

final List<AccountModel> tempAccounts = [
  AccountModel(
    accName: "Precious Wen",
    accNumber: "23347***90",
    bankName: "Access bank",
    bankLogo: "assets/images/access_bank_logo.png",
  ),
  AccountModel(
    accName: "Precious Wen",
    accNumber: "45580***87",
    bankName: "First Bank",
    bankLogo: "assets/images/firstbank_logo.png",
  ),
];
