import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import type { QueueRequestItem } from "../types/request-ui.types";

function getSeverityBorder(severity?: string | null) {
  const norm = severity?.toLowerCase();
  if (norm === "critical") return "border-red-500/35";
  if (norm === "high") return "border-orange-500/30";
  if (norm === "medium") return "border-amber-500/25";
  if (norm === "low") return "border-blue-500/25";
  if (norm === "normal") return "border-emerald-500/25";
  return "border-slate-500/25";
}

function getSeverityBadgeTheme(severity?: string | null) {
  const norm = severity?.toLowerCase();
  if (norm === "critical") return "border-red-300 bg-red-100 text-red-700 dark:border-red-500/40 dark:bg-red-500/14 dark:text-red-300";
  if (norm === "high") return "border-orange-300 bg-orange-100 text-orange-700 dark:border-orange-500/35 dark:bg-orange-500/14 dark:text-orange-300";
  if (norm === "medium") return "border-amber-300 bg-amber-100 text-amber-700 dark:border-amber-500/35 dark:bg-amber-500/14 dark:text-amber-300";
  if (norm === "low") return "border-blue-300 bg-blue-100 text-blue-700 dark:border-blue-500/35 dark:bg-blue-500/14 dark:text-blue-300";
  if (norm === "normal") return "border-emerald-300 bg-emerald-100 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/14 dark:text-emerald-300";
  return "border-slate-300 bg-slate-100 text-slate-700 dark:border-slate-500/35 dark:bg-slate-500/14 dark:text-slate-300";
}

function getDispatchTheme(dispatchState?: string | null) {
  const norm = dispatchState?.toUpperCase();

  if (norm === "SEARCHING") {
    return {
      badge:
        "border-amber-300 bg-amber-100 text-amber-700 dark:border-amber-500/35 dark:bg-amber-500/12 dark:text-amber-300",
      dot: "bg-amber-500",
    };
  }

  if (norm === "ASSIGNED") {
    return {
      badge:
        "border-emerald-300 bg-emerald-100 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/12 dark:text-emerald-300",
      dot: "bg-emerald-500",
    };
  }

  if (norm === "ARRIVING") {
    return {
      badge:
        "border-cyan-300 bg-cyan-100 text-cyan-700 dark:border-cyan-500/35 dark:bg-cyan-500/12 dark:text-cyan-300",
      dot: "bg-cyan-500",
    };
  }

  if (norm === "COMPLETED") {
    return {
      badge:
        "border-emerald-300 bg-emerald-100 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/12 dark:text-emerald-300",
      dot: "bg-emerald-500",
    };
  }

  if (norm === "FAILED") {
    return {
      badge:
        "border-red-300 bg-red-100 text-red-700 dark:border-red-500/35 dark:bg-red-500/12 dark:text-red-300",
      dot: "bg-red-500",
    };
  }

  return {
    badge:
      "border-slate-300 bg-slate-100 text-slate-700 dark:border-slate-500/35 dark:bg-slate-500/12 dark:text-slate-300",
    dot: "bg-slate-500 dark:bg-slate-400",
  };
}

export function useRequestDetailsPanelView(request: QueueRequestItem | null) {
  const { t } = useTranslation("requests");

  const view = useMemo(() => {
    if (!request) {
      return null;
    }
    
    const statusKey = request.status?.toUpperCase() ?? "RECEIVED";
    const priorityKey = request.priority?.toLowerCase() ?? "medium";

    const description =
      request.description?.trim() || t("board.item.descriptionFallback");

    const etaLabel =
      request.eta !== null
        ? t("board.item.etaMinutes", { count: request.eta })
        : t("board.item.etaUnknown");

    const selectedAmbulanceLabel =
      request.ambulanceId ? `AMB-${request.ambulanceId}` : t("board.item.searchingUnits");

    const dispatchStateLabel = t(
      `board.dispatchStateLabels.${statusKey}`,
    );

    return {
      severityBorder: getSeverityBorder(request.priority),
      severityBadgeTheme: getSeverityBadgeTheme(request.priority),
      dispatchTheme: getDispatchTheme(request.status),
      description,
      etaLabel,
      selectedAmbulanceLabel,
      dispatchStateLabel,
      priorityLabel: t(`priority.${priorityKey}`, request.priority ?? "Normal"),
      userName: request.patientName || "-",
      address: request.location || "-",
      waitingLabel: request.waitingLabel,
    };
  }, [request, t]);

  return {
    t,
    view,
  };
}
