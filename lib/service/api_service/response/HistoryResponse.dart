class HistoryResponse {
  final int incidentId;
  final String message;
  final DateTime timestamp;

  HistoryResponse({
    required this.incidentId,
    required this.message,
    required this.timestamp,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      incidentId: json['incident_id'] as int,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    "incident_id": incidentId,
    "message": message,
    "timestamp": timestamp.toIso8601String(),
  };
}
