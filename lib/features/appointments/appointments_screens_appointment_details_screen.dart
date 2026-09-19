part of 'appointments_screens.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.appointment, this.onCancelled});
  final MockAppointment appointment;
  final VoidCallback? onCancelled;

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}
