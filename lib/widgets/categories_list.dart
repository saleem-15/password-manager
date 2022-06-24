import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../screens/add_new_category_screen.dart';
import 'category.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 140),
      child: FutureBuilder(
        future: Provider.of<CategoryProvider>(context,listen: false).getAllCategories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>  AddNewCategory(ctx: context),
                    ));
                  },
                  child: Container(
                    width: 110,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Center(child: Icon(Icons.add)),
                  ),
                )
              ],
            );
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (snapshot.hasData)
                ...snapshot.data!
                    .map((e) => CategoryWidget(categoryName: e.name))
                    .toList(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>  AddNewCategory(ctx: context),
                  ));
                },
                child: Container(
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(child: Icon(Icons.add)),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
