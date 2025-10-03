const TaskItem = ({ id, title, completed, onDelete }) => {
  return (
    <div className="flex items-center justify-between p-2 border rounded">
      <span className={completed ? "line-through text-gray-500" : ""}>
        {title}
      </span>
      <button
        onClick={() => onDelete(id)}
        className="ml-4 px-2 py-1 bg-red-500 text-white rounded hover:bg-red-600"
      >
        Delete
      </button>
    </div>
  );
};

export default TaskItem;
