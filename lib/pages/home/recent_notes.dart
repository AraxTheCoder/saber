
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:saber/data/file_manager.dart';
import 'package:saber/data/routes.dart';
import 'package:saber/components/home/masonry_files.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final List<String> filePaths = [];
  bool failed = false;

  @override
  void initState() {
    super.initState();
    findRecentlyAccessedNotes();
  }

  Future findRecentlyAccessedNotes() async {
    List<String>? children = await FileManager.getRecentlyAccessed();
    filePaths.clear();
    if (children == null) {
      failed = true;
    } else {
      failed = false;
      filePaths.addAll(children);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: const Text("Recent notes"),
      ),
      body: failed ? const Text("Welcome") : MasonryFiles(
        files: [
          for (String filePath in filePaths) filePath,
        ],
        onTap: (String filePath) {
          context.push("${RoutePaths.edit}?path=$filePath");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("${RoutePaths.edit}?path=/example/path/to/new-note");
        },
        tooltip: "New note",
        child: const Icon(Icons.add),
      ),
    );
  }
}
