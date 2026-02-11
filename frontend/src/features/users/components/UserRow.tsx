import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faPenToSquare,
  faTrash,
  faEnvelope,
  faEye,
  faEyeSlash,
} from "@fortawesome/free-solid-svg-icons";
import { faUser } from "@fortawesome/free-regular-svg-icons";
import { useState } from "react";
import { useTranslation } from "react-i18next";

interface UserRowProps {
  id: string;
  name: string;
  email: string;
  password: string;
  roleId: string;
  onEdit?: () => void;
  onDelete?: () => void;
}

export function UserRow({
  id,
  name,
  email,
  password,
  roleId,
  onEdit,
  onDelete,
}: UserRowProps) {
  const [showPassword, setShowPassword] = useState(false);
  const { t } = useTranslation(['users', 'common']);

  const roleColor: Record<typeof roleId, string> = {
    ADMIN: "bg-purple-500",
    HOSPITAL_USER: "bg-blue-500",
    AMBULANCE_USER: "bg-green-500",
  };

  const roleLabel: Record<typeof roleId, string> = {
    ADMIN: t('users:roles.admin'),
    HOSPITAL_USER: t('users:roles.hospitalUser'),
    AMBULANCE_USER: t('users:roles.ambulanceUser'),
  };

  const roleBgColor: Record<typeof roleId, string> = {
    ADMIN: "bg-purple-500/15 dark:bg-purple-500/25 text-purple-600 dark:text-purple-400",
    HOSPITAL_USER: "bg-blue-500/15 dark:bg-blue-500/25 text-blue-600 dark:text-blue-400",
    AMBULANCE_USER: "bg-green-500/15 dark:bg-green-500/25 text-green-600 dark:text-green-400",
  };

  return (
    <div className={`relative flex flex-col md:flex-row md:items-center gap-3 md:gap-4 px-4 md:px-6 py-4 md:py-4 bg-card border-b border-border hover:bg-surface-muted/50 transition-colors`}>
      {/* Indicator Bar */}
      <div className={`absolute left-0 rtl:left-auto rtl:right-0 top-0 h-1 md:h-full w-full md:w-1 ${roleColor[roleId]} md:rounded-r rtl:md:rounded-r-none rtl:md:rounded-l rounded-t`} />

      {/* Top Row - Mobile */}
      <div className="md:hidden flex items-start justify-between gap-3 pt-1 w-full">
        {/* User ID & Name */}
        <div className="flex-1 min-w-0">
          <p className="text-xs font-semibold text-heading dark:text-heading truncate">
            {id}
          </p>
          <p className="text-sm font-medium text-heading mt-1">
            {name}
          </p>
        </div>
        {/* Role Badge Mobile */}
        <span
          className={`inline-flex px-2 py-1 rounded-lg text-xs font-semibold whitespace-nowrap ${roleBgColor[roleId]}`}
        >
          {roleLabel[roleId]}
        </span>
      </div>

      {/* Desktop Layout */}
      <div className="hidden md:block md:w-32">
        <p className="text-sm font-semibold text-heading">
          {id}
        </p>
      </div>

      {/* User Name */}
      <div className="hidden md:flex md:items-center md:gap-2 md:w-48">
        <FontAwesomeIcon icon={faUser} className="w-4 h-4 text-muted shrink-0" />
        <p className="text-sm font-medium text-heading truncate">
          {name}
        </p>
      </div>

      {/* Email */}
      <div className="hidden md:flex md:items-center md:gap-2 md:w-85">
        <FontAwesomeIcon icon={faEnvelope} className="w-4 h-4 text-muted shrink-0" />
        <span className="text-sm text-body truncate">{email}</span>
      </div>

      {/* Mobile Email & Password */}
      <div className="md:hidden space-y-2 flex-1 min-w-0">
        <div className="flex items-center gap-2 text-xs md:text-sm">
          <FontAwesomeIcon icon={faEnvelope} className="w-3 h-3 text-muted shrink-0" />
          <span className="text-body truncate">{email}</span>
        </div>
        <div className="flex items-center gap-2 text-xs text-body">
          <span className="font-medium">{t('users:row.password')}</span>
          <span className="font-mono">{showPassword ? password : "•".repeat(8)}</span>
          <button
            onClick={() => setShowPassword(!showPassword)}
            className="text-muted hover:text-heading transition-colors cursor-pointer"
          >
            <FontAwesomeIcon icon={showPassword ? faEyeSlash : faEye} className="w-3 h-3" />
          </button>
        </div>
      </div>

      {/* Desktop Password */}
      <div className="hidden md:flex     md:items-center md:gap-3 md:w-30">
        <span className="text-sm mt-1 text-body font-mono">
          {showPassword ? password : "•".repeat(8)}
        </span>
        <button
          onClick={() => setShowPassword(!showPassword)}
          className="text-muted hover:text-heading transition-colors cursor-pointer p-1 shrink-0"
          aria-label={showPassword ? t('common:aria.hidePassword') : t('common:aria.showPassword')}
        >
          <FontAwesomeIcon icon={showPassword ? faEyeSlash : faEye} className="text-xs" />
        </button>
      </div>

      {/* Desktop Role Badge */}
      <div className="hidden md:flex md:items-center md:w-40 md:justify-center">
        <span
          className={`inline-flex px-2 py-1 rounded-lg text-xs font-semibold whitespace-nowrap ${roleBgColor[roleId]}`}
        >
          {roleLabel[roleId]}
        </span>
      </div>

      {/* Action Buttons Container */}
      <div className="flex items-center gap-2 justify-end md:gap-2 md:w-20">

        {/* Edit Button */}
        <button
          onClick={onEdit}
          className="p-2 text-muted hover:text-heading hover:bg-surface-muted rounded-lg transition-colors cursor-pointer"
          aria-label={t('users:row.editTooltip')}
        >
          <FontAwesomeIcon icon={faPenToSquare} className="w-4 h-4" />
        </button>

        {/* Delete Button */}
        <button
          onClick={onDelete}
          className="p-2 text-muted hover:text-danger hover:bg-danger/10 rounded-lg transition-colors cursor-pointer"
          aria-label={t('users:row.deleteTooltip')}
        >
          <FontAwesomeIcon icon={faTrash} className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
