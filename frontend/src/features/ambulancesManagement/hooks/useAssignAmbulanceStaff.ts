import { useState } from "react";
import axios from "axios";
import { toast } from "sonner";
import { useTranslation } from "react-i18next";
import { getApiUrl, API_CONFIG } from "@/config/api.config";
import { getAuthToken } from "@/features/auth/utils/auth.utils";

type AssignStaffPayload = {
  driverId?: string;
  paramedicId?: string;
};

export function useAssignAmbulanceStaff() {
  const [isAssigning, setIsAssigning] = useState(false);
  const { t } = useTranslation("ambulances");

  const assignStaff = async (ambulanceId: string, payload: AssignStaffPayload) => {
    setIsAssigning(true);
    try {
      const token = getAuthToken();
      if (!token) {
        toast.error("Authentication required");
        return false;
      }

      // We expect query params
      const url = new URL(getApiUrl(API_CONFIG.ENDPOINTS.AMBULANCES.ASSIGN_STAFF(ambulanceId)));
      if (payload.driverId) {
        url.searchParams.append("driverId", payload.driverId);
      }
      if (payload.paramedicId) {
        url.searchParams.append("paramedicId", payload.paramedicId);
      }

      await axios.post(
        url.toString(),
        {},
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      toast.success(t("staff.assignedSuccessfully", "Staff assigned successfully"));
      return true;
    } catch (error: any) {
      console.error("Assign staff error:", error);
      const msg = error.response?.data?.message || t("staff.assignFailed", "Failed to assign staff");
      toast.error(msg);
      return false;
    } finally {
      setIsAssigning(false);
    }
  };

  return { assignStaff, isAssigning };
}
