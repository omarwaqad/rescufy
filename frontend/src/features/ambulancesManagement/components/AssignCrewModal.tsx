import React, { useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faUser, faUserNurse, faSpinner } from "@fortawesome/free-solid-svg-icons";
import { useAssignAmbulanceStaff } from "../hooks/useAssignAmbulanceStaff";
import { useGetUsers } from "@/features/users/hooks/useGetUsers";
import SelectField from "@/shared/ui/SelectField";
import type { AmbulanceProfile } from "../types/ambulances.types";

type AssignCrewModalProps = {
  ambulance: AmbulanceProfile;
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
};

export function AssignCrewModal({ ambulance, isOpen, onClose, onSuccess }: AssignCrewModalProps) {
  const { t } = useTranslation(["ambulances", "common"]);
  const { assignStaff, isAssigning } = useAssignAmbulanceStaff();
  
  // We can fetch staff here. Let's fetch them
  const { fetchUsers: fetchDrivers, isLoading: isLoadingDrivers } = useGetUsers();
  const { fetchUsers: fetchParamedics, isLoading: isLoadingParamedics } = useGetUsers();

  const [drivers, setDrivers] = useState<any[]>([]);
  const [paramedics, setParamedics] = useState<any[]>([]);

  const [selectedDriver, setSelectedDriver] = useState<string>("");
  const [selectedParamedic, setSelectedParamedic] = useState<string>("");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isOpen) {
      // Fetch staff when opened
      // The API may expect 'ambulancedriver' and 'paramedic'
      Promise.all([
        fetchDrivers("ambulancedriver"),
        fetchParamedics("paramedic")
      ]).then(([d, p]) => {
        setDrivers(d);
        setParamedics(p);
      });
    }
  }, [isOpen]);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!selectedDriver && !selectedParamedic) {
      setError(t("staff.selectOneAtLeast", "Please select at least one staff member to assign."));
      return;
    }

    if (selectedDriver && selectedDriver === selectedParamedic) {
      setError(t("staff.sameUserError", "A user cannot be both driver and paramedic."));
      return;
    }

    if (ambulance.ambulanceStatus === 2 || ambulance.ambulanceStatus === 1) { // 1: InTransit, 2: Busy
      setError(t("staff.ambulanceBusy", "Cannot assign staff while ambulance is busy or in transit."));
      return;
    }

    const success = await assignStaff(String(ambulance.id), {
      driverId: selectedDriver || undefined,
      paramedicId: selectedParamedic || undefined,
    });

    if (success) {
      if (onSuccess) onSuccess();
      onClose();
    }
  };

  const driverOptions = drivers.map(d => ({
    label: `${d.name}  ${ambulance.driverId === d.id ? "(Current)" : ""}`,
    value: d.id,
  }));

  const paramedicOptions = paramedics.map(p => ({
    label: `${p.name} ${ambulance.paramedicId === p.id ? "(Current)" : ""}`,
    value: p.id,
  }));

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4 animate-in fade-in duration-200">
      <div className="bg-bg-card w-full max-w-md rounded-2xl shadow-xl flex flex-col max-h-[90vh]">
        <div className="flex items-center justify-between border-b border-border p-5">
          <h2 className="text-lg font-semibold text-heading">
            {t("staff.assignCrew", "Assign Crew")} - #{ambulance.ambulanceNumber}
          </h2>
          <button
            onClick={onClose}
            className="text-muted hover:text-heading transition-colors"
          >
            <FontAwesomeIcon icon={faTimes} />
          </button>
        </div>

        <div className="overflow-y-auto p-5">
          {error ? (
             <div className="mb-4 rounded-lg bg-red-500/10 p-3 text-sm text-red-600 dark:text-red-400">
               {error}
             </div>
          ) : null}

          <form id="assign-crew-form" onSubmit={handleSubmit} className="space-y-5">
            <SelectField
              label={t("profile.driverName", "Driver")}
              icon={faUser}
              placeholder={t("staff.selectDriver", "-- Select Driver --")}
              value={selectedDriver}
              onChange={setSelectedDriver}
              options={driverOptions}
              disabled={isLoadingDrivers || isAssigning}
            />

            <SelectField
              label={t("profile.paramedicName", "Paramedic")}
              icon={faUserNurse}
              placeholder={t("staff.selectParamedic", "-- Select Paramedic --")}
              value={selectedParamedic}
              onChange={setSelectedParamedic}
              options={paramedicOptions}
              disabled={isLoadingParamedics || isAssigning}
            />
          </form>
        </div>

        <div className="border-t border-border p-5 flex justify-end gap-3 rounded-b-2xl bg-surface-muted/10">
          <button
            type="button"
            onClick={onClose}
            className="rounded-lg px-4 py-2 text-sm font-semibold text-muted hover:bg-surface-muted transition-colors"
          >
            {t("common:actions.cancel", "Cancel")}
          </button>
          <button
            type="submit"
            form="assign-crew-form"
            disabled={isAssigning}
            className="rounded-lg bg-primary px-5 py-2 text-sm font-semibold text-white hover:opacity-90 disabled:opacity-50 flex items-center justify-center min-w-[120px]"
          >
            {isAssigning ? (
              <FontAwesomeIcon icon={faSpinner} spin />
            ) : (
              t("staff.assignBtn", "Assign Staff")
            )}
          </button>
        </div>
      </div>
    </div>
  );
}