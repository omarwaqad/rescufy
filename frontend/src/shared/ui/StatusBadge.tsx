import type { RequestPriority, RequestStatus } from "@/features/requests/types/request.types";

interface StatusBadgeProps {
  status?: RequestStatus;
  priority?: RequestPriority;
}

// ─── Status → visual style ────────────────────────────────────────────────────
const statusStyles: Record<RequestStatus, string> = {
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
const statusLabels: Record<RequestStatus, string> = {
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
const priorityStyles: Record<RequestPriority, string> = {
  critical: "bg-red-600    text-white shadow-sm",
  high:     "bg-orange-500 text-white shadow-sm",
  medium:   "bg-amber-500  text-white shadow-sm",
  low:      "bg-blue-500   text-white shadow-sm",
};

const priorityLabels: Record<RequestPriority, string> = {
  critical: "Critical",
  high:     "High",
  medium:   "Medium",
  low:      "Low",
};

// ─── Component ────────────────────────────────────────────────────────────────
export function StatusBadge({ status, priority }: StatusBadgeProps) {
  const base = "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold whitespace-nowrap";

  if (priority) {
    return (
      <span className={`${base} ${priorityStyles[priority]}`}>
        {priorityLabels[priority]}
      </span>
    );
  }

  const resolvedStatus: RequestStatus = status ?? "Pending";
  return (
    <span className={`${base} ${statusStyles[resolvedStatus]}`}>
      {statusLabels[resolvedStatus]}
    </span>
  );
}
