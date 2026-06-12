import { useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import type { DispatchActivityEvent } from "../components/DispatchActivityFeed";
import type { DashboardAlert } from "../components/AlertsPanel";
import type { SystemHealthStatus } from "../components/SystemHealthSection";
import axios from "axios";
import { getApiUrl } from "@/config/api.config";
import { getAuthToken } from "@/features/auth/utils/auth.utils";
import { startDispatchConnection, onReceiveRequestEvent, onReceiveAlert } from "@/services/signalrService";

export function useDashboardOverviewData() {
  const { t } = useTranslation("dashboard");

  const [avgDispatchMinutes, setAvgDispatchMinutes] = useState(4.1);
  const [successRate, setSuccessRate] = useState(93.6);
  const [failedAssignments, setFailedAssignments] = useState(6);
  const [availableAmbulances, setAvailableAmbulances] = useState(23);
  const [totalAmbulances, setTotalAmbulances] = useState(45);

  const [activityEvents, setActivityEvents] = useState<DispatchActivityEvent[]>([]);
  const [alerts, setAlerts] = useState<DashboardAlert[]>([]);
  const [isRealtimeConnected, setIsRealtimeConnected] = useState(false);
  const [realtimeError, setRealtimeError] = useState<string | null>(null);

  const healthStatus: SystemHealthStatus =
    failedAssignments >= 10 || avgDispatchMinutes > 6
      ? "critical"
      : failedAssignments >= 5 || avgDispatchMinutes > 4.5 || successRate < 92
        ? "warning"
        : "healthy";

  useEffect(() => {
    // Initial fetch for historical data
    const fetchHistoricalData = async () => {
      try {
        const token = getAuthToken();
        const headers = token ? { Authorization: `Bearer ${token}` } : {};
        
        // Fetch recent alerts
        const alertsResponse = await axios.get(getApiUrl("/api/alert"), { headers, params: { page: 1, limit: 10 } });
        const fetchedAlerts: DashboardAlert[] = (alertsResponse.data?.data || []).map((alert: any) => ({
          id: alert.alertId || alert.id,
          severity: alert.level || alert.severity || "info",
          title: alert.title || "",
          description: alert.message || alert.description || "",
          zone: alert.zone || "Unknown",
          minutesAgo: alert.timestamp ? Math.max(0, Math.floor((new Date().getTime() - new Date(alert.timestamp).getTime()) / 60000)) : 0,
          recommendation: alert.recommendation || "",
        }));
        setAlerts(fetchedAlerts);
        
      } catch (error) {
        console.error("Failed to fetch dashboard data", error);
      }
    };
    
    void fetchHistoricalData();

    // SignalR Real-time updates
    let cleanupEvents: (() => void) | undefined;
    let cleanupAlerts: (() => void) | undefined;

    const setupSignalR = async () => {
      try {
        const { connection, error } = await startDispatchConnection();

        if (!connection) {
          setIsRealtimeConnected(false);
          setRealtimeError(error ?? t("realtime.connectionFailed"));
          return;
        }

        setIsRealtimeConnected(true);
        setRealtimeError(null);

        cleanupEvents = onReceiveRequestEvent((event: any) => {
        const newEvent: DispatchActivityEvent = {
          id: event.eventId || Math.random().toString(),
          requestId: event.requestId,
          patientName: event.patientName || "Patient",
          type: event.eventType || "requestReceived", 
          minutesAgo: 0,
          ambulanceName: event.ambulanceId,
          etaMinutes: event.etaMinutes,
        };
        setActivityEvents(prev => [newEvent, ...prev].slice(0, 50));
      });

      cleanupAlerts = onReceiveAlert((alert: any) => {
        const newAlert: DashboardAlert = {
          id: alert.alertId || Math.random().toString(),
          severity: alert.level?.toLowerCase() || "info",
          title: alert.title || "",
          description: alert.message || "",
          zone: alert.zone || "Unknown",
          minutesAgo: 0,
          recommendation: alert.recommendation || "",
        };
        setAlerts(prev => [newAlert, ...prev].slice(0, 50));
      });
      } catch (error) {
        console.warn("Dispatch SignalR setup failed:", error);
        setIsRealtimeConnected(false);
        setRealtimeError(t("realtime.connectionFailed"));
      }
    };

    void setupSignalR();

    return () => {
      if (cleanupEvents) cleanupEvents();
      if (cleanupAlerts) cleanupAlerts();
    };
  }, [t]);

  return {
    avgDispatchMinutes,
    successRate,
    failedAssignments,
    availableAmbulances,
    totalAmbulances,
    healthStatus,
    activityEvents,
    alerts,
    isRealtimeConnected,
    realtimeError,
  };
}
