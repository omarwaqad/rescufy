export interface RequestTimeline {
  requestedAt: string | null;
  searchingAt: string | null;
  assignedAt: string | null;
  arrivedAt: string | null;
}

export interface Request {
  id: number;
  patientName: string | null;
  description: string | null;
  priority: string | null;
  location: string | null;
  condition: string | null;
  createdAt: string | null;
  status: string | null;
  ambulanceId: number | null;
  eta: number | null;
  timeline: RequestTimeline | null;
  isSearching: boolean;
  isAssigned: boolean;
  intervention: string | null;
}

