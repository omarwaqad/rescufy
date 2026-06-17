import axios from "axios";
import { API_CONFIG, getApiUrl } from "@/config/api.config";
import type { Request } from "../types/request.types";

const PAYLOAD_KEYS = ["data", "result", "items", "requests", "value"];

type AnyRecord = Record<string, unknown>;

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    page: number;
    limit: number;
    totalPages: number;
    totalItems: number;
  };
}

function extractMessageFromPayload(payload: unknown): string {
  if (typeof payload === "string") return payload;
  if (!payload || typeof payload !== "object") return "";

  const root = payload as AnyRecord;
  if (typeof root.message === "string") return root.message;

  for (const key of PAYLOAD_KEYS) {
    const value = root[key];
    if (!value || typeof value !== "object") continue;
    const nested = value as AnyRecord;
    if (typeof nested.message === "string") return nested.message;
  }

  return "";
}

function extractArrayFromPayload<T>(payload: unknown): T[] {
  if (Array.isArray(payload)) return payload as T[];
  if (!payload || typeof payload !== "object") return [];

  const root = payload as AnyRecord;
  for (const key of PAYLOAD_KEYS) {
    const value = root[key];
    if (Array.isArray(value)) return value as T[];
    if (!value || typeof value !== "object") continue;
    const nested = value as AnyRecord;
    for (const nestedKey of PAYLOAD_KEYS) {
      const nestedValue = nested[nestedKey];
      if (Array.isArray(nestedValue)) return nestedValue as T[];
    }
  }

  return [];
}

function extractPaginatedResponse<T>(payload: unknown): PaginatedResponse<T> {
  const data = extractArrayFromPayload<T>(payload);
  const root = payload as AnyRecord;
  const rawMeta = root && typeof root === "object" ? root.meta as AnyRecord : null;
  
  return {
    data,
    meta: {
      page: Number(rawMeta?.page) || 1,
      limit: Number(rawMeta?.limit) || 20,
      totalPages: Number(rawMeta?.totalPages) || 1,
      totalItems: Number(rawMeta?.totalItems) || data.length,
    }
  };
}

function buildHeaders(token?: string) {
  const base: Record<string, string> = { "Content-Type": "application/json" };
  if (token) base.Authorization = `Bearer ${token}`;
  return base;
}

const RequestsApi = {
  async fetchAll(token?: string): Promise<Request[]> {
    const { data } = await axios.get(
      getApiUrl(API_CONFIG.ENDPOINTS.REQUESTS.GET_ALL),
      {
        headers: buildHeaders(token),
      },
    );

    return extractArrayFromPayload<Request>(data);
  },

  async fetchAdminStream(token?: string, params?: Record<string, string | number | boolean>): Promise<PaginatedResponse<Request>> {
    const { data } = await axios.get(
      getApiUrl(API_CONFIG.ENDPOINTS.REQUESTS.GET_ADMIN_STREAM),
      {
        headers: buildHeaders(token),
        params,
      },
    );

    return extractPaginatedResponse<Request>(data);
  },

  async fetchEvents(token: string | undefined, requestId: string, params?: Record<string, string | number>): Promise<PaginatedResponse<any>> {
    const { data } = await axios.get(
      getApiUrl(`/api/request/${requestId}/events`),
      {
        headers: buildHeaders(token),
        params,
      },
    );

    return extractPaginatedResponse<any>(data);
  },

  async cancel(token: string | undefined, requestId: number): Promise<string> {
    const endpoint = API_CONFIG.ENDPOINTS.REQUESTS.CANCEL_REQUEST(
      String(requestId),
    );

    try {
      const { data } = await axios.put(
        getApiUrl(endpoint),
        {},
        { headers: buildHeaders(token) },
      );
      return extractMessageFromPayload(data);
    } catch (error: any) {
      if (error?.response?.status !== 405) throw error;
      const { data } = await axios.post(
        getApiUrl(endpoint),
        {},
        { headers: buildHeaders(token) },
      );
      return extractMessageFromPayload(data);
    }
  },
};

export default RequestsApi;

// Backwards-compatible named exports (simple wrappers)
export const fetchRequestsApi = (token?: string) => RequestsApi.fetchAll(token);
export const fetchAdminStreamApi = (token?: string, params?: Record<string, string | number | boolean>) =>
  RequestsApi.fetchAdminStream(token, params);
export const fetchRequestEventsApi = (token: string | undefined, requestId: string, params?: Record<string, string | number>) => 
  RequestsApi.fetchEvents(token, requestId, params);
export const cancelRequestApi = (
  token: string | undefined,
  requestId: number,
) => RequestsApi.cancel(token, requestId);
