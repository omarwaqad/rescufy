import axios from "axios";
import { API_CONFIG, getApiUrl } from "@/config/api.config";
import type { HospitalRequestItem } from "../types/request-ui.types";
import type { RequestPriority, RequestStatus } from "../types/request.types";

type AnyRecord = Record<string, unknown>;

type HospitalRequestApiItem = {
  id?: number | string;
  description?: string | null;
  address?: string | null;
  requestStatus?: string | number | null;
  createdAt?: string | null;
  patientName?: string | null;
  assignedAmbulancePlate?: string | null;
  priority?: string | null;
  userPhone?: string | null;
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

function normalizePriority(raw: HospitalRequestApiItem, status: RequestStatus): RequestPriority {
  const normalized = toStringValue(raw.priority).toLowerCase();

  if (
    normalized === "low" ||
    normalized === "medium" ||
    normalized === "high" ||
    normalized === "critical"
  ) {
    return normalized;
  }

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

  const language =
    typeof document !== "undefined" && document.documentElement.lang
      ? document.documentElement.lang
      : typeof navigator !== "undefined"
        ? navigator.language
        : "en";

  const elapsedMinutes = Math.max(0, Math.round((Date.now() - createdAt.getTime()) / 60000));

  if (elapsedMinutes < 1) {
    return language.startsWith("ar") ? "الآن" : "Just now";
  }

  if (elapsedMinutes < 60) {
    return new Intl.RelativeTimeFormat(language, { numeric: "auto" }).format(-elapsedMinutes, "minute");
  }

  const elapsedHours = Math.round(elapsedMinutes / 60);

  if (elapsedHours < 24) {
    return new Intl.RelativeTimeFormat(language, { numeric: "auto" }).format(-elapsedHours, "hour");
  }

  return new Intl.DateTimeFormat(language, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(createdAt);
}

export async function fetchHospitalRequestsApi(token: string): Promise<HospitalRequestApiItem[]> {
  const response = await axios.get(getApiUrl(API_CONFIG.ENDPOINTS.HOSPITALS.MY_REQUESTS), {
    headers: buildHeaders(token),
  });

  return extractArrayFromPayload<HospitalRequestApiItem>(response.data);
}

export function mapHospitalRequestItem(raw: HospitalRequestApiItem): HospitalRequestItem {
  const status = normalizeStatus(raw.requestStatus);

  return {
    id: raw.id == null ? "-" : String(raw.id),
    userName: toStringValue(raw.patientName) || "-",
    userPhone: toStringValue(raw.userPhone) || "-",
    location: toStringValue(raw.address) || "-",
    priority: normalizePriority(raw, status),
    status,
    timestamp: formatTimestamp(raw.createdAt),
  };
}