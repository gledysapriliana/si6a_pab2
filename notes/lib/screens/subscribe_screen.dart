import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/fcm_service.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({Key? key}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final TextEditingController _topicController = TextEditingController();
  final FcmService _fcmService = FcmService();

  List<String> _subscribedTopics = [];
  final List<String> _suggestedTopics = [
    'keuangan',
    'berita',
    'olahraga',
    'teknologi',
    'kesehatan',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubscribedTopics();
  }

  Future<void> _loadSubscribedTopics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _subscribedTopics = prefs.getStringList('subscribed_topics') ?? [];

      // Ensure 'notes' and 'berita' are in the list if they are default subscribed
      if (!_subscribedTopics.contains('notes')) _subscribedTopics.add('notes');
      if (!_subscribedTopics.contains('berita'))
        _subscribedTopics.add('berita');

      _saveSubscribedTopics();
    });
  }

  Future<void> _saveSubscribedTopics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('subscribed_topics', _subscribedTopics);
  }

  Future<void> _toggleSubscription(String topic) async {
    final isSubscribed = _subscribedTopics.contains(topic);
    final l10n = AppLocalizations.of(context)!;

    if (isSubscribed) {
      await _fcmService.unsubscribeFromTopic(topic);
      setState(() {
        _subscribedTopics.remove(topic);
      });
      _showSnackBar(l10n.unsubscribedFromTopic(topic));
    } else {
      await _fcmService.subscribeToTopic(topic);
      setState(() {
        _subscribedTopics.add(topic);
      });
      _showSnackBar(l10n.subscribedToTopic(topic));
    }

    await _saveSubscribedTopics();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _subscribeCustomTopic() {
    final l10n = AppLocalizations.of(context)!;
    final topic = _topicController.text.trim();
    if (topic.isNotEmpty) {
      if (!_subscribedTopics.contains(topic)) {
        _toggleSubscription(topic);
      } else {
        _showSnackBar(l10n.alreadySubscribed(topic));
      }
      _topicController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final otherTopics = _subscribedTopics
        .where((t) => !_suggestedTopics.contains(t))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscribeScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customTopicTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      hintText: l10n.customTopicHint,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _subscribeCustomTopic,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l10n.subscribe),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.suggestedTopics,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestedTopics.length,
              itemBuilder: (context, index) {
                final topic = _suggestedTopics[index];
                final isSubscribed = _subscribedTopics.contains(topic);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(topic),
                    trailing: Switch(
                      value: isSubscribed,
                      onChanged: (value) => _toggleSubscription(topic),
                    ),
                  ),
                );
              },
            ),
            if (otherTopics.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.otherTopics,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: otherTopics.length,
                  itemBuilder: (context, index) {
                    final topic = otherTopics[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(topic),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _toggleSubscription(topic),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
