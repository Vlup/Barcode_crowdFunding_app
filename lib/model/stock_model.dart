class StockModel {
  final String symbol;
  final double price;
  final double share;
  final double total;
  final String userId;

  const StockModel({
    required this.symbol,
    required this.price,
    required this.share,
    required this.total,
    required this.userId,
  });

  toJson() {
    return {
      "symbol": symbol,
      "price": price,
      "share": share,
      "total": total,
      "userId": userId
    };
  }
}