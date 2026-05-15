import type { Dispatch, SetStateAction } from "react";
import type { Request } from "./request.types";

export type QueueRequestItem = Request & {
  waitingMinutes: number;
  waitingLabel: string;
};

export type RequestItemProps = {
  request: QueueRequestItem;
  isSelected: boolean;
  onSelect: () => void;
};

export type RequestListProps = {
  requests: QueueRequestItem[];
  selectedId: number | null;
  isLoading: boolean;
  onSelect: (requestId: number) => void;
};

export type RequestDetailsPanelProps = {
  request: QueueRequestItem | null;
  onViewDetails: () => void;
  onReassignAmbulance: (requestId: number) => void;
  onCancelAssignment: (requestId: number) => void;
};

export type HospitalRequestRowProps = {
  id?: string;
  userName?: string;
  userPhone?: number | string;
  location?: string;
  priority?: string;
  status?: string;
  timestamp?: string;
  compact?: boolean;
  basePath?: string;
};

export type RequestRowProps = {
  id?: string;
  userName?: string;
  userPhone?: string;
  address?: string;
  priority?: string;
  status?: string;
  timestamp?: string;
  compact?: boolean;
};

export type HospitalRequestItem = {
  id: string;
  userName: string;
  userPhone: string;
  location: string;
  priority: string;
  status: string;
  timestamp: string;
};

export type UseAllRequestsBoardParams = {
  requests: Request[];
  setRequests: Dispatch<SetStateAction<Request[]>>;
  fetchAdminStreamRequests: () => Promise<Request[]>;
};
