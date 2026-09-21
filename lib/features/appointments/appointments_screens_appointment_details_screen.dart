part of 'appointments_screens.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.appointment, this.onCancelled});
  final AppointmentData appointment;
  final VoidCallback? onCancelled;

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}
