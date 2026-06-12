import SelectField from "@/shared/ui/SelectField";
import { useTranslation } from "react-i18next";

type AmbulanceStatusFilterProps = {
  value: string;
  onChange: (value: string) => void;
};

export default function AmbulanceStatusFilter({ value, onChange }: AmbulanceStatusFilterProps) {
  const { t } = useTranslation("ambulances");

  const options = [
    { label: t("status.all"), value: "all" },
    { label: t("status.available"), value: "Available" },
    { label: t("status.busy"), value: "Busy" },
    { label: t("status.inTransit"), value: "Transiting" },
    { label: t("status.maintenance"), value: "Maintenance" },
    { label: t("status.offline"), value: "Offline" },
  ];

  return (
    <SelectField
      label={t("filters.statusLabel")}
      placeholder={t("status.all")}
      value={value || "all"}
      onChange={(nextValue) => onChange(nextValue === "all" ? "" : nextValue)}
      options={options}
      triggerClassName="h-9 text-xs"
    />
  );
}
