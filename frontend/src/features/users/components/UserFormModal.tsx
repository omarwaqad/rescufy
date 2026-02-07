import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faXmark } from "@fortawesome/free-solid-svg-icons";
import type { User } from "../data/users.data";
import useModal from "../hooks/useModal";

interface UserFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (user: User) => void;
  user?: User;
  mode: "add" | "edit";
}

export function UserFormModal({
  isOpen,
  onClose,
  onSubmit,
  user,
  mode,
}: UserFormModalProps) {
  const { register, submitHandler, errors } = useModal({
    onSubmit,
    user,
    mode,
  });

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-surface-card w-full max-w-md max-h-[90vh] overflow-hidden flex flex-col rounded-2xl shadow-card border border-border">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-border">
          <h2 className="text-xl font-semibold text-heading">
            {mode === "add" ? "Add New User" : "Edit User"}
          </h2>
          <button
            onClick={onClose}
            className="text-muted hover:text-heading transition-colors p-2 hover:bg-surface-muted rounded-lg"
            aria-label="Close modal"
          >
            <FontAwesomeIcon
              icon={faXmark}
              className="w-5 h-5 cursor-pointer"
            />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={submitHandler} className="flex-1 overflow-y-auto">
          <div className="px-6 py-5 space-y-5">
            {/* Hidden ID field */}
            <input type="hidden" {...register("id")} />

            {/* User Name */}
            <div>
              <label
                htmlFor="name"
                className="block text-sm font-medium text-body mb-1.5"
              >
                Name <span className="text-danger">*</span>
              </label>
              <input
                type="text"
                id="name"
                {...register("name")}
                className={`w-full px-3.5 py-2.5 text-sm border rounded-xl focus:outline-none focus:ring-2 transition-all bg-background text-heading placeholder:text-muted ${
                  errors.name
                    ? "border-danger focus:ring-danger/20"
                    : "border-border focus:ring-primary/30 focus:border-primary"
                }`}
                placeholder="Enter user name"
              />
              {errors.name && (
                <p className="mt-1.5 text-xs text-danger">
                  {errors.name.message}
                </p>
              )}
            </div>

            {/* Email */}
            <div>
              <label
                htmlFor="email"
                className="block text-sm font-medium text-body mb-1.5"
              >
                Email <span className="text-danger">*</span>
              </label>
              <input
                type="email"
                id="email"
                {...register("email")}
                className={`w-full px-3.5 py-2.5 text-sm border rounded-xl focus:outline-none focus:ring-2 transition-all bg-background text-heading placeholder:text-muted ${
                  errors.email
                    ? "border-danger focus:ring-danger/20"
                    : "border-border focus:ring-primary/30 focus:border-primary"
                }`}
                placeholder="user@example.com"
              />
              {errors.email && (
                <p className="mt-1.5 text-xs text-danger">
                  {errors.email.message}
                </p>
              )}
            </div>

            {/* Password */}
            <div>
              <label
                htmlFor="password"
                className="block text-sm font-medium text-body mb-1.5"
              >
                Password <span className="text-danger">*</span>
              </label>
              <input
                type="password"
                id="password"
                {...register("password")}
                className={`w-full px-3.5 py-2.5 text-sm border rounded-xl focus:outline-none focus:ring-2 transition-all bg-background text-heading placeholder:text-muted ${
                  errors.password
                    ? "border-danger focus:ring-danger/20"
                    : "border-border focus:ring-primary/30 focus:border-primary"
                }`}
                placeholder="Min 8 chars, 1 uppercase, 1 number, 1 special char"
              />
              {errors.password && (
                <p className="mt-1.5 text-xs text-danger">
                  {errors.password.message}
                </p>
              )}
            </div>

            {/* Role ID */}
            <div>
              <label
                htmlFor="roleId"
                className="block text-sm font-medium text-body mb-1.5"
              >
                Role <span className="text-danger">*</span>
              </label>
              <select
                id="roleId"
                {...register("roleId")}
                className={`w-full px-3.5 py-2.5 text-sm border rounded-xl focus:outline-none focus:ring-2 transition-all bg-background text-heading ${
                  errors.roleId
                    ? "border-danger focus:ring-danger/20"
                    : "border-border focus:ring-primary/30 focus:border-primary"
                }`}
              >
                <option value="ADMIN">Admin</option>
                <option value="HOSPITAL_USER">Hospital User</option>
                <option value="AMBULANCE_USER">Ambulance User</option>
              </select>
              {errors.roleId && (
                <p className="mt-1.5 text-xs text-danger">
                  {errors.roleId.message}
                </p>
              )}
            </div>
          </div>

          {/* Footer */}
          <div className="flex gap-3 justify-end px-6 py-4 border-t border-border bg-surface-muted">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2.5 text-sm font-medium text-body border border-border rounded-xl hover:bg-surface-muted transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="px-4 py-2.5 text-sm font-medium text-white bg-primary rounded-xl hover:bg-primary/90 transition-colors"
            >
              {mode === "add" ? "Add User" : "Save Changes"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
