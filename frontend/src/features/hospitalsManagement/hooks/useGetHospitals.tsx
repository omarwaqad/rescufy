import axios from "axios";
import { useCallback, useRef, useState } from "react";
import { toast } from "sonner";
import { useTranslation } from "react-i18next";
import { getApiUrl, API_CONFIG } from "@/config/api.config";
import type { Hospital } from "../types/hospitals.types";
import { useLanguage } from "@/i18n/useLanguage";
import { getAuthToken } from "@/features/auth/utils/auth.utils";
import {
  extractHospitalCollection,
  getApiErrorMessage,
  hasPaginatedResponse,
  normalizeHospital,
} from "../utils/hospital.api.ts";

export type HospitalFetchParams = {
  page?: number;
  limit?: number;
};

export type HospitalFetchResult = {
  hospitals: Hospital[];
  usesServerPagination: boolean;
  totalPages: number;
  totalItems: number;
};

/**
 * Hook for fetching hospitals from the API
 */
export function useGetHospitals() {
  const [isLoading, setIsLoading] = useState(false);
  const fetchInFlightRef = useRef(false);
  const { t } = useTranslation(["hospitals", "auth"]);
  const { isRTL } = useLanguage();

  const fetchHospitals = useCallback(
    async (params: HospitalFetchParams = {}): Promise<HospitalFetchResult> => {
      if (fetchInFlightRef.current) {
        return {
          hospitals: [],
          usesServerPagination: false,
          totalPages: 1,
          totalItems: 0,
        };
      }

      fetchInFlightRef.current = true;
      setIsLoading(true);
      const toastPosition = isRTL ? "top-left" : "top-right";
      const toastId = "hospitals-fetch-error";

      try {
        const token = getAuthToken();

        if (!token) {
          toast.error(t("auth:signIn.tokenNotFound"), {
            position: toastPosition,
            id: toastId,
          });
          return {
            hospitals: [],
            usesServerPagination: false,
            totalPages: 1,
            totalItems: 0,
          };
        }

        const queryParams: Record<string, number> = {};
        if (params.page) {
          queryParams.page = params.page;
        }
        if (params.limit) {
          queryParams.limit = params.limit;
        }

        const response = await axios.get(
          getApiUrl(API_CONFIG.ENDPOINTS.HOSPITALS.GET_ALL),
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${token}`,
            },
            params: Object.keys(queryParams).length > 0 ? queryParams : undefined,
          },
        );

        const fetchedHospitals = extractHospitalCollection(response.data)
          .map(normalizeHospital)
          .filter((item): item is Hospital => item !== null);

        const usesServerPagination = hasPaginatedResponse(response.data);

        if (usesServerPagination) {
          const meta = (response.data as { meta: Record<string, number> }).meta;
          const limit = Number(meta.limit) || params.limit || 20;
          const totalItems = Number(meta.totalItems) || fetchedHospitals.length;
          const totalPages = Number(meta.totalPages) || Math.max(1, Math.ceil(totalItems / limit));

          return {
            hospitals: fetchedHospitals,
            usesServerPagination: true,
            totalPages,
            totalItems,
          };
        }

        return {
          hospitals: fetchedHospitals,
          usesServerPagination: false,
          totalPages: 1,
          totalItems: fetchedHospitals.length,
        };
      } catch (error: unknown) {
        console.error("Fetch hospitals error:", error);

        if (axios.isAxiosError(error) && error.response?.status === 401) {
          toast.error(t("auth:signIn.unauthorized"), {
            position: toastPosition,
            id: toastId,
          });
        } else if (axios.isAxiosError(error) && error.message === "Network Error") {
          toast.error(t("auth:signIn.networkError"), {
            position: toastPosition,
            id: toastId,
          });
        } else {
          toast.error(getApiErrorMessage(error) ?? t("hospitals:api.fetchError"), {
            position: toastPosition,
            id: toastId,
          });
        }

        return {
          hospitals: [],
          usesServerPagination: false,
          totalPages: 1,
          totalItems: 0,
        };
      } finally {
        fetchInFlightRef.current = false;
        setIsLoading(false);
      }
    },
    [isRTL, t],
  );

  return { isLoading, fetchHospitals };
}
