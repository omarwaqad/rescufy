import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faPenToSquare,
  faTrash,
  faLocationDot,
} from "@fortawesome/free-solid-svg-icons";
import { faAmbulance } from "@fortawesome/free-solid-svg-icons";

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
  const statusStyle: Record<typeof status, string> = {
    AVAILABLE: "text-emerald-600 dark:text-emerald-400",
    IN_TRANSIT: "text-blue-600 dark:text-blue-400",
    BUSY: "text-amber-600 dark:text-amber-400",
    MAINTENANCE: "text-red-600 dark:text-red-400",
  };

  const statusLabel: Record<typeof status, string> = {
    AVAILABLE: "Available",
    IN_TRANSIT: "In transit",
    BUSY: "Busy",
    MAINTENANCE: "Maintenance",
  };

  return (
    <div
      className="
        w-full
        rounded-lg
        border
        border-border
        bg-bg-card
        p-4
        transition
        hover:bg-surface-muted
      "
    >
      {/* Header */}
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-center gap-3 min-w-0">
          <div className="w-8 h-8 rounded-md bg-primary/10 text-primary flex items-center justify-center shrink-0">
            <FontAwesomeIcon icon={faAmbulance} />
          </div>

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
            className="p-1.5 rounded hover:bg-surface-muted text-muted hover:text-heading transition"
            aria-label="Edit ambulance"
          >
            <FontAwesomeIcon icon={faPenToSquare} />
          </button>
          <button
            onClick={onDelete}
            className="p-1.5 rounded hover:bg-danger/10 text-muted hover:text-danger transition"
            aria-label="Delete ambulance"
          >
            <FontAwesomeIcon icon={faTrash} />
          </button>
        </div>
      </div>

      {/* Meta */}
      <div className="mt-3 space-y-1 text-xs">
        <div className="flex items-center justify-between">
          <span className="text-muted">Status</span>
          <span className={`font-semibold ${statusStyle[status]}`}>
            {statusLabel[status]}
          </span>
        </div>

        <div className="flex items-center justify-between">
          <span className="text-muted">Hospital</span>
          <span className="text-text-body font-medium">
            {hospitalId}
          </span>
        </div>

        <div className="flex items-center gap-1.5 text-muted">
          <FontAwesomeIcon icon={faLocationDot} />
          <span>
            {latitude.toFixed(4)}, {longitude.toFixed(4)}
          </span>
        </div>
      </div>
    </div>
  );
}
