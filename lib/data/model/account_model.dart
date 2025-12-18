// هذا لسهولة التعامل مع البيانات المستقبلة
class AccountModel {
  final int id;
  final String accountNumber;
  final String type;
  final double balance;
  
  // دالة تحويل من JSON
  AccountModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        accountNumber = json['account_number'],
        type = json['type'],
        balance = (json['balance'] as num).toDouble();
}

class AccountsResponseModel {
  final List<AccountModel> accounts;
  final double totalBalance;

  AccountsResponseModel.fromJson(Map<String, dynamic> json)
      : accounts = (json['accounts'] as List)
            .map((i) => AccountModel.fromJson(i))
            .toList(),
        totalBalance = (json['total_balance'] as num).toDouble();
}



// ... (كود AccountModel و AccountsResponseModel السابق)

class TicketModel {
  final int id;
  final String title;
  final int accountId;
  final int userId;
  final String status; // يمكن افتراض حالة مثل 'open' أو 'active'

  TicketModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? '',
        accountId = int.tryParse(json['account_id'].toString()) ?? 0,
        userId = json['user_id'] ?? 0,
        status = json['status'] ?? 'open';
}