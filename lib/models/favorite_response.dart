class FavoriteResponse {
  final bool success;
  final String? statusMessage;

  FavoriteResponse({
    required this.success,
    this.statusMessage,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      success: json['success'],
      statusMessage: json['status_message'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_message': statusMessage,
    };
  }
}
