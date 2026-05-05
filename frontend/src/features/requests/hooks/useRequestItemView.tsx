import {
  AlertTriangle,
  CheckCircle2,
  Loader2,
  Radar,
} from "lucide-react";
import { useTranslation } from "react-i18next";
import type { QueueRequestItem } from "../types/request-ui.types";

const STATE_ORDER = [
  "RECEIVED",
  "SEARCHING",
  "ASSIGNED",
  "ARRIVING",
];

function getSeverityTheme(severity?: string | null) {
  const norm = severity?.toLowerCase();

  if (norm === "critical") {
    return {
      accent: "bg-red-500",
      badge:
        "border-red-300 bg-red-100 text-red-700 dark:border-red-500/45 dark:bg-red-500/18 dark:text-red-300",
      waiting: "text-red-700 dark:text-red-300",
      row: "hover:bg-red-100/80 dark:hover:bg-red-500/8",
    };
  }

  if (norm === "high") {
    return {
      accent: "bg-orange-500",
      badge:
        "border-orange-300 bg-orange-100 text-orange-700 dark:border-orange-500/40 dark:bg-orange-500/18 dark:text-orange-300",
      waiting: "text-orange-700 dark:text-orange-300",
      row: "hover:bg-orange-100/80 dark:hover:bg-orange-500/8",
    };
  }

  if (norm === "medium") {
    return {
      accent: "bg-amber-500",
      badge:
        "border-amber-300 bg-amber-100 text-amber-700 dark:border-amber-500/35 dark:bg-amber-500/18 dark:text-amber-300",
      waiting: "text-amber-700 dark:text-amber-300",
      row: "hover:bg-amber-100/80 dark:hover:bg-amber-500/8",
    };
  }

  if (norm === "low") {
    return {
      accent: "bg-blue-500",
      badge:
        "border-blue-300 bg-blue-100 text-blue-700 dark:border-blue-500/35 dark:bg-blue-500/16 dark:text-blue-300",
      waiting: "text-blue-700 dark:text-blue-300",
      row: "hover:bg-blue-100/80 dark:hover:bg-blue-500/8",
    };
  }

  if (norm === "normal") {
    return {
      accent: "bg-emerald-500",
      badge:
        "border-emerald-300 bg-emerald-100 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/16 dark:text-emerald-300",
      waiting: "text-emerald-700 dark:text-emerald-300",
      row: "hover:bg-emerald-100/80 dark:hover:bg-emerald-500/8",
    };
  }

  return {
    accent: "bg-slate-500",
    badge:
      "border-slate-300 bg-slate-100 text-slate-700 dark:border-slate-500/35 dark:bg-slate-500/16 dark:text-slate-300",
    waiting: "text-slate-700 dark:text-slate-300",
    row: "hover:bg-slate-100/80 dark:hover:bg-slate-500/8",
  };
}

function getDispatchTheme(dispatchState?: string | null) {
  const norm = dispatchState?.toUpperCase();

  if (norm === "SEARCHING") {
    return {
      badge:
        "border-amber-300 bg-amber-100 text-amber-700 dark:border-amber-500/35 dark:bg-amber-500/12 dark:text-amber-300",
      dot: "bg-amber-500",
      row: "ring-1 ring-amber-300/80 dark:ring-amber-500/20",
    };
  }

  if (norm === "ASSIGNED") {
    return {
      badge:
        "border-emerald-300 bg-emerald-100 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/12 dark:text-emerald-300",
      dot: "bg-emerald-500",
      row: "",
    };
  }

  if (norm === "ARRIVING") {
    return {
      badge:
        "border-cyan-300 bg-cyan-100 text-cyan-700 dark:border-cyan-500/35 dark:bg-cyan-500/12 dark:text-cyan-300",
      dot: "bg-cyan-500",
      row: "",
    };
  }

  if (norm === "COMPLETED") {
    return {
      badge:
        "border-emerald-300 bg-emerald-100 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/12 dark:text-emerald-300",
      dot: "bg-emerald-500",
      row: "",
    };
  }

  if (norm === "FAILED") {
    return {
      badge:
        "border-red-300 bg-red-100 text-red-700 dark:border-red-500/35 dark:bg-red-500/12 dark:text-red-300",
      dot: "bg-red-500",
      row: "ring-1 ring-red-300/80 dark:ring-red-500/25",
    };
  }

  return {
    badge:
      "border-slate-300 bg-slate-100 text-slate-700 dark:border-slate-500/35 dark:bg-slate-500/12 dark:text-slate-300",
    dot: "bg-slate-500 dark:bg-slate-400",
    row: "",
  };
}

function formatTimelineTime(timestamp: string) {
  const date = new Date(timestamp);

  if (Number.isNaN(date.getTime())) {
    return "--:--";
  }

  return date.toLocaleTimeString([], {
    hour: "2-digit",
    minute: "2-digit",
  });
}

export function useRequestItemView(request: QueueRequestItem) {
  const { t } = useTranslation("requests");
  const statusKey = request.status?.toUpperCase() ?? "RECEIVED";
  const priorityKey = request.priority?.toLowerCase() ?? "normal";

  const theme = getSeverityTheme(request.priority);
  const dispatchTheme = getDispatchTheme(request.status);

  const previewDescription =
    request.description?.trim() || t("board.item.descriptionFallback");

  const statusLabel = t(`board.dispatchStateLabels.${statusKey}`);

  const etaLabel =
    request.eta !== null
      ? t("board.item.etaMinutes", { count: request.eta })
      : t("board.item.etaUnknown");

  const assignedAmbulanceLabel =
    request.ambulanceId ? `AMB-${request.ambulanceId}` : t("board.item.searchingUnits");
  const priorityLabel = t(`priority.${priorityKey}`, request.priority ?? "Normal");

  const timelineMap = {
    RECEIVED: request.timeline?.requestedAt ?? "",
    SEARCHING: request.timeline?.searchingAt ?? "",
    ASSIGNED: request.timeline?.assignedAt ?? "",
    ARRIVING: request.timeline?.arrivedAt ?? "",
  };

  const timelineEntries = STATE_ORDER.map((state) => {
    const logTimestamp = timelineMap[state as keyof typeof timelineMap];

    return {
      key: state,
      label: t(`board.timeline.${state}`),
      time: logTimestamp ? formatTimelineTime(logTimestamp) : "--:--",
      reached: Boolean(logTimestamp),
      active: statusKey === state,
    };
  });

  const statusIcon =
    request.isSearching ? (
      <Loader2 className="h-3.5 w-3.5 animate-spin" />
    ) : request.status?.toLowerCase() === "failed" ? (
      <AlertTriangle className="h-3.5 w-3.5" />
    ) : request.status?.toLowerCase() === "completed" ? (
      <CheckCircle2 className="h-3.5 w-3.5" />
    ) : (
      <Radar className="h-3.5 w-3.5" />
    );

  return {
    t,
    theme,
    dispatchTheme,
    previewDescription,
    statusLabel,
    etaLabel,
    assignedAmbulanceLabel,
    priorityLabel,
    timelineEntries,
    statusIcon,
    isFailed: request.status?.toLowerCase() === "failed",
  };
}
