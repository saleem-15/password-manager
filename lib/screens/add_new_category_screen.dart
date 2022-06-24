import 'package:flutter/material.dart';
import 'package:password_manager/helpers/colors.dart';
import 'package:password_manager/models/category.dart';
import 'package:provider/provider.dart';

class AddNewCategory extends StatefulWidget {
   AddNewCategory({required this.ctx,super.key});
  BuildContext ctx;
  //static const route = '/add new category';

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  late String title;

  late String icon;

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 120,
              ),
              const Text(
                'Add New Category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: text_title_color,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Name'),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  constraints: BoxConstraints(maxHeight: 50),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  child: const Text(
                    'Add New Category',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();

                    Provider.of<CategoryProvider>(widget.ctx, listen: false)
                        .addNewCategory(name);

                    nameController.clear();
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
