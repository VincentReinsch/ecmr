class ApiError extends Object {
  String _error = '';

  ApiError({String? error}) {
    _error = error!;
  }

  bool isEmpty() {
    return _error.isEmpty;
  }

  String get error => _error;
  set error(String error) => _error = error;

  ApiError.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = _error;
    return data;
  }
}
