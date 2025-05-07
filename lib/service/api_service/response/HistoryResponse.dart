class HistoryResponse {
  final int incidentId;
  final String message;
  final String title;
  final String body;
  final String imageUrl;
  final DateTime timestamp;

  HistoryResponse({
    required this.incidentId,
    required this.message,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.timestamp,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      incidentId: json['incident_id'] as int,
      message: json['message'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['image_url'] as String,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    "incident_id": incidentId,
    "message": message,
    "body": body,
    "image_url": imageUrl,
    "title": title,
    "timestamp": timestamp.toIso8601String(),
  };
}
