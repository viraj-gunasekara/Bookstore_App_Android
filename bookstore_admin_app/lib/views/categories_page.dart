import 'dart:io';

import 'package:bookstore_admin_app/containers/additional_confirm.dart';
import 'package:bookstore_admin_app/controlllers/db_service.dart';
import 'package:bookstore_admin_app/controlllers/storage_service.dart';
import 'package:bookstore_admin_app/models/categories_model.dart';
import 'package:bookstore_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📁 Categories")),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          List<CategoriesModel> categories = CategoriesModel.fromJsonList(provider.categories);

          if (categories.isEmpty) {
            return const Center(child: Text("No Categories Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Choose Action"),
                      content: const Text("Delete action cannot be undone"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AdditionalConfirm(
                                contentText: "Are you sure you want to delete this?",
                                onYes: () {
                                  DbService().deleteCategories(docId: category.id);
                                  Navigator.pop(context);
                                },
                                onNo: () => Navigator.pop(context),
                              ),
                            );
                          },
                          child: const Text("🗑 Delete"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => ModifyCategory(
                                isUpdating: true,
                                categoryId: category.id,
                                name: category.name,
                                image: category.image,
                                priority: category.priority,
                              ),
                            );
                          },
                          child: const Text("✏️ Update"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 🖼️ Category image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          (category.image == null || category.image!.isEmpty)
                              ? "https://demofree.sirv.com/nope-not-here.jpg"
                              : category.image!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 📝 Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Priority: ${category.priority}",
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),

                      // ✏️ Edit icon
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ModifyCategory(
                              isUpdating: true,
                              categoryId: category.id,
                              name: category.name,
                              image: category.image,
                              priority: category.priority,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ModifyCategory(
              isUpdating: false,
              categoryId: "",
              priority: 0,
            ),
          );
        },
        label: const Text("Add Category"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}


class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory({
    super.key,
    required this.isUpdating,
    this.name,
    required this.categoryId,
    this.image,
    required this.priority,
  });

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
  }

  // function to pick image using image picker
  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await StorageService().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully")),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Update Category" : "Add Category"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("All will be converted to lowercase"),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This cant be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  label: Text("Category Name"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              Text("This will be used in ordering categories"),
              SizedBox(height: 10),
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "This cant be empty." : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Priority",
                  label: Text("Priority"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),

              image == null
                  ? imageController.text.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.all(20),
                            height: 100,
                            width: double.infinity,
                            color: Colors.deepPurple.shade50,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                            ),
                          )
                        : SizedBox()
                  : Container(
                      margin: EdgeInsets.all(20),
                      height: 150,
                      width: double.infinity,
                      color: Colors.deepPurple.shade50,
                      child: Image.file(File(image!.path), fit: BoxFit.contain),
                    ),

              ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text("Pick Image"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "This cant be empty." : null,
                decoration: InputDecoration(
                  hintText: "Image Link",
                  label: Text("Image Link"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              if (widget.isUpdating) {
                await DbService().updateCategories(
                  docId: widget.categoryId,
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Category Updated")));
              } else {
                await DbService().createCategories(
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Category Added")));
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.isUpdating ? "Update" : "Add"),
        ),
      ],
    );
  }
}
