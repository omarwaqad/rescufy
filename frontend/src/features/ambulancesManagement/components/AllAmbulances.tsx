import { useEffect, useState } from "react";
import { AmbulanceFormModal } from "./AmbulanceFormModal";
import { KPISection } from "./KPISection";
import { AmbulanceFleetPanel } from "./AmbulanceFleetPanel";
import { DeleteAmbulanceDialog } from "./DeleteAmbulanceDialog";
import AmbulanceStatusFilter from "./AmbulanceStatusFilter";
import { useAmbulances } from "../hooks/useAmbulances";
import type { Ambulance, AmbulanceControlItem } from "../types/ambulances.types";
import { useTranslation } from "react-i18next";
import { useNavigate } from "react-router";
import { Plus } from "lucide-react";
import SelectField from "@/shared/ui/SelectField";

export default function AllAmbulances() {
  const { t } = useTranslation("ambulances");
  const navigate = useNavigate();
  const [deleteCandidate, setDeleteCandidate] = useState<{
    id: string;
    label: string;
  } | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [modalMode, setModalMode] = useState<"add" | "edit">("add");
  const [selectedAmbulance, setSelectedAmbulance] = useState<Ambulance | undefined>();

  const {
    ambulances,
    isLoading,
    isMutating,
    kpis,
    page,
    limit,
    totalPages,
    statusFilter,
    setPage,
    setLimit,
    setStatusFilter,
    submitAmbulance,
    assignAmbulance,
    trackAmbulance,
    changeAmbulanceStatus,
    handleDeleteAmbulance,
  } = useAmbulances();

  const limitOptions = [
    { label: "10", value: "10" },
    { label: "20", value: "20" },
    { label: "50", value: "50" },
  ];

  const handleStatusFilterChange = (value: string) => {
    setStatusFilter(value);
    setPage(1);
  };

  const handleLimitChange = (value: string) => {
    setLimit(Number(value));
    setPage(1);
  };

  const openAddModal = () => {
    setSelectedAmbulance(undefined);
    setModalMode("add");
    setIsModalOpen(true);
  };

  const openEditModal = (ambulance: AmbulanceControlItem) => {
    setSelectedAmbulance(
      {
      id: ambulance.id,
      name: ambulance.name,
      ambulanceNumber: ambulance.ambulanceNumber,
      vehicleInfo: ambulance.vehicleInfo,
      driverPhone: ambulance.driverPhone,
      driverId: ambulance.driverId,
      paramedicId: ambulance.paramedicId,
      driverName: ambulance.driverName,
      startingPrice: ambulance.startingPrice,
      ambulancePointId: ambulance.ambulancePointId,
      licensePlate: ambulance.ambulanceNumber,
      hospitalId: ambulance.ambulancePointId === null ? "0" : String(ambulance.ambulancePointId),
      status: ambulance.status,
      latitude: ambulance.latitude,
      longitude: ambulance.longitude,
    });
    setModalMode("edit");
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  const handleSubmitAmbulance = async (ambulance: Ambulance) => {
    const isSaved = await submitAmbulance(ambulance, modalMode);

    if (isSaved) {
      setIsModalOpen(false);
    }
  };

  const handleViewProfile = (ambulance: AmbulanceControlItem) => {
    navigate(`/admin/ambulances_management/${ambulance.id}`, {
      state: {
        ambulanceSnapshot: {
          id: ambulance.id,
          name: ambulance.name,
          ambulanceNumber: ambulance.ambulanceNumber,
          vehicleInfo: ambulance.vehicleInfo,
          driverPhone: ambulance.driverPhone,
          driverId: ambulance.driverId,
          paramedicId: ambulance.paramedicId,
          driverName: ambulance.driverName,
          startingPrice: ambulance.startingPrice,
          ambulancePointId: ambulance.ambulancePointId,
          licensePlate: ambulance.ambulanceNumber,
          hospitalId: ambulance.ambulancePointId === null ? "0" : String(ambulance.ambulancePointId),
          status: ambulance.status,
          latitude: ambulance.latitude,
          longitude: ambulance.longitude,
        },
      },
    });
  };

  const handleConfirmDelete = async () => {
    if (!deleteCandidate) {
      return;
    }

    const isDeleted = await handleDeleteAmbulance(deleteCandidate.id, deleteCandidate.label);

    if (isDeleted) {
      if (selectedAmbulance?.id === deleteCandidate.id) {
        setIsModalOpen(false);
        setSelectedAmbulance(undefined);
      }

      setDeleteCandidate(null);
    }
  };

  useEffect(() => {
    if (!deleteCandidate) {
      return;
    }

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key !== "Escape" || isMutating) {
        return;
      }

      setDeleteCandidate(null);
    };

    window.addEventListener("keydown", onKeyDown);

    return () => {
      window.removeEventListener("keydown", onKeyDown);
    };
  }, [deleteCandidate, isMutating]);

  return (
    <div className="mt-6 space-y-6">
      <KPISection
        total={kpis.total}
        available={kpis.available}
        busy={kpis.busy}
        maintenance={kpis.maintenance}
      />

      <div className="rounded-2xl border border-border bg-background-second/60 p-4 shadow-card">
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:max-w-md">
          <AmbulanceStatusFilter value={statusFilter} onChange={handleStatusFilterChange} />
          <SelectField
            label={t("filters.limitLabel")}
            value={String(limit)}
            onChange={handleLimitChange}
            options={limitOptions}
            triggerClassName="h-9 text-xs"
          />
        </div>
      </div>

      <div className="flex flex-col gap-6 w-full">
        <AmbulanceFleetPanel
          ambulances={ambulances}
          isLoading={isLoading}
          onAssign={assignAmbulance}
          onTrack={trackAmbulance}
          onChangeStatus={changeAmbulanceStatus}
          onEdit={openEditModal}
          onDelete={setDeleteCandidate}
          onViewProfile={handleViewProfile}
        />

        {totalPages > 1 ? (
          <div className="flex items-center justify-between border-t border-border pt-4">
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
      </div>

      <button
        onClick={openAddModal}
        type="button"
        disabled={isMutating}
        className="fixed bottom-8 right-8 rtl:right-auto rtl:left-8 z-50 inline-flex h-14 w-14 items-center justify-center rounded-full border border-primary/40 bg-primary text-white shadow-card transition hover:bg-primary/90 disabled:cursor-not-allowed disabled:opacity-60"
        aria-label={t("addAmbulance")}
      >
        <Plus className="h-6 w-6" />
      </button>

      <AmbulanceFormModal
        isOpen={isModalOpen}
        onClose={closeModal}
        onSubmit={handleSubmitAmbulance}
        ambulance={selectedAmbulance}
        mode={modalMode}
      />

      <DeleteAmbulanceDialog
        candidate={deleteCandidate}
        isMutating={isMutating}
        onCancel={() => setDeleteCandidate(null)}
        onConfirm={() => {
          void handleConfirmDelete();
        }}
      />
    </div>
  );
}
