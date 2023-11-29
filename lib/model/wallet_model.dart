class WalletModel {
  final int amount;
  final String userId;

  const WalletModel({
    required this.amount,
    required this.userId,
  });

  toJson() {
    return {
      "amount": amount,
      "userId": userId
    };
  }
}