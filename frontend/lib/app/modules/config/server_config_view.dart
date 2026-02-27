import 'package:flutter/material.dart';
import '../../utils/end_point.dart';
import '../../utils/storage.dart';
import 'package:get/get.dart';

class ServerConfigView extends StatefulWidget {
  const ServerConfigView({super.key});

  @override
  State<ServerConfigView> createState() => _ServerConfigViewState();
}

class _ServerConfigViewState extends State<ServerConfigView> {
  final _formKey = GlobalKey<FormState>();
  final ipController = TextEditingController();
  final portController = TextEditingController();

  String previewUrl = '';

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final ip = await Storage.getServerIp();
    final port = await Storage.getServerPort();

    ipController.text = ip;
    portController.text = port;
    _updatePreview();
  }

  void _updatePreview() {
    setState(() {
      previewUrl = 'http://${ipController.text}:${portController.text}';
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final ip = ipController.text.trim();
    final port = portController.text.trim();

    await Storage.saveServerConfig(ip, port);

    await Endpoint.setBaseUrl(ip, port);

    Get.snackbar('Success', 'Server configuration saved');
    Get.back();
    Get.offAllNamed('/chat');
  }

  String? _validateIp(String? value) {
    if (value == null || value.isEmpty) return 'Enter IP address';
    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!ipRegex.hasMatch(value)) return 'Invalid IP format';
    return null;
  }

  String? _validatePort(String? value) {
    if (value == null || value.isEmpty) return 'Enter port';
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) return 'Invalid port';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Server Configuration')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.dns),
                ),
                validator: _validateIp,
                onChanged: (_) => _updatePreview(),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.settings_ethernet),
                ),
                keyboardType: TextInputType.number,
                validator: _validatePort,
                onChanged: (_) => _updatePreview(),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Server URL: $previewUrl',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Configuration'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}