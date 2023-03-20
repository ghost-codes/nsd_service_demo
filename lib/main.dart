import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter NSD Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter NSD Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Discovery discovery;
  Service service = Service();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      discovery = await startDiscovery('_http._tcp', ipLookupType: IpLookupType.any);
      discovery.addListener(() {
        discovery.services.firstWhere(
          (element) => element.name == "nsd_local",
          orElse: () => Service(),
        );

        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    stopDiscovery(discovery);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              service.name == null ? 'Service not found' : 'Service found',
            ),
            Text(
              'Service name: ${service.name}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Service type: ${service.type}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Service IPs: ${service.addresses}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
