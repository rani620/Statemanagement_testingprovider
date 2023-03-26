import 'dart:collection';
// import 'dart:html';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// simple flutter scaffold code snipet
void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => BreadCrumbProvider(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),

      //for routing  we use this method
      routes: {
        '/new': (context) => const NewBreadCrumbWidget(),
      },
    ),
  ));
}

// it
class BreadCrumb {
  bool isActive;
  final String name;
  final String uuid;
// it is a constructor
  BreadCrumb({required this.isActive, required this.name})
      : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  @override
  bool operator ==(covariant BreadCrumb other) =>
      // isActive == other.isActive && name == other.name;

      uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
  String get title => name + (isActive ? '>' : '');
}

// creating my own chnage notifier
class BreadCrumbProvider extends ChangeNotifier {
  // here  i use underscore befor item so that outsider can't use it or manupulate  now it becomes private.

  // list are classes in flutter that can be chnaged intenally .
  final List<BreadCrumb> _items = [];
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb) {
    for (final item in _items) {
      item.activate();
    }

    _items.add(breadCrumb);
    notifyListeners();
  }

  // function for reset all the value

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumbWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;
  const BreadCrumbWidget({super.key, required this.breadCrumbs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb) {
        return Text(
          breadCrumb.title,
          style: TextStyle(
              color: breadCrumb.isActive ? Colors.blue : Colors.black),
        );
      }).toList(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Consumer<BreadCrumbProvider>(
            builder: (context, value, child) {
              return BreadCrumbWidget(
                breadCrumbs: value.items,
              );
            },
          ),
          TextButton(
              onPressed: () {
                // this line is used for the the other part of route
                Navigator.of(context).pushNamed('/new');

                //till here route
              },
              child: const Text('Add new bread crumb  ')),
          TextButton(
              onPressed: () {
                // this line is used for the the other part of route

                context.read<BreadCrumbProvider>().reset();

                //till here route
              },
              child: const Text('Reset '))
        ],
      ),
    );
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({super.key});

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  //1.
  late final TextEditingController _controller;

  @override
  //2.
  void initState() {
    // TODO: implement initState

    _controller = TextEditingController();
    super.initState();
  }

  //3.dispose of the controller
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Bread Crumbs'),
      ),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
              hintText: 'Enter a new Bread Crumbs here..'),
        ),
        TextButton(
            onPressed: () {
              final text = _controller.text;
              if (text.isNotEmpty) {
                final breadCrumb = BreadCrumb(isActive: false, name: text);
                context.read<BreadCrumbProvider>().add(breadCrumb);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'))
      ]),
    );
  }
}
