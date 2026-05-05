export function getWaitingMinutes(createdAt: string | Date | number): number {
  if (!createdAt) {
    return 0;
  }

  const time = new Date(createdAt).getTime();

  if (Number.isNaN(time)) {
    return 0;
  }

  const now = Date.now();
  return Math.max(0, Math.floor((now - time) / 60000));
}

export function formatWaitingTime(createdAt: string | Date | number): string {
  const mins = getWaitingMinutes(createdAt);
  if (mins < 1) return "< 1m";
  if (mins <= 60) return `${mins}m`;
  return "60m+";
}
