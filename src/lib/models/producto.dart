// lib/models/producto.dart
class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String categoria;
  final String ubicacion;
  final bool activo;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoria,
    required this.ubicacion,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    // Convertimos el precio correctamente aunque venga como String
    double precioParseado = 0.0;
    if (json['precio'] != null) {
      if (json['precio'] is num) {
        precioParseado = (json['precio'] as num).toDouble();
      } else if (json['precio'] is String) {
        precioParseado = double.tryParse(json['precio'].toString()) ?? 0.0;
      }
    }

    return Producto(
      id: json['idProducto'].toString(),
      nombre: json['nombre'] ?? 'Sin nombre',
      descripcion: json['descripcion'] ?? '',
      precio: precioParseado,
      // que funcione con localhost
      imagen: json['imagen'] ?? '',
      categoria: json['categoria'] ?? '',
      ubicacion: json['ubicacion'] ?? '',
      activo: json['activo'] == true,
    );
  }
}
