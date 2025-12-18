import 'package:cafeteria_uide/ui/pages/catering_success.dart';
import 'package:flutter/material.dart';

class CateringPage extends StatefulWidget {
  const CateringPage({super.key});

  @override
  State<CateringPage> createState() => _CateringPageState();
}

class _CateringPageState extends State<CateringPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController peopleCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  String? selectedEventType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> eventTypes = [
    'Evento institucional',
    'Reunión académica',
    'Capacitación',
    'Cumpleaños',
    'Otro',
  ];

  Future<void> pickDate() async {
    final now = DateTime.now().add(const Duration(days: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null) {
      // Aquí luego conectas API / Backend
      debugPrint('Nombre: ${nameCtrl.text}');
      debugPrint('Correo: ${emailCtrl.text}');
      debugPrint('Teléfono: ${phoneCtrl.text}');
      debugPrint('Tipo evento: $selectedEventType');
      debugPrint('Personas: ${peopleCtrl.text}');
      debugPrint('Fecha: $selectedDate');
      debugPrint('Hora: $selectedTime');
      debugPrint('Descripción: ${descriptionCtrl.text}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CateringSuccess()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicio de Catering'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _card(
                child: TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obligatorio' : null,
                ),
              ),
              _card(
                child: TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Correo inválido' : null,
                ),
              ),
              _card(
                child: TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (v) =>
                      v == null || v.length < 7 ? 'Teléfono inválido' : null,
                ),
              ),
              _card(
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de evento',
                  ),
                  items: eventTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => selectedEventType = v,
                  validator: (v) =>
                      v == null ? 'Selecciona un tipo de evento' : null,
                ),
              ),
              _card(
                child: TextFormField(
                  controller: peopleCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad de personas',
                  ),
                  validator: (v) => v == null || int.tryParse(v) == null
                      ? 'Número inválido'
                      : null,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _card(
                      child: ListTile(
                        title: Text(
                          selectedDate == null
                              ? 'Seleccionar fecha'
                              : selectedDate!.toString().split(' ')[0],
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: pickDate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _card(
                      child: ListTile(
                        title: Text(
                          selectedTime == null
                              ? 'Seleccionar hora'
                              : selectedTime!.format(context),
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: pickTime,
                      ),
                    ),
                  ),
                ],
              ),
              _card(
                child: TextFormField(
                  controller: descriptionCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Descripción / requerimientos',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Enviar solicitud'),
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}
