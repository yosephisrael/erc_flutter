import 'dart:async';

class TicketExpirationService {
  Timer? _timer;

  void startService() {
    _timer = Timer.periodic(Duration(hours: 1), (timer) {
      //checkAndDeleteExpiredTickets();
    });
  }

  void stopService() {
    _timer?.cancel();
  }
}
