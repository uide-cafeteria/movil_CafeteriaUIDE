import 'package:flutter/material.dart';
import '../../models/dish.dart';
import '../layout/widgets/header_bar.dart';
import '../layout/widgets/dish_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de platos con imágenes locales
    final dishes = [
      // PLATO 1 - CARBONARA
      Dish(
        title: "Pasta Carbonara",
        description: "Pasta cremosa con tocino, huevo y queso parmesano",
        image: "assets/images/carbonara.jpg",
        price: 4.50,
        isMain: true,
      ),

      // PLATO 2 - HAMBURGUESA
      Dish(
        title: "Hamburguesa Especial",
        description: "Carne de res, queso cheddar, lechuga, tomate y salsa especial",
        image: "assets/images/hamburguesa.jpg",
        price: 5.75,
        isMain: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // CABECERA
              const HeaderBar(),

              const SizedBox(height: 20),

              // MENÚ DEL DÍA
              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Menú del día - jueves, 13 de noviembre",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // LISTA DE CARDS
              for (var d in dishes) DishCard(dish: d),
            ],
          ),
        ),
      ),
    );
  }
}
