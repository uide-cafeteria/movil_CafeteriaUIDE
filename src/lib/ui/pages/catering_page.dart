import 'package:cafeteria_uide/ui/pages/catering_success.dart';
import 'package:flutter/material.dart';

class CateringPage extends StatefulWidget {
  const CateringPage({super.key});

  @override
  State<CateringPage> createState() => _CateringPageState();
}

class _CateringPageState extends State<CateringPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController numPeopleCtrl = TextEditingController();
  final TextEditingController commentsCtrl = TextEditingController();

  String? selectedDish;
  String? selectedDecoration;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<Map<String, String>> dishes = [
    {'value': 'ejecutivo', 'label': 'Menú Ejecutivo'},
    {'value': 'vegetariano', 'label': 'Menú Vegetariano'},
    {'value': 'vegano', 'label': 'Menú Vegano'},
    {'value': 'sandwiches', 'label': 'Sandwiches Gourmet'},
    {'value': 'buffet', 'label': 'Almuerzo Buffet'},
  ];

  final List<Map<String, String>> decorations = [
    {'value': 'ninguna', 'label': 'Sin decoración'},
    {'value': 'formal', 'label': 'Formal'},
    {'value': 'cumpleanos', 'label': 'Cumpleaños'},
    {'value': 'institucional', 'label': 'Evento Institucional'},
    {'value': 'personalizada', 'label': 'Personalizada'},
  ];

  Future<void> pickDate() async {
    final now = DateTime.now().add(const Duration(days: 2));
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
    if (_formKey.currentState!.validate()) {
      // Aquí luego conectas Firebase / API
      debugPrint('Personas: ${numPeopleCtrl.text}');
      debugPrint('Plato: $selectedDish');
      debugPrint('Fecha: $selectedDate');
      debugPrint('Hora: $selectedTime');
      debugPrint('Decoración: $selectedDecoration');
      debugPrint('Comentarios: ${commentsCtrl.text}');

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
                  controller: numPeopleCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número de personas',
                    hintText: 'Mínimo 10',
                  ),
                  validator: (v) =>
                      v == null || int.tryParse(v) == null || int.parse(v) < 10
                      ? 'Mínimo 10 personas'
                      : null,
                ),
              ),
              _card(
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Menú a servir'),
                  items: dishes
                      .map(
                        (d) => DropdownMenuItem(
                          value: d['value'],
                          child: Text(d['label']!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => selectedDish = v,
                  validator: (v) => v == null ? 'Selecciona un menú' : null,
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
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Decoración'),
                  items: decorations
                      .map(
                        (d) => DropdownMenuItem(
                          value: d['value'],
                          child: Text(d['label']!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => selectedDecoration = v,
                  validator: (v) => v == null ? 'Selecciona una opción' : null,
                ),
              ),
              _card(
                child: TextFormField(
                  controller: commentsCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Comentarios adicionales',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Solicitar Catering'),
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
