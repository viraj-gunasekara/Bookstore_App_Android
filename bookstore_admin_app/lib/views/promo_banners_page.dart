import 'package:bookstore_admin_app/containers/additional_confirm.dart';
import 'package:bookstore_admin_app/controlllers/db_service.dart';
import 'package:bookstore_admin_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';

class PromoBannersPage extends StatefulWidget {
  const PromoBannersPage({super.key});

  @override
  State<PromoBannersPage> createState() => _PromoBannersPageState();
}

class _PromoBannersPageState extends State<PromoBannersPage> {
  bool _isInitialized = false;
  bool _isPromo = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments != null && arguments is Map<String, dynamic>) {
          _isPromo = arguments['promo'] ?? true;
        }
        _isInitialized = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isPromo ? "📢 Book Promotions" : "🖼 Book Banners")),
      body: _isInitialized
          ? StreamBuilder(
              stream: DbService().readPromos(_isPromo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PromoBannersModel> promos = PromoBannersModel.fromJsonList(snapshot.data!.docs) as List<PromoBannersModel>;

                  if (promos.isEmpty) {
                    return Center(child: Text("No ${_isPromo ? "Promotions" : "Banners"} found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: promos.length,
                    itemBuilder: (context, index) {
                      final promo = promos[index];

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Choose an Action"),
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
                                          DbService().deletePromos(id: promo.id, isPromo: _isPromo);
                                          Navigator.pop(context);
                                        },
                                        onNo: () => Navigator.pop(context),
                                      ),
                                    );
                                  },
                                  child: Text("Delete ${_isPromo ? "Promo" : "Banner"}"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      "/update_promo",
                                      arguments: {"promo": _isPromo, "detail": promo},
                                    );
                                  },
                                  child: Text("Update ${_isPromo ? "Promo" : "Banner"}"),
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
                              // 📸 Promo image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  promo.image,
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

                              // 📝 Promo/Banner Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      promo.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      promo.category,
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),

                              // ✏️ Edit button
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/update_promo",
                                    arguments: {"promo": _isPromo, "detail": promo},
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : const SizedBox(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/update_promo", arguments: {"promo": _isPromo});
        },
        label: Text("Add ${_isPromo ? "Promo" : "Banner"}"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
