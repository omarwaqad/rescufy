import { createPortal } from "react-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faXmark, faSpinner } from "@fortawesome/free-solid-svg-icons";
import { useTranslation } from "react-i18next";
import SelectField from "@/shared/ui/SelectField";
import { useUserForm } from "../hooks/useUserForm";
import type { User } from "../types/users.types";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (user: User) => void;
  user?: User;
  mode: "add" | "edit";
  isLoading?: boolean;
}

const inputCls = (hasError: boolean) =>
  `w-full px-3.5 py-2.5 text-sm border rounded-xl focus:outline-none focus:ring-2 transition-all bg-background text-heading placeholder:text-muted ${
    hasError
      ? "border-danger focus:ring-danger/20"
      : "border-border focus:ring-primary/30 focus:border-primary"
  }`;

function FieldError({ message }: { message?: string }) {
  if (!message) return null;
  return <p className="mt-1.5 text-xs text-danger">{message}</p>;
}

export function UserFormModal({ isOpen, onClose, onSubmit, user, mode, isLoading = false }: Props) {
  const { t } = useTranslation("users");
  const {
    register, errors, submitHandler, setValue,
    selectedRole, selectedGender, selectedHospitalId, selectedAmbulanceId,
    handleRoleChange,
    hospitals, isHospitalsLoading,
    ambulances, isAmbulancesLoading,
  } = useUserForm({ isOpen, mode, user, onSubmit });

  if (!isOpen) return null;

  const isAdd = mode === "add";

  return createPortal(
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-surface-card w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col rounded-2xl shadow-card border border-border">

        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-border">
          <h2 className="text-xl font-semibold text-heading">
            {isAdd ? t("actions.add") : t("actions.edit")}
          </h2>
          <button
            onClick={onClose}
            disabled={isLoading}
            className="text-muted hover:text-heading transition-colors p-2 hover:bg-surface-muted rounded-lg disabled:opacity-50"
          >
            <FontAwesomeIcon icon={faXmark} className="w-5 h-5" />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={submitHandler} className="flex-1 overflow-y-auto">
          <div className="px-6 py-5 grid grid-cols-1 sm:grid-cols-2 gap-5">

            {/* Full Name */}
            <div>
              <label className="block text-sm font-medium text-body mb-1.5">
                {t("form.name")} <span className="text-danger">*</span>
              </label>
              <input
                type="text"
                {...register("name")}
                disabled={isLoading}
                className={inputCls(!!errors.name)}
                placeholder={t("form.namePlaceholder")}
              />
              <FieldError message={errors.name?.message} />
            </div>

            {/* Email */}
            <div>
              <label className="block text-sm font-medium text-body mb-1.5">
                {t("form.email")} <span className="text-danger">*</span>
              </label>
              <input
                type="email"
                {...register("email")}
                disabled={isLoading}
                className={inputCls(!!errors.email)}
                placeholder={t("form.emailPlaceholder")}
              />
              <FieldError message={errors.email?.message} />
            </div>

            {/* Password */}
            <div>
              <label className="block text-sm font-medium text-body mb-1.5">
                {t("form.password")} {isAdd && <span className="text-danger">*</span>}
              </label>
              <input
                type="password"
                {...register("password")}
                disabled={isLoading}
                className={inputCls(!!errors.password)}
                placeholder={t("form.passwordPlaceholder")}
              />
              <FieldError message={errors.password?.message} />
            </div>

            {/* Phone */}
            <div>
              <label className="block text-sm font-medium text-body mb-1.5">
                {t("form.phone")} {isAdd && <span className="text-danger">*</span>}
              </label>
              <input
                type="tel"
                {...register("phoneNumber")}
                disabled={isLoading}
                className={inputCls(!!errors.phoneNumber)}
                placeholder={t("form.phonePlaceholder")}
              />
              <FieldError message={errors.phoneNumber?.message} />
            </div>

            {/* National ID */}
            <div>
              <label className="block text-sm font-medium text-body mb-1.5">
                {t("form.nationalId")} {isAdd && <span className="text-danger">*</span>}
              </label>
              <input
                type="text"
                {...register("nationalId")}
                disabled={isLoading}
                className={inputCls(!!errors.nationalId)}
                placeholder={t("form.nationalIdPlaceholder")}
              />
              <FieldError message={errors.nationalId?.message} />
            </div>

            {/* Age */}
            <div>
              <label className="block text-sm font-medium text-body mb-1.5">
                {t("form.age")} {isAdd && <span className="text-danger">*</span>}
              </label>
              <input
                type="number"
                min={1}
                max={120}
                {...register("age", {
                  setValueAs: (v) => (v === "" || v == null ? undefined : Number(v)),
                })}
                disabled={isLoading}
                className={inputCls(!!errors.age)}
                placeholder={t("form.agePlaceholder")}
              />
              <FieldError message={errors.age?.message} />
            </div>

            {/* Gender */}
            <div>
              <SelectField
                id="gender"
                label={t("form.gender")}
                required={isAdd}
                value={selectedGender}
                onChange={(v) => setValue("gender", v as any, { shouldDirty: true, shouldValidate: true })}
                options={[
                  { value: "Male", label: t("genders.Male") },
                  { value: "Female", label: t("genders.Female") },
                ]}
                placeholder={t("form.selectGender")}
                disabled={isLoading}
                triggerClassName="rounded-xl px-3.5 py-2.5 text-sm"
                error={errors.gender?.message ? String(errors.gender.message) : undefined}
              />
            </div>

            {/* Role */}
            <div>
              <SelectField
                id="role"
                label={t("form.role")}
                required
                value={selectedRole}
                onChange={handleRoleChange}
                options={[
                  ...(mode === "edit" ? [{ value: "SuperAdmin", label: t("roles.SuperAdmin") }] : []),
                  { value: "Admin", label: t("roles.Admin") },
                  { value: "HospitalAdmin", label: t("roles.HospitalAdmin") },
                  { value: "Paramedic", label: t("roles.Paramedic") },
                  { value: "AmbulanceDriver", label: t("roles.AmbulanceDriver") },
                ]}
                placeholder={t("form.selectRole")}
                disabled={isLoading}
                triggerClassName="rounded-xl px-3.5 py-2.5 text-sm"
                error={errors.role?.message ? String(errors.role.message) : undefined}
              />
            </div>

            {/* Hospital (HospitalAdmin only) */}
            {selectedRole === "HospitalAdmin" && (
              <div className="sm:col-span-2">
                <SelectField
                  id="hospitalId"
                  label={t("form.hospital")}
                  required
                  value={selectedHospitalId}
                  onChange={(v) => setValue("hospitalId", v as any, { shouldDirty: true, shouldValidate: true })}
                  options={hospitals.map((h) => ({ value: String(h.id), label: h.name }))}
                  placeholder={isHospitalsLoading ? t("form.loadingHospitals") : t("form.selectHospital")}
                  disabled={isLoading || isHospitalsLoading}
                  triggerClassName="rounded-xl px-3.5 py-2.5 text-sm"
                  error={errors.hospitalId?.message ? String(errors.hospitalId.message) : undefined}
                />
              </div>
            )}

            {/* Ambulance (AmbulanceDriver only) */}
            {selectedRole === "AmbulanceDriver" && (
              <div className="sm:col-span-2">
                <SelectField
                  id="ambulanceId"
                  label={t("form.ambulance")}
                  required
                  value={selectedAmbulanceId}
                  onChange={(v) => setValue("ambulanceId", v as any, { shouldDirty: true, shouldValidate: true })}
                  options={ambulances.map((a) => ({ value: String(a.id), label: a.name }))}
                  placeholder={isAmbulancesLoading ? t("form.loadingAmbulances") : t("form.selectAmbulance")}
                  disabled={isLoading || isAmbulancesLoading}
                  triggerClassName="rounded-xl px-3.5 py-2.5 text-sm"
                  error={errors.ambulanceId?.message ? String(errors.ambulanceId.message) : undefined}
                />
              </div>
            )}
          </div>

          {/* Footer */}
          <div className="flex gap-3 justify-end px-6 py-4 border-t border-border bg-surface-muted">
            <button
              type="button"
              onClick={onClose}
              disabled={isLoading}
              className="px-4 py-2.5 text-sm font-medium text-body border border-border rounded-xl hover:bg-surface-muted transition-colors disabled:opacity-50"
            >
              {t("actions.cancel")}
            </button>
            <button
              type="submit"
              disabled={isLoading}
              className="px-4 py-2.5 text-sm font-medium text-white bg-primary rounded-xl hover:bg-primary/90 transition-colors disabled:opacity-50 flex items-center gap-2"
            >
              {isLoading && <FontAwesomeIcon icon={faSpinner} className="animate-spin" />}
              {isAdd ? t("actions.add") : t("actions.save")}
            </button>
          </div>
        </form>
      </div>
    </div>,
    document.body,
  );
}
