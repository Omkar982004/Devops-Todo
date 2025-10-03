import TaskList from './components/TaskList';
import './index.css';
import { useState, useEffect } from 'react';

export default function App() {

  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState("");
  const API_URL = import.meta.env.VITE_API_URL; // ✅ get from env
  console.log(API_URL);

  useEffect(()=>{
    const fetchTasks = async () => {
      try {
        const res = await fetch(`${API_URL}/tasks`);
        const data = await res.json();
        console.log(data);
        setTasks(data);
      } catch (err){
        console.error("Error fetching tasks:", err);
      }
    };

    fetchTasks();
  }, []);

  const handleAddTask = async (e) => {
    e.preventDefault();
    if (!newTask.trim()) return;

    try {
      const res = await fetch(`${API_URL}/tasks`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: newTask })
      });

      const createdTask = await res.json();

      // update UI immediately
      setTasks((prev) => [...prev, createdTask]);
      setNewTask("");  // clear input
    } catch (err) {
      console.error("Error adding task:", err);
    }
  };

  // inside App.jsx
const handleDelete = async (id) => {
  try {
    await fetch(`${API_URL}/tasks/${id}`, {
      method: "DELETE",
    });

    // update UI immediately
    setTasks((prev) => prev.filter((task) => task._id !== id));

  } catch (err) {
    console.error("Error deleting task:", err);
  }
};


  return (
    <div className="min-h-screen bg-gray-200 flex items-center justify-center p-4">
      <div className="w-full max-w-7xl min-h-[90vh] p-6 bg-white rounded-lg shadow">
        <h1 className="text-3xl font-bold text-center text-blue-600 mb-6">
          DevOps Todo App
        </h1>

        {/* Add Task Form */}
        <form className="flex mb-4" onSubmit={handleAddTask}>
          <input
            type="text"
            placeholder="New task"
            value={newTask}
            onChange={(e) => setNewTask(e.target.value)}
            className="flex-1 p-2 border rounded-l focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            type="submit"
            className="p-2 bg-blue-500 text-white rounded-r hover:bg-blue-600"
          >
            Add
          </button>
        </form>

        <TaskList tasks={tasks} onDelete={handleDelete}/>
      </div>
    </div>
  );
}
