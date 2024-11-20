import strutils, sequtils, os, json

type
  Priority = enum
    Low, Medium, High

  Task = object
    id: int
    description: string
    completed: bool
    priority: Priority

var tasks: seq[Task] = @[]
var nextId: int = 1
const filename = "tasks.json"

proc loadTasks() =
  if fileExists(filename):
    let jsonData = readFile(filename)
    tasks = parseJson(jsonData).to(seq[Task])
    nextId = tasks.len + 1

proc saveTasks() =
  let jsonData = tasks.toJson()
  writeFile(filename, jsonData)

proc addTask(description: string, priority: Priority) =
  let newTask = Task(id: nextId, description: description, completed: false, priority: priority)
  tasks.add(newTask)
  nextId += 1
  saveTasks()
  echo "Task added: ", newTask.description, " with priority ", priority

proc removeTask(id: int) =
  let index = tasks.findIt(Task(id: id, description: "", completed: false, priority: Low))
  if index.isNone:
    echo "Task with ID ", id, " not found."
  else:
    tasks.del(index.get)
    saveTasks()
    echo "Task with ID ", id, " removed."

proc toggleCompletion(id: int) =
  for task in tasks:
    if task.id == id:
      task.completed = not task.completed
      saveTasks()
      echo "Task ", id, " marked as ", if task.completed: "completed" else: "not completed"
      return
  echo "Task with ID ", id, " not found."

proc viewTasks() =
  if tasks.len == 0:
    echo "No tasks available."
  else:
    echo "Tasks:"
    for task in tasks:
      let status = if task.completed: "✓ Completed" else: "✗ Not Completed"
      echo "ID: ", task.id, " - Description: ", task.description, " - Status: ", status, " - Priority: ", task.priority

proc searchTasks(keyword: string) =
  let foundTasks = tasks.filterIt(it.description.contains(keyword))
  if foundTasks.len == 0:
    echo "No tasks found containing: ", keyword
  else:
    echo "Found Tasks:"
    for task in foundTasks:
      echo "ID: ", task.id, " - Description: ", task.description

proc showMenu() =
  echo """
  Task Manager
  1. Add Task
  2. View Tasks
  3. Remove Task
  4. Toggle Task Completion
  5. Search Tasks
  6. Exit
  """

proc main() =
  loadTasks()
  while true:
    showMenu()
    let choice = readLine("Choose an option: ")
    case choice:
    of "1":
      let description = readLine("Enter task description: ")
      let priorityInput = readLine("Enter task priority (low, medium, high): ").toLower()
      let priority = case priorityInput:
        of "low": Low
        of "medium": Medium
        of "high": High
        else: Low  # Default priority
      addTask(description, priority)
    of "2":
      viewTasks()
    of "3":
      let id = readLine("Enter task ID to remove: ").parseInt()
      removeTask(id)
    of "4":
      let id = readLine("Enter task ID to toggle completion: ").parseInt()
      toggleCompletion(id)
    of "5":
      let keyword = readLine("Enter keyword to search: ")
      searchTasks(keyword)
    of "6":
      echo "Exiting..."
      break
    else:
      echo " Invalid option, please try again."

main()
