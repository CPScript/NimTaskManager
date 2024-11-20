```
git clone https://github.com/CPScript/NimTaskManager
cd NimTaskManager
nim c -d:nodebug task_manager.nim
./task_manager
```

* Add Task: Choose option 1 from the menu, enter the task description, and specify the priority (low, medium, high).
* View Tasks: Choose option 2 to see a list of all tasks, including their ID, description, completion status, and priority.
* Remove Task: Choose option 3 and enter the ID of the task you want to remove.
* Toggle Task Completion: Choose option 4 and enter the ID of the task to mark it as completed or not completed.
* Search Tasks: Choose option 5 and enter a keyword to find tasks that contain that keyword in their description.
* Exit: Choose option 6 to exit the application.
