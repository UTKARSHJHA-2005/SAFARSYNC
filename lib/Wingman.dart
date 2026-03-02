import 'package:flutter/material.dart';
import 'package:safarsync/components/chatgrad.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Hello 👋 How can I help you?", "isUser": false},
  ];

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({"text": _controller.text, "isUser": true});

      // Fake AI reply
      messages.add({"text": "This is AI response 🤖", "isUser": false});
    });

    _controller.clear();
  }

    const [isGenerating, setIsGenerating] = useState(false);// Generation of AI State


  const GenerateAI = async () => {
    if (!formData.content.trim()) {
      toast.info("Ask what you want");
      return;
    }
    setIsGenerating(true);
    try {
      const res = await axios.post(
        "https://192.168.1.3:3000/generate",
        {
          prompt: formData.content,
          userId: user?.id || user?.email
        },
        {
          headers: {
            "Content-Type": "application/json"
          }
        }
      );

      if (res.data.success) {
        handleChange("content", res.data.content);
      } else {
        toast.error(res.data.error || "AI generation failed");
      }
    } catch (error) {
      console.error("AI Generate Error:", error);
      toast.error("Failed to generate content. Please try again later.");
    } finally {
      setIsGenerating(false);
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// Chat Messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message["isUser"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: message["isUser"]
                              ? Colors.blue
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message["text"],
                          style: TextStyle(
                            color: message["isUser"]
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Input Field
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: sendMessage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
