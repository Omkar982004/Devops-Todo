import TaskItem from "./TaskItem";

const TaskList = ({ tasks, onDelete }) => {
  return (
    <div className="space-y-2 max-h-[70vh] overflow-y-auto">
      {tasks.map((task) => (
        <TaskItem
          key={task._id}
          id={task._id}
          title={task.title}
          completed={task.completed}
          onDelete={onDelete}   // pass down delete function
        />
      ))}
    </div>
  );
};

export default TaskList;
