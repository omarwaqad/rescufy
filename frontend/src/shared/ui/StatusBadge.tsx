interface StatusBadgeProps {
  status?: string;
  priority?: string;
}

// ─── Status → visual style ────────────────────────────────────────────────────
const statusStyles: Record<string, string> = {
  Pending:   "bg-yellow-100  text-yellow-800  dark:bg-yellow-900/40  dark:text-yellow-300",
  Assigned:  "bg-blue-100    text-blue-800    dark:bg-blue-900/40    dark:text-blue-300",
  Accepted:  "bg-sky-100     text-sky-800     dark:bg-sky-900/40     dark:text-sky-300",
  OnTheWay:  "bg-purple-100  text-purple-800  dark:bg-purple-900/40  dark:text-purple-300",
  Arrived:   "bg-indigo-100  text-indigo-800  dark:bg-indigo-900/40  dark:text-indigo-300",
  PickedUp:  "bg-orange-100  text-orange-800  dark:bg-orange-900/40  dark:text-orange-300",
  Delivered: "bg-teal-100    text-teal-800    dark:bg-teal-900/40    dark:text-teal-300",
  Finished:  "bg-green-100   text-green-800   dark:bg-green-900/40   dark:text-green-300",
  Canceled:  "bg-red-100     text-red-800     dark:bg-red-900/40     dark:text-red-300",
};

// ─── Status → human label ─────────────────────────────────────────────────────
const statusLabels: Record<string, string> = {
  Pending:   "Pending",
  Assigned:  "Assigned",
  Accepted:  "Accepted",
  OnTheWay:  "On The Way",
  Arrived:   "Arrived",
  PickedUp:  "Picked Up",
  Delivered: "Delivered",
  Finished:  "Finished",
  Canceled:  "Canceled",
};

// ─── Priority styles ──────────────────────────────────────────────────────────
const priorityStyles: Record<string, string> = {
  critical: "bg-red-600    text-white shadow-sm",
  high:     "bg-orange-500 text-white shadow-sm",
  medium:   "bg-amber-500  text-white shadow-sm",
  low:      "bg-blue-500   text-white shadow-sm",
};

const priorityLabels: Record<string, string> = {
  critical: "Critical",
  high:     "High",
  medium:   "Medium",
  low:      "Low",
};

// ─── Component ────────────────────────────────────────────────────────────────
export function StatusBadge({ status, priority }: StatusBadgeProps) {
  const base = "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold whitespace-nowrap";

  if (priority) {
    const p = priority.toLowerCase();
    const style = priorityStyles[p] || priorityStyles.medium;
    const label = priorityLabels[p] || priority;
    return (
      <span className={`${base} ${style}`}>
        {label}
      </span>
    );
  }

  const s = status ?? "Pending";
  const style = statusStyles[s] || statusStyles.Pending;
  const label = statusLabels[s] || s;
  
  return (
    <span className={`${base} ${style}`}>
      {label}
    </span>
  );
}
