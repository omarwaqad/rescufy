const TERMINAL_STATUSES = new Set([
  "completed",
  "canceled",
  "cancelled",
  "closed",
  "finished",
  "delivered",
  "failed",
]);

const FINISHED_STATUSES = new Set([
  "completed",
  "closed",
  "finished",
  "delivered",
]);

export function normalizeBoardStatus(status?: string | null): string {
  const normalized = status?.trim().toLowerCase() ?? "";

  if (FINISHED_STATUSES.has(normalized)) {
    return "COMPLETED";
  }

  if (normalized === "canceled" || normalized === "cancelled") {
    return "CANCELED";
  }

  if (normalized === "failed") {
    return "FAILED";
  }

  if (normalized === "waiting") {
    return "RECEIVED";
  }

  if (normalized === "searching") {
    return "SEARCHING";
  }

  if (normalized === "assigned") {
    return "ASSIGNED";
  }

  if (normalized === "enroute" || normalized === "arrived") {
    return "ARRIVING";
  }

  return status?.trim().toUpperCase() || "RECEIVED";
}

export function isTerminalRequestStatus(status?: string | null): boolean {
  return TERMINAL_STATUSES.has(status?.trim().toLowerCase() ?? "");
}

export function isFinishedRequestStatus(status?: string | null): boolean {
  return FINISHED_STATUSES.has(status?.trim().toLowerCase() ?? "");
}
