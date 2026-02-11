import { useTranslation } from "react-i18next";

const ActionButtons = () => {
  const { t } = useTranslation("requests");
  return (
    <div
      style={{
        boxShadow: "var(--shadow-card)",
      }}
      className="bg-bg-card rounded-xl p-4"
    >
      <h3 style={{ color: "var(--text-heading)" }} className="font-semibold mb-4">
        {t("details.actions")}
      </h3>
      <div className="grid grid-cols-2 gap-3">
        <button
          style={{
            borderColor: "var(--brand-primary)",
            color: "var(--brand-primary)",
          }}
          className="px-4 py-2 rounded-lg border hover:opacity-80 transition font-medium text-sm"
        >
          {t("details.reassign")}
        </button>
        <button
          style={{
            borderColor: "var(--brand-accent)",
            color: "var(--brand-accent)",
          }}
          className="px-4 py-2 rounded-lg border hover:opacity-80 transition font-medium text-sm"
        >
          {t("details.changeHospital")}
        </button>
        <button
          style={{
            borderColor: "var(--warning)",
            color: "var(--warning)",
          }}
          className="px-4 py-2 rounded-lg border hover:opacity-80 transition font-medium text-sm"
        >
          {t("details.override")}
        </button>
        <button
          style={{
            borderColor: "var(--danger)",
            color: "var(--danger)",
          }}
          className="px-4 py-2 rounded-lg border hover:opacity-80 transition font-medium text-sm"
        >
          {t("details.cancelRequest")}
        </button>
      </div>
    </div>
  );
};

export default ActionButtons;
