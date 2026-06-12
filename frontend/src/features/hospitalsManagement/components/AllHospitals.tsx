import { useEffect, useMemo, useState } from "react";
import { HospitalCard } from "./HospitalCard";
import { HospitalFormModal } from "./HospitalFormModal";
import { HospitalsKPISection } from "./HospitalsKPISection";
import { HospitalsInsightsPanel } from "./HospitalsInsightsPanel";
import { HospitalsListSkeleton } from "./HospitalsListSkeleton";
import HospitalsStates from "./HospitalsStates";
import { useHospitals, type HospitalSortOption } from "../hooks/useHospitals";
import { useTranslation } from "react-i18next";
import { motion, useReducedMotion } from "framer-motion";
import { useNavigate } from "react-router";
import { Plus, ShieldAlert } from "lucide-react";
import SelectField from "@/shared/ui/SelectField";

function sanitizePhoneNumber(phone: string) {
  return phone.replace(/\s+/g, "");
}

export default function AllHospitals() {
  const { t } = useTranslation("hospitals");
  const shouldReduceMotion = useReducedMotion();
  const navigate = useNavigate();
  const [deleteCandidate, setDeleteCandidate] = useState<{
    id: string;
    name: string;
  } | null>(null);

  const {
    hospitals: operationalHospitals,
    allHospitals,
    isModalOpen,
    modalMode,
    selectedHospital,
    isLoading,
    page,
    limit,
    totalPages,
    totalItems,
    statusFilter,
    searchQuery,
    sortOption,
    setPage,
    setStatusFilter,
    setSearchQuery,
    setSortOption,
    setLimit,
    openAddModal,
    openEditModal,
    closeModal,
    submitHospital,
    handleDeleteHospital,
  } = useHospitals();

  const limitOptions = [
    { label: "10", value: "10" },
    { label: "20", value: "20" },
    { label: "50", value: "50" },
  ];

  const sortOptions = [
    { label: t("operations.filters.sort.criticalFirst"), value: "criticalFirst" },
    { label: t("operations.filters.sort.occupancyHigh"), value: "occupancyHigh" },
    { label: t("operations.filters.sort.availableHigh"), value: "availableHigh" },
  ];

  const kpis = useMemo(() => {
    const total = allHospitals.length;
    const normal = allHospitals.filter((item) => item.status === "NORMAL").length;
    const busyOrCritical = allHospitals.filter(
      (item) => item.status === "BUSY" || item.status === "CRITICAL",
    ).length;
    const full = allHospitals.filter((item) => item.status === "FULL").length;

    return {
      total,
      normal,
      busyOrCritical,
      full,
    };
  }, [allHospitals]);

  const insights = useMemo(() => {
    const totalUsedBeds = allHospitals.reduce((sum, item) => sum + item.usedBeds, 0);
    const totalAvailableBeds = allHospitals.reduce(
      (sum, item) => sum + item.availableBeds,
      0,
    );
    const avgOccupancy =
      allHospitals.length > 0
        ? Math.round(
            allHospitals.reduce((sum, item) => sum + item.occupancyPercent, 0) /
              allHospitals.length,
          )
        : 0;

    const stressedHospitals = [...allHospitals]
      .filter((item) => item.status === "FULL" || item.status === "CRITICAL")
      .sort((a, b) => b.occupancyPercent - a.occupancyPercent)
      .slice(0, 5)
      .map((item) => ({
        id: item.id,
        name: item.name,
        status: item.status,
        occupancyPercent: item.occupancyPercent,
      }));

    return {
      totalUsedBeds,
      totalAvailableBeds,
      avgOccupancy,
      stressedHospitals,
    };
  }, [allHospitals]);

  const controlTone =
    kpis.full > 0
      ? "bg-red-500"
      : kpis.busyOrCritical > 0
        ? "bg-amber-500"
        : "bg-emerald-500";

  const listVariants = {
    hidden: {},
    visible: {
      transition: {
        staggerChildren: shouldReduceMotion ? 0 : 0.08,
        delayChildren: shouldReduceMotion ? 0 : 0.06,
      },
    },
  };

  const itemVariants = {
    hidden: {
      opacity: 0,
      y: shouldReduceMotion ? 0 : 14,
      scale: shouldReduceMotion ? 1 : 0.99,
    },
    visible: {
      opacity: 1,
      y: 0,
      scale: 1,
      transition: {
        duration: shouldReduceMotion ? 0.15 : 0.42,
        ease: [0.22, 1, 0.36, 1] as const,
      },
    },
  };

  const handleConfirmDelete = async () => {
    if (!deleteCandidate) {
      return;
    }

    const isDeleted = await handleDeleteHospital(deleteCandidate.id, deleteCandidate.name);

    if (isDeleted) {
      setDeleteCandidate(null);
    }
  };

  useEffect(() => {
    if (!deleteCandidate) {
      return;
    }

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key !== "Escape" || isLoading) {
        return;
      }

      setDeleteCandidate(null);
    };

    window.addEventListener("keydown", onKeyDown);

    return () => {
      window.removeEventListener("keydown", onKeyDown);
    };
  }, [deleteCandidate, isLoading]);

  return (<div className="mt-6 space-y-6">
  <HospitalsKPISection
    total={kpis.total}
    normal={kpis.normal}
    busyOrCritical={kpis.busyOrCritical}
    full={kpis.full}
  />

  <div className="rounded-2xl border border-border bg-background-second/60 p-4 shadow-card">
    <div className="mb-3">
      <h3 className="text-sm font-semibold text-heading">{t("operations.filters.title")}</h3>
    </div>
    <div className="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-4">
      <label className="block space-y-1.5">
        <span className="text-xs font-medium text-muted">{t("operations.filters.searchLabel")}</span>
        <input
          type="search"
        
          value={searchQuery}
          onChange={(event) => setSearchQuery(event.target.value)}
          placeholder={t("filters.searchPlaceholder")}
          className="h-9 w-full rounded-xl border border-border bg-surface-muted/30 px-3 text-xs text-body outline-none transition focus:border-primary/50"
        />
      </label>

      <HospitalsStates  value={statusFilter} onChange={setStatusFilter} />
      <SelectField
        label={t("operations.filters.sortLabel")}
        value={sortOption}
        onChange={(value) => setSortOption(value as HospitalSortOption)}
        options={sortOptions}
        triggerClassName="h-9 text-xs"
      />
      <SelectField
        label={t("filters.limitLabel")}
        value={String(limit)}
        onChange={(value) => setLimit(Number(value))}
        options={limitOptions}
        triggerClassName="h-9 text-xs"
      />
    </div>
  </div>

  <div className="grid grid-cols-1 gap-5 xl:grid-cols-[minmax(0,1fr)_340px]">
    {/* Hospitals List */}
    <section
      className="
        rounded-3xl
        border border-border/60
        bg-background-second/40
        p-4 md:p-5
        shadow-card
        backdrop-blur-sm
      "
    >
      <header className="mb-4 flex flex-col gap-2 border-b border-border/60 pb-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h3 className="text-base font-semibold text-heading">
            {t("operations.list.title")}
          </h3>

          <p className="text-xs text-muted">
            {t("operations.list.subtitle", {
              count: totalItems,
            })}
          </p>
        </div>

        <div
          className="
            inline-flex items-center gap-2
            rounded-full
            border border-border/60
            bg-surface-muted/30
            px-3 py-1
            text-xs text-muted
            backdrop-blur-sm
          "
        >
          <span
            className={`h-2 w-2 rounded-full ${controlTone}`}
          />

          {t("operations.liveMonitoring")}
        </div>
      </header>

      {isLoading ? (
        <HospitalsListSkeleton />
      ) : operationalHospitals.length === 0 ? (
        <div
          className="
            rounded-2xl
            border border-dashed border-border
            bg-surface-muted/20
            px-4 py-8
            text-center
          "
        >
          <ShieldAlert className="mx-auto h-7 w-7 text-muted" />

          <p className="mt-3 text-sm font-medium text-heading">
            {t("empty.title")}
          </p>

          <p className="mt-1 text-xs text-muted">
            {t("empty.description")}
          </p>
        </div>
      ) : (
        <motion.div
          className="
            grid grid-cols-1 gap-4
            rounded-2xl
            bg-surface-muted/20
            p-1 md:p-2
            lg:grid-cols-2
          "
          variants={listVariants}
          initial="hidden"
          animate="visible"
        >
          {operationalHospitals.map((hospital) => (
            <motion.div
              key={hospital.id}
              variants={itemVariants}
            >
              <HospitalCard
                {...hospital}
                onCall={() => {
                  window.location.href = `tel:${sanitizePhoneNumber(
                    hospital.contactPhone
                  )}`;
                }}
                onViewProfile={() =>
                  navigate(
                    `/admin/hospitals_management/${hospital.id}`
                  )
                }
                onEdit={() => openEditModal(hospital)}
                onDelete={() =>
                  setDeleteCandidate({
                    id: hospital.id,
                    name: hospital.name,
                  })
                }
              />
            </motion.div>
          ))}
        </motion.div>
      )}

      {totalPages > 1 ? (
        <div className="mt-4 flex items-center justify-between border-t border-border/60 pt-4">
          <button
            type="button"
            onClick={() => setPage((current) => Math.max(1, current - 1))}
            disabled={page === 1 || isLoading}
            className="rounded-lg border border-border px-3 py-1 text-xs text-body transition hover:bg-surface-muted/50 disabled:cursor-not-allowed disabled:opacity-50"
          >
            {t("pagination.previous")}
          </button>
          <span className="text-xs text-muted">
            {t("pagination.page")} {page} {t("pagination.of")} {totalPages}
          </span>
          <button
            type="button"
            onClick={() => setPage((current) => Math.min(totalPages, current + 1))}
            disabled={page === totalPages || isLoading}
            className="rounded-lg border border-border px-3 py-1 text-xs text-body transition hover:bg-surface-muted/50 disabled:cursor-not-allowed disabled:opacity-50"
          >
            {t("pagination.next")}
          </button>
        </div>
      ) : null}
    </section>

    {/* Insights Panel */}
    <div className="xl:sticky xl:top-24 h-fit">
      <HospitalsInsightsPanel
        totalHospitals={allHospitals.length}
        avgOccupancy={insights.avgOccupancy}
        totalAvailableBeds={insights.totalAvailableBeds}
        totalUsedBeds={insights.totalUsedBeds}
        stressedHospitals={insights.stressedHospitals}
      />
    </div>
  </div>

  {/* Floating Action Button */}
  <button
    onClick={openAddModal}
    type="button"
    disabled={isLoading}
    aria-label={t("addHospital")}
    className="
      fixed bottom-5 right-5
      rtl:right-auto rtl:left-5
      z-50

      inline-flex h-14 w-14
      items-center justify-center

      rounded-2xl

      border border-primary/30
      bg-primary

      text-white

      shadow-[0_10px_35px_rgba(99,102,241,0.35)]

      transition-all duration-200

      hover:scale-105
      hover:bg-primary/90

      active:scale-95

      disabled:cursor-not-allowed
      disabled:opacity-60
    "
  >
    <Plus className="h-6 w-6" />
  </button>

  {/* Form Modal */}
  <HospitalFormModal
    isOpen={isModalOpen}
    onClose={closeModal}
    onSubmit={submitHospital}
    hospital={selectedHospital}
    mode={modalMode}
    isLoading={isLoading}
  />

  {/* Delete Modal */}
  {deleteCandidate ? (
    <div
      className="
        fixed inset-0 z-50
        flex items-center justify-center
        bg-black/50
        p-4
        backdrop-blur-sm
      "
      role="presentation"
      onClick={() => {
        if (!isLoading) {
          setDeleteCandidate(null);
        }
      }}
    >
      <div
        role="dialog"
        aria-modal="true"
        aria-label={t("deleteDialog.title")}
        onClick={(event) => event.stopPropagation()}
        className="
          w-full max-w-md

          rounded-3xl

          border border-border/70
          bg-surface-card/95

          p-5

          shadow-[0_20px_60px_rgba(0,0,0,0.35)]

          backdrop-blur-xl
        "
      >
        <h3 className="text-lg font-semibold text-heading">
          {t("deleteDialog.title")}
        </h3>

        <p className="mt-2 text-sm text-body">
          {t("deleteDialog.description", {
            name: deleteCandidate.name,
          })}
        </p>

        <div className="mt-5 flex items-center justify-end gap-3">
          <button
            type="button"
            disabled={isLoading}
            onClick={() => setDeleteCandidate(null)}
            className="
              rounded-xl
              border border-border
              px-4 py-2

              text-sm font-medium text-body

              transition

              hover:bg-surface-muted

              disabled:cursor-not-allowed
              disabled:opacity-60
            "
          >
            {t("deleteDialog.cancel")}
          </button>

          <button
            type="button"
            disabled={isLoading}
            onClick={() => {
              void handleConfirmDelete();
            }}
            className="
              rounded-xl

              border border-danger/40
              bg-danger

              px-4 py-2

              text-sm font-semibold text-white

              transition

              hover:bg-danger/90

              disabled:cursor-not-allowed
              disabled:opacity-60
            "
          >
            {isLoading
              ? t("deleteDialog.deleting")
              : t("deleteDialog.confirm")}
          </button>
        </div>
      </div>
    </div>
  ) : null}
</div>
  );
}