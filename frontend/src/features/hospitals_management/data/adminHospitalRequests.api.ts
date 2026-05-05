import axios from "axios";
import { API_CONFIG, getApiUrl } from "@/config/api.config";
import type { HospitalRequestItem } from "@/features/requests/types/request-ui.types";
import type { RequestPriority, RequestStatus } from "@/features/requests/types/request.types";

type AnyRecord = Record<string, unknown>;

type HospitalRequestApiItem = {
  id?: number | string;
  description?: string | null;
  address?: string | null;
  requestStatus?: string | number | null;
  createdAt?: string | null;
  patientName?: string | null;
  assignedAmbulancePlate?: string | null;
};

const PAYLOAD_KEYS = ["data", "result", "items", "requests", "value"];

function buildHeaders(token: string) {
  return {
    "Content-Type": "application/json",
    Authorization: `Bearer ${token}`,
  };
}

function extractArrayFromPayload<T>(payload: unknown): T[] {
  if (Array.isArray(payload)) {
    return payload as T[];
  }

  if (!payload || typeof payload !== "object") {
    return [];
  }

  const root = payload as AnyRecord;

  for (const key of PAYLOAD_KEYS) {
    const value = root[key];

    if (Array.isArray(value)) {
      return value as T[];
    }

    if (!value || typeof value !== "object") {
      continue;
    }

    const nested = value as AnyRecord;

    for (const nestedKey of PAYLOAD_KEYS) {
      const nestedValue = nested[nestedKey];

      if (Array.isArray(nestedValue)) {
        return nestedValue as T[];
      }
    }
  }

  return [];
}

function toStringValue(value: unknown): string {
  if (typeof value === "string") {
    return value.trim();
  }

  if (typeof value === "number" && Number.isFinite(value)) {
    return String(value);
  }

  return "";
}

function normalizeStatus(value: unknown): RequestStatus {
  if (typeof value === "number") {
    const map: Record<number, RequestStatus> = {
      0: "Pending",
      1: "Assigned",
      2: "Accepted",
      3: "OnTheWay",
      4: "Arrived",
      5: "PickedUp",
      6: "Delivered",
      7: "Finished",
      8: "Canceled",
    };
    return map[value] ?? "Pending";
  }

  const s = toStringValue(value);
  const valid: RequestStatus[] = [
    "Pending", "Assigned", "Accepted", "OnTheWay",
    "Arrived", "PickedUp", "Delivered", "Finished", "Canceled",
  ];

  // exact match (case-sensitive, as API sends PascalCase)
  if (valid.includes(s as RequestStatus)) return s as RequestStatus;

  // case-insensitive fallback
  const lower = s.toLowerCase().replace(/[^a-z]/g, "");
  if (lower === "ontheway") return "OnTheWay";
  if (lower === "pickedup") return "PickedUp";
  if (lower === "finished") return "Finished";
  if (lower === "delivered") return "Delivered";
  if (lower === "arrived") return "Arrived";
  if (lower === "accepted") return "Accepted";
  if (lower === "assigned") return "Assigned";
  if (lower === "canceled" || lower === "cancelled") return "Canceled";

  return "Pending";
}

function normalizePriority(status: RequestStatus): RequestPriority {
  if (status === "Canceled") return "critical";
  if (status === "OnTheWay" || status === "Arrived" || status === "PickedUp") return "high";
  if (status === "Finished" || status === "Delivered") return "low";
  if (status === "Assigned" || status === "Accepted") return "medium";
  return "medium";
}

function formatTimestamp(value: unknown): string {
  const raw = toStringValue(value);

  if (!raw) {
    return "-";
  }

  const createdAt = new Date(raw);

  if (Number.isNaN(createdAt.getTime())) {
    return raw;
  }

  return createdAt.toLocaleString(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  });
}

export async function fetchHospitalActiveRequestsApi(
  token: string,
  hospitalId: string,
): Promise<HospitalRequestApiItem[]> {
  const response = await axios.get(
    getApiUrl(API_CONFIG.ENDPOINTS.HOSPITALS.ACTIVE_REQUESTS(Number(hospitalId))),
    { headers: buildHeaders(token) },
  );

  return extractArrayFromPayload<HospitalRequestApiItem>(response.data);
}

export async function fetchHospitalRequestsApi(
  token: string,
  hospitalId: string,
): Promise<HospitalRequestApiItem[]> {
  const response = await axios.get(
    getApiUrl(API_CONFIG.ENDPOINTS.HOSPITALS.GET_REQUESTS(hospitalId)),
    { headers: buildHeaders(token) },
  );

  return extractArrayFromPayload<HospitalRequestApiItem>(response.data);
}

export async function fetchHospitalWeeklyStatsApi(
  token: string,
  hospitalId: string,
): Promise<Record<string, unknown> | null> {
  const response = await axios.get(
    getApiUrl(API_CONFIG.ENDPOINTS.HOSPITALS.WEEKLY_STATS(hospitalId)),
    { headers: buildHeaders(token) },
  );

  const payload = response.data;

  if (payload && typeof payload === "object") {
    // If the response is an array, take the first object
    if (Array.isArray(payload)) {
      return (payload[0] as Record<string, unknown>) || null;
    }

    const p = payload as Record<string, unknown>;

    // If there's a nested array under common keys, take its first element
    for (const key of ["data", "result", "items", "value"]) {
      if (Array.isArray(p[key])) {
        return (p[key] as Record<string, unknown>[])[0] || null;
      }
    }

    // If there's a nested object under common keys, use it
    for (const key of ["data", "result", "value"]) {
      if (p[key] && typeof p[key] === "object" && !Array.isArray(p[key])) {
        return p[key] as Record<string, unknown>;
      }
    }

    // Otherwise, return the payload as-is
    return p;
  }

  return null;
}

export function mapHospitalRequestItem(raw: HospitalRequestApiItem): HospitalRequestItem {
  const status = normalizeStatus(raw.requestStatus);

  return {
    id: raw.id == null ? "-" : String(raw.id),
    userName: toStringValue(raw.patientName) || "-",
    userPhone: toStringValue(raw.assignedAmbulancePlate) || "-",
    location: toStringValue(raw.address) || "-",
    priority: normalizePriority(status),
    status,
    timestamp: formatTimestamp(raw.createdAt),
  };
}
