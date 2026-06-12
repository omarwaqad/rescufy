import { FileText, Pencil, Plus } from "lucide-react";
import { useTranslation } from "react-i18next";
import type { TripReport } from "../types/requestDetails.types";
import SectionCard from "./SectionCard";
import FieldItem from "./FieldItem";
import { useAuth } from "@/app/provider/AuthContext";

function formatDateTime(iso: string, locale: string): string {
  if (!iso) return "-";
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return "-";
  return date.toLocaleString(locale, {
    day: "2-digit",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

interface TripReportSectionCardProps {
  tripReport: TripReport | null;
  onOpenModal: () => void;
  readOnly?: boolean;
}

export default function TripReportSectionCard({
  tripReport,
  onOpenModal,
  readOnly = false,
}: TripReportSectionCardProps) {
  const { t, i18n } = useTranslation("requests");
  const { user } = useAuth();
  const isHospitalAdmin = user?.Role === "hospitaladmin";

  if (!isHospitalAdmin && !(readOnly && tripReport)) {
    return null;
  }

  return (
    <SectionCard
      title={t("details.adminLayout.sections.tripReport.title")}
      icon={<FileText className="h-4 w-4" />}
      subtitle={t("details.adminLayout.sections.tripReport.subtitle")}
    >
      {tripReport ? (
        <div className="space-y-3">
          <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
            {tripReport.hospitalName ? (
              <FieldItem
                label={t("details.adminLayout.fields.hospitalName", "Hospital")}
                value={tripReport.hospitalName}
              />
            ) : null}
            {tripReport.patientName ? (
              <FieldItem
                label={t("details.patientInfo", "Patient")}
                value={tripReport.patientName}
              />
            ) : null}
            <FieldItem
              label={t("details.adminLayout.fields.admissionTime", "Admission Time")}
              value={formatDateTime(tripReport.admissionTime, i18n.language)}
            />
            <FieldItem
              label={t("details.adminLayout.fields.dischargeTime", "Discharge Time")}
              value={formatDateTime(tripReport.dischargeTime, i18n.language)}
            />
          </div>
          <div className="rounded-xl border border-border/70 bg-surface-muted/25 p-3">
            <p className="text-xs text-muted">
              {t("details.adminLayout.fields.medicalProcedures", "Medical Procedures")}
            </p>
            <p className="mt-2 whitespace-pre-wrap text-sm text-body">
              {tripReport.medicalProcedures || "-"}
            </p>
          </div>
          {isHospitalAdmin && !readOnly ? (
            <button
              type="button"
              onClick={onOpenModal}
              className="inline-flex items-center gap-1.5 rounded-lg border border-primary/30 bg-primary/8 px-3 py-1.5 text-xs font-medium text-primary transition hover:bg-primary/15"
            >
              <Pencil className="h-3 w-3" />
              {t("details.adminLayout.editTripReport", "Edit Report")}
            </button>
          ) : null}
        </div>
      ) : isHospitalAdmin && !readOnly ? (
        <div className="flex flex-col items-start gap-3">
          <p className="text-sm text-muted">{t("details.adminLayout.noTripReport")}</p>
          <button
            type="button"
            onClick={onOpenModal}
            className="inline-flex items-center gap-1.5 rounded-lg border border-primary/30 bg-primary/8 px-3 py-1.5 text-xs font-medium text-primary transition hover:bg-primary/15"
          >
            <Plus className="h-3 w-3" />
            {t("details.adminLayout.addTripReport", "Add Report")}
          </button>
        </div>
      ) : (
        <p className="text-sm text-muted">{t("details.adminLayout.noTripReport")}</p>
      )}
    </SectionCard>
  );
}
