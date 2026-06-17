import { ShieldAlert, Filter, X } from "lucide-react";
import { useMemo, useState } from "react";
import { useNavigate } from "react-router";
import { useMediaQuery } from "@/shared/hooks/useMediaQuery";
import SelectField from "@/shared/ui/SelectField";
import { useAllRequestsPage } from "../hooks/useAllRequestsPage";
import { RequestList } from "./RequestList";
import { RequestDetailsPanel } from "./RequestDetailsPanel";

const FILTER_TRIGGER_CLASS = "h-9 text-xs";

export default function AllRequests() {
  const navigate = useNavigate();
  const isMobile = useMediaQuery("(max-width: 1279px)");
  const [showFilters, setShowFilters] = useState(false);

  const {
    t,
    requests,
    isLoading,
    selectedId,
    boardRequests,
    selectedRequest,
    criticalCount,
    failedCount,
    searchingCount,
    assignedCount,
    queueTone,
    systemState,
    handleReassignAmbulance,
    handleCancelAssignment,
    handleSelectRequest,
    handleViewRequestDetails,
    page,
    totalPages,
    setPage,
    filters,
    setFilters,
  } = useAllRequestsPage();

  const severityOptions = useMemo(
    () => [
      { label: t("board.filters.all"), value: "all" },
      { label: t("board.filters.severity.critical"), value: "critical" },
      { label: t("board.filters.severity.high"), value: "high" },
      { label: t("board.filters.severity.medium"), value: "medium" },
      { label: t("board.filters.severity.low"), value: "low" },
    ],
    [t],
  );

  const statusOptions = useMemo(
    () => [
      { label: t("board.filters.all"), value: "all" },
      { label: t("board.filters.status.waiting"), value: "waiting" },
      { label: t("board.filters.status.searching"), value: "searching" },
      { label: t("board.filters.status.assigned"), value: "assigned" },
      { label: t("board.filters.status.enRoute"), value: "enRoute" },
      { label: t("board.filters.status.arrived"), value: "arrived" },
      { label: t("board.filters.status.closed"), value: "closed" },
      { label: t("board.filters.status.failed"), value: "failed" },
      { label: t("board.filters.status.escalated"), value: "escalated" },
    ],
    [t],
  );

  const timePeriodOptions = useMemo(
    () => [
      { label: t("board.filters.anyTime"), value: "all" },
      { label: t("board.filters.timePeriod.15m"), value: "15m" },
      { label: t("board.filters.timePeriod.1h"), value: "1h" },
      { label: t("board.filters.timePeriod.24h"), value: "24h" },
    ],
    [t],
  );

  const failureReasonOptions = useMemo(
    () => [
      { label: t("board.filters.any"), value: "all" },
      { label: t("board.filters.failureReason.failed_dispatch"), value: "failed_dispatch" },
      { label: t("board.filters.failureReason.no_ambulance"), value: "no_ambulance" },
      { label: t("board.filters.failureReason.eta_exceeded"), value: "eta_exceeded" },
      { label: t("board.filters.failureReason.gps_unavailable"), value: "gps_unavailable" },
    ],
    [t],
  );

  const sortOptions = useMemo(
    () => [
      { label: t("board.filters.sort.default"), value: "all" },
      { label: t("board.filters.sort.createdAt_asc"), value: "createdAt_asc" },
      { label: t("board.filters.sort.severity_desc"), value: "severity_desc" },
      { label: t("board.filters.sort.waitingTime_desc"), value: "waitingTime_desc" },
      { label: t("board.filters.sort.aiConfidence_desc"), value: "aiConfidence_desc" },
    ],
    [t],
  );

  const handleSelect = (requestId: number) => {
    if (isMobile) {
      navigate(`/admin/requests/${requestId}`);
      return;
    }

    handleSelectRequest(requestId);
  };

  const handleFilterChange = (key: string, value: string) => {
    setFilters((prev) => {
      const next = { ...prev };

      if (!value || value === "all") {
        delete next[key];
      } else {
        next[key] = value;
      }

      return next;
    });
    setPage(1);
  };

  const clearFilters = () => {
    setFilters({});
    setPage(1);
  };

  const hasActiveFilters = Object.keys(filters).length > 0;

  return (
    <div className="space-y-5">
      <div className="rounded-2xl border border-border/80 bg-bg-card px-4 py-3 shadow-card dark:border-border">
        <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-sm font-semibold text-heading">{t("board.monitoring.title")}</p>
            <p className="mt-1 text-xs text-muted">{t("board.monitoring.subtitle")}</p>
          </div>
          <button
            type="button"
            onClick={() => setShowFilters(!showFilters)}
            className="inline-flex items-center gap-2 rounded-xl border border-border/80 bg-surface-muted/40 px-3 py-1.5 text-xs text-body transition hover:bg-surface-muted/70"
          >
            <Filter className="h-4 w-4" />
            {t("board.filters.toggle")}
          </button>
        </div>

        {showFilters ? (
          <div className="mt-4 border-t border-border/80 pt-4">
            <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              <SelectField
                label={t("board.filters.severityLabel")}
                placeholder={t("board.filters.all")}
                value={filters.severity || "all"}
                onChange={(value) => handleFilterChange("severity", value)}
                options={severityOptions}
                triggerClassName={FILTER_TRIGGER_CLASS}
              />

              <SelectField
                label={t("board.filters.statusLabel")}
                placeholder={t("board.filters.all")}
                value={filters.status || "all"}
                onChange={(value) => handleFilterChange("status", value)}
                options={statusOptions}
                triggerClassName={FILTER_TRIGGER_CLASS}
              />

              <SelectField
                label={t("board.filters.timePeriodLabel")}
                placeholder={t("board.filters.anyTime")}
                value={filters.last || "all"}
                onChange={(value) => handleFilterChange("last", value)}
                options={timePeriodOptions}
                triggerClassName={FILTER_TRIGGER_CLASS}
              />

              <SelectField
                label={t("board.filters.failureReasonLabel")}
                placeholder={t("board.filters.any")}
                value={filters.failureReason || "all"}
                onChange={(value) => handleFilterChange("failureReason", value)}
                options={failureReasonOptions}
                triggerClassName={FILTER_TRIGGER_CLASS}
              />

              <label className="flex flex-col gap-1.5">
                <span className="text-[11px] font-medium text-muted">
                  {t("board.filters.waitingMoreThanLabel")}
                </span>
                <input
                  type="number"
                  min="0"
                  className="h-9 rounded-md border border-border bg-background-second px-2.5 text-xs text-body outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/30"
                  placeholder={t("board.filters.waitingMoreThanPlaceholder")}
                  value={filters.waitingMoreThan || ""}
                  onChange={(event) => handleFilterChange("waitingMoreThan", event.target.value)}
                />
              </label>

              <SelectField
                label={t("board.filters.sortLabel")}
                placeholder={t("board.filters.sort.default")}
                value={filters.sort || "all"}
                onChange={(value) => handleFilterChange("sort", value)}
                options={sortOptions}
                triggerClassName={FILTER_TRIGGER_CLASS}
              />
            </div>

            {hasActiveFilters ? (
              <div className="mt-3 flex justify-end">
                <button
                  type="button"
                  onClick={clearFilters}
                  className="inline-flex items-center gap-1 text-[11px] text-muted hover:text-body"
                >
                  <X className="h-3 w-3" /> {t("board.filters.clear")}
                </button>
              </div>
            ) : null}
          </div>
        ) : null}
      </div>

      <div className="grid grid-cols-1 gap-5 xl:grid-cols-[minmax(0,7fr)_minmax(0,3fr)]">
        <section className="rounded-2xl border border-border/80 bg-background-second/75 p-4 shadow-card dark:border-border dark:bg-background-second/50">
          <header className="mb-3 flex items-center justify-between border-b border-border/80 pb-3 dark:border-border">
            <div>
              <h3 className="text-base font-semibold text-heading">{t("board.list.title")}</h3>
              <p className="text-xs text-muted">{t("board.list.subtitle", { count: boardRequests.length })}</p>
            </div>

            <div className="flex flex-wrap items-center justify-end gap-2">
              <span className="rounded-full border border-border/80 bg-surface-muted/70 px-2.5 py-1 text-[11px] text-body dark:border-border dark:bg-surface-muted/45 dark:text-muted">
                {t("board.summary.critical", { count: criticalCount })}
              </span>
              <span className="rounded-full border border-border/80 bg-surface-muted/70 px-2.5 py-1 text-[11px] text-body dark:border-border dark:bg-surface-muted/45 dark:text-muted">
                {t("board.summary.assigned", { count: assignedCount })}
              </span>
              <span className="rounded-full border border-border/80 bg-surface-muted/70 px-2.5 py-1 text-[11px] text-body dark:border-border dark:bg-surface-muted/45 dark:text-muted">
                {t("board.summary.searching", { count: searchingCount })}
              </span>
              <span className="rounded-full border border-border/80 bg-surface-muted/70 px-2.5 py-1 text-[11px] text-body dark:border-border dark:bg-surface-muted/45 dark:text-muted">
                {t("board.summary.failed", { count: failedCount })}
              </span>

              <div className="inline-flex items-center gap-2 rounded-full border border-border/80 bg-surface-muted/70 px-3 py-1 text-xs text-body dark:border-border dark:bg-surface-muted/45 dark:text-muted">
                <span className={`h-2 w-2 rounded-full ${queueTone}`} />
                {t(`board.systemState.${systemState}`)}
              </div>
            </div>
          </header>

          <RequestList
            requests={boardRequests}
            selectedId={selectedId}
            isLoading={isLoading}
            onSelect={handleSelect}
          />

          {totalPages > 1 ? (
            <div className="mt-4 flex items-center justify-between border-t border-border/80 pt-4">
              <button
                type="button"
                onClick={() => setPage((current) => Math.max(1, current - 1))}
                disabled={page === 1}
                className="rounded-lg border border-border/80 px-3 py-1 text-xs disabled:opacity-50"
              >
                {t("pagination.previous")}
              </button>
              <span className="text-xs text-muted">
                {t("pagination.page")} {page} {t("pagination.of")} {totalPages}
              </span>
              <button
                type="button"
                onClick={() => setPage((current) => Math.min(totalPages, current + 1))}
                disabled={page === totalPages}
                className="rounded-lg border border-border/80 px-3 py-1 text-xs disabled:opacity-50"
              >
                {t("pagination.next")}
              </button>
            </div>
          ) : null}
        </section>

        <div className="hidden xl:block">
          <RequestDetailsPanel
            request={selectedRequest}
            onViewDetails={handleViewRequestDetails}
            onReassignAmbulance={handleReassignAmbulance}
            onCancelAssignment={handleCancelAssignment}
            isLoading={isLoading}
          />
        </div>
      </div>

      {!isLoading && requests.length === 0 ? (
        <div className="rounded-xl border border-dashed border-border/80 bg-surface-muted/65 px-4 py-6 text-center dark:border-border dark:bg-surface-muted/30">
          <ShieldAlert className="mx-auto h-7 w-7 text-body dark:text-muted" />
          <p className="mt-2 text-sm font-medium text-heading">{t("empty.title")}</p>
          <p className="mt-1 text-xs text-muted">{t("empty.description")}</p>
        </div>
      ) : null}
    </div>
  );
}
