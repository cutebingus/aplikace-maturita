import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_service.dart';
import 'package:flutter_application_1/model/meal.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  // konstruktor prijimajici vybrane jidlo
  const MealDetailScreen({Key? key, required this.meal}) : super(key: key);

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // inicializace AnimationController a animace pro zmeny opacity
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // spusteni animace pri nacteni obrazovky
    _animationController.forward();
  }

  @override
  void dispose() {
    // uvolneni resources pro AnimationController
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          try {
            DatabaseService.instance.logMeal(widget.meal);
            Navigator.of(context).pop();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to log meal: $e"),
              ),
            );
          }
        },
        label: const Text("Log Meal"),
        icon: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFFE9E9E9),
      body: FadeTransition(
        opacity: _fadeAnimation, // obaleni obsahu do fade animace
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              expandedHeight: 300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              flexibleSpace: FlexibleSpaceBar(
                // zobrazeni obrazku vybraneho jidla
                background: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                  child: widget.meal.imagePath == null
                      ? Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Text("No Image"),
                          ),
                        )
                      : Image.network(
                          widget.meal.imagePath!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 20),
                  // zobrazeni detailu jidla, jako jsou cas a kalorie
                  ListTile(
                    title: Text(
                      widget.meal.mealTime ?? "".toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                    subtitle: Text(
                      widget.meal.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 30),
                            Text(
                              "${widget.meal.kiloCaloriesBurnt} kcal",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${widget.meal.timeTaken} mins",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "INGREDIENTS",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // seznam ingredienci pro jidlo

                  if (widget.meal.ingredients != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (int i = 0;
                              i < widget.meal.ingredients!.length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                widget.meal.ingredients![i],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "PREPARATION",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  // instrukce k priprave jidla
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    child: Text(
                      widget.meal.preparation ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}