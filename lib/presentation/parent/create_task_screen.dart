import 'package:flutter/material.dart';
import 'package:neuronavi/data/models/task_model.dart';
import 'package:neuronavi/data/providers/auth_provider.dart';
import 'package:neuronavi/data/providers/task_provider.dart';
import 'package:neuronavi/data/services/ai_service.dart';
import 'package:neuronavi/presentation/common/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _aiService = AiService();
  bool _isLoading = false;
  List<String> _subtasks = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _breakdownTask() async {
    if (_titleController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _subtasks = [];
    });

    final subtasks = await _aiService.breakdownTask(_titleController.text);

    setState(() {
      _subtasks = subtasks;
      _isLoading = false;
    });
  }

  void _createTask() async {
    if (_formKey.currentState!.validate() && _subtasks.isNotEmpty) {
      setState(() => _isLoading = true);
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if(authProvider.userModel?.linkedAccountId == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No linked child account found.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final newTask = TaskModel(
        id: '', // Firestore will generate
        title: _titleController.text.trim(),
        parentId: authProvider.userModel!.uid,
        childId: authProvider.userModel!.linkedAccountId!,
        createdAt: DateTime.now(),
        subtasks: _subtasks
            .map((title) => Subtask(id: const Uuid().v4(), title: title))
            .toList(),
      );

      await taskProvider.addTask(newTask);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate subtasks before creating.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter a high-level goal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'e.g., "Clean your bedroom"',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Break Down with AI',
                onPressed: _breakdownTask,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Generated Subtasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (_isLoading && _subtasks.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (_subtasks.isEmpty)
                const Center(child: Text('Subtasks will appear here.'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(_subtasks[index]),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Create Task',
                isLoading: _isLoading,
                onPressed: _createTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}