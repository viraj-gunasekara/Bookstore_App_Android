import 'package:bookstore_admin_app/containers/home_button.dart';
import 'package:bookstore_admin_app/controlllers/auth_service.dart';
import 'package:bookstore_admin_app/providers/admin_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class CategoryChartEntry {
  final String category;
  final int count;
  final Color color;

  CategoryChartEntry({required this.category, required this.count, required this.color});
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📊 Dashboard Info Cards - UPDATED UI
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(context, title: "Total Categories", value: "${provider.categories.length}", icon: Icons.category_outlined, color: Colors.brown.shade500),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardCard(context, title: "Total Books Count", value: "${provider.books.length}", icon: Icons.menu_book_outlined, color: Colors.purple.shade900),
                ),
              ],
            ),

            const SizedBox(height: 10),
            //Graph show Number of books per category
            // 📊 Pie Chart for Books by Category
            Container(
              height: 280,
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, spreadRadius: 2, offset: Offset(0, 3))],
              ),
              child: Consumer<AdminProvider>(
                builder: (context, provider, child) {
                  Map<String, int> bookCountByCategory = {};

                  for (var book in provider.books) {
                    final data = book.data() as Map<String, dynamic>;
                    final category = data['category'] ?? 'Unknown';
                    bookCountByCategory[category] = (bookCountByCategory[category] ?? 0) + 1;
                  }

                  final totalBooks = bookCountByCategory.values.fold(0, (a, b) => a + b);

                  if (bookCountByCategory.isEmpty) {
                    return const Center(child: Text("No data available for chart"));
                  }

                  final colors = [Colors.deepPurple, Colors.orangeAccent, Colors.teal, Colors.blueAccent, Colors.pinkAccent, Colors.green, Colors.brown, Colors.indigo];

                  // 🔁 Generate entries with consistent color mapping
                  final coloredEntries = bookCountByCategory.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return CategoryChartEntry(category: item.key, count: item.value, color: colors[index % colors.length]);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Books Distribution by Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 38,
                                    sections: coloredEntries.map((entry) {
                                      final percentage = (entry.count / totalBooks * 100).toStringAsFixed(1);
                                      return PieChartSectionData(
                                        color: entry.color,
                                        value: entry.count.toDouble(),
                                        title: "$percentage%",
                                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        radius: 60,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 35),

                            // 🏷️ Category labels with matching color
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: coloredEntries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          margin: const EdgeInsets.only(top: 2),
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: entry.color),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "${entry.category} (${entry.count})",
                                            style: const TextStyle(fontSize: 14),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2, // Limit to 2 lines max
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            // 📦 Admin Control Buttons - Changed from Rows to GridView
            Column(
  children: [
    // 2-column grid for remaining buttons
    GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.6,
      children: [
        HomeButton(
          name: "All Books",
          icon: Icons.menu_book_outlined,
          onTap: () => Navigator.pushNamed(context, "/books"),
        ),
        HomeButton(
          name: "Categories",
          icon: Icons.category_outlined,
          onTap: () => Navigator.pushNamed(context, "/category"),
        ),
        HomeButton(
          name: "Promotions",
          icon: Icons.campaign_outlined,
          onTap: () => Navigator.pushNamed(context, "/promos", arguments: {"promo": true}),
        ),
        HomeButton(
          name: "Banners",
          icon: Icons.image_outlined,
          onTap: () => Navigator.pushNamed(context, "/promos", arguments: {"promo": false}),
        ),
      ],
    ),

    // Full-width Book Orders button
    Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      child: HomeButton(
        name: "Book Orders",
        icon: Icons.format_list_bulleted,
        onTap: () => Navigator.pushNamed(context, "/orders"),
        backgroundColor: Colors.grey.shade800,
      ),
    ),
    const SizedBox(height: 5),
  ],
)

          ],
        ),
      ),
    );
  }

  // 🧩 Modern Dashboard Metric Card - FIXED SIZE
  Widget _buildDashboardCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return SizedBox(
      height: 100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
