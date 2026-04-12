import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faPenToSquare,
  faTrash,
  faLocationDot,
} from "@fortawesome/free-solid-svg-icons";
import { faAmbulance } from "@fortawesome/free-solid-svg-icons";
import { useTranslation } from "react-i18next";
import { motion, useReducedMotion } from "framer-motion";

interface AmbulanceCardProps {
  id: string;
  licensePlate: string;
  hospitalId: string;
  status: "AVAILABLE" | "IN_TRANSIT" | "BUSY" | "MAINTENANCE";
  latitude: number;
  longitude: number;
  onEdit?: () => void;
  onDelete?: () => void;
}

export function AmbulanceCard({
  id,
  licensePlate,
  hospitalId,
  status,
  latitude,
  longitude,
  onEdit,
  onDelete,
}: AmbulanceCardProps) {
  const { t } = useTranslation('ambulances');
  const shouldReduceMotion = useReducedMotion();
  const isEmergency = status === "BUSY" || status === "MAINTENANCE";
  const isAlert = status !== "AVAILABLE";

  const statusStyle: Record<typeof status, string> = {
    AVAILABLE: "text-emerald-600 dark:text-emerald-400",
    IN_TRANSIT: "text-blue-600 dark:text-blue-400",
    BUSY: "text-amber-600 dark:text-amber-400",
    MAINTENANCE: "text-red-600 dark:text-red-400",
  };

  const statusLabel: Record<typeof status, string> = {
    AVAILABLE: t('status.available'),
    IN_TRANSIT: t('status.inTransit'),
    BUSY: t('status.busy'),
    MAINTENANCE: t('status.maintenance'),
  };

  const statusBgStyle: Record<typeof status, string> = {
    AVAILABLE: "bg-emerald-500/15 dark:bg-emerald-500/25",
    IN_TRANSIT: "bg-blue-500/15 dark:bg-blue-500/25",
    BUSY: "bg-amber-500/15 dark:bg-amber-500/25",
    MAINTENANCE: "bg-red-500/15 dark:bg-red-500/25",
  };

  const statusDotStyle: Record<typeof status, string> = {
    AVAILABLE: "bg-emerald-500",
    IN_TRANSIT: "bg-blue-500",
    BUSY: "bg-amber-500",
    MAINTENANCE: "bg-red-500",
  };

  const statusRailStyle: Record<typeof status, string> = {
    AVAILABLE: "bg-emerald-500/75",
    IN_TRANSIT: "bg-blue-500/75",
    BUSY: "bg-amber-500/80",
    MAINTENANCE: "bg-red-500/85",
  };

  return (
    <motion.article
      className="
        group
        relative
        overflow-hidden
        w-full
        rounded-xl
        border
        border-border/60
        bg-bg-card
        p-4
        shadow-none
        transition-all
        duration-300
        ease-out
        hover:bg-surface-muted/40
        hover:border-border
      "
      initial={shouldReduceMotion ? undefined : { opacity: 0, y: 12, scale: 0.99 }}
      whileInView={shouldReduceMotion ? undefined : { opacity: 1, y: 0, scale: 1 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] as const }}
      whileHover={shouldReduceMotion ? undefined : { y: -4, scale: 1.01 }}
    >
      <span
        aria-hidden
        className={`pointer-events-none absolute left-0 top-3 bottom-3 w-1 rounded-r ${statusRailStyle[status]}`}
      />

      {/* Header */}
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-center gap-3 min-w-0">
          <motion.div
            className="w-9 h-9 rounded-lg bg-primary/10 text-primary flex items-center justify-center shrink-0"
            animate={
              shouldReduceMotion
                ? undefined
                : status === "IN_TRANSIT"
                  ? { x: [0, 2, -2, 0], rotate: [0, -6, 6, 0] }
                  : isEmergency
                    ? { scale: [1, 1.08, 1] }
                    : undefined
            }
            transition={{ duration: 1.6, repeat: Infinity, ease: [0.42, 0, 0.58, 1] as const }}
          >
            <FontAwesomeIcon icon={faAmbulance} />
          </motion.div>

          <div className="min-w-0">
            <h3 className="text-sm font-semibold text-heading truncate">
              {licensePlate}
            </h3>
            <p className="text-xs text-muted truncate">
              ID: {id}
            </p>
          </div>
        </div>

        {/* Actions */}
        <div className="flex items-center gap-1">
          <button
            onClick={onEdit}
            className="p-1.5 rounded-md hover:bg-surface-muted text-muted hover:text-heading transition-colors opacity-0 group-hover:opacity-100"
            aria-label={t('card.editTooltip')}
          >
            <FontAwesomeIcon icon={faPenToSquare} />
          </button>
          <button
            onClick={onDelete}
            className="p-1.5 rounded-md hover:bg-danger/10 text-muted hover:text-danger transition-colors opacity-0 group-hover:opacity-100"
            aria-label={t('card.deleteTooltip')}
          >
            <FontAwesomeIcon icon={faTrash} />
          </button>
        </div>
      </div>

      {/* Meta */}
      <div className="mt-3 space-y-2 text-xs">
        <div className="flex items-center justify-between">
          <span className="text-muted">{t('table.status')}</span>
          <motion.span
            className={`inline-flex items-center gap-1.5 rounded-full px-2 py-0.5 font-semibold ${statusStyle[status]} ${statusBgStyle[status]}`}
            animate={
              isEmergency && !shouldReduceMotion
                ? { scale: [1, 1.04, 1], opacity: [0.88, 1, 0.88] }
                : undefined
            }
            transition={{ duration: 1.4, repeat: Infinity, ease: [0.42, 0, 0.58, 1] as const }}
          >
            <motion.span
              className={`h-1.5 w-1.5 rounded-full ${statusDotStyle[status]}`}
              animate={
                isAlert && !shouldReduceMotion
                  ? { scale: [1, 1.5, 1], opacity: [1, 0.4, 1] }
                  : undefined
              }
              transition={{ duration: isEmergency ? 1 : 1.4, repeat: Infinity, ease: [0.42, 0, 0.58, 1] as const }}
            />
            {statusLabel[status]}
          </motion.span>
        </div>

        <div className="flex items-center justify-between">
          <span className="text-muted">{t('table.hospital')}</span>
          <span className="text-text-body font-medium max-w-[55%] truncate text-right">
            {hospitalId}
          </span>
        </div>

        <div className="flex items-center gap-1.5 text-muted border-t border-border/60 pt-2">
          <FontAwesomeIcon icon={faLocationDot} />
          <span>
            {latitude.toFixed(4)}, {longitude.toFixed(4)}
          </span>
        </div>
      </div>
    </motion.article>
  );
}
