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
  address?: string | null;
  priority: string | null;
  location: string | null;
  condition: string | null;
  createdAt: string | null;
  requestStatus?: string | null;
  status: string | null;
  assignedAmbulancePlate?: string | null;
  ambulanceId: number | null;
  eta: number | null;
  timeline: RequestTimeline | null;
  isSearching: boolean;
  isAssigned: boolean;
  intervention: string | null;
}

