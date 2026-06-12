import { Link, useLocation } from "react-router-dom";
import { ChevronRight, Home } from "lucide-react";
import { motion } from "framer-motion";
import { useTranslation } from "react-i18next";

export default function Breadcrumb() {
  const location = useLocation();
  const { t } = useTranslation(["navigation", "common"]);
  const pathnames = location.pathname.split("/").filter((x) => x);

  // Helper map to match routes to translation keys
  const getTranslationKey = (segment: string) => {
    switch (segment) {
      case "requests":
        return "sidebar.requests";
      case "hospitals_management":
        return "sidebar.hospitals";
      case "ambulances_management":
        return "sidebar.ambulances";
      case "users":
        return "sidebar.users";
      case "settings":
        return "sidebar.settings";
      case "analytics":
        return "sidebar.analytics";
      case "profile":
        return "sidebar.hospitalProfile";
      default:
        return null;
    }
  };

  // Do not show breadcrumbs on root dashboard to keep it simple, or maybe we do?
  // Let's show it everywhere so it provides a consistent structural reference.
  const isAdminOrHospitalRoot =
    (pathnames[0] === "admin" || pathnames[0] === "hospital") &&
    pathnames.length === 1;

  if (isAdminOrHospitalRoot) return null; // Keep root dashboard clean

  return (
    <motion.nav 
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="mb-5 sm:mb-6 flex" 
      aria-label="Breadcrumb"
    >
      <div className="flex w-fit items-center px-5 py-3 sm:px-6 sm:py-3.5 rounded-xl bg-card border border-border shadow-md backdrop-blur-md">
        <ol className="inline-flex items-center space-x-2 sm:space-x-3 rtl:space-x-reverse">
          {/* Home Item */}
          <li className="inline-flex items-center">
            <Link
              to={pathnames[0] === "hospital" ? "/hospital" : "/admin"}
              className="inline-flex items-center text-sm sm:text-base font-semibold text-muted-foreground hover:text-primary transition-colors"
            >
              <Home className="w-4 h-4 sm:w-5 sm:h-5 mr-2 rtl:ml-2 rtl:mr-0" />
              {t("sidebar.dashboard")}
            </Link>
          </li>

          {/* Dynamic Path Segments */}
          {pathnames.map((segment, index) => {
            if (index === 0 && (segment === "admin" || segment === "hospital")) {
              return null; // Already handled by home item
            }

            const to = `/${pathnames.slice(0, index + 1).join("/")}`;
            const isLast = index === pathnames.length - 1;
            const tKey = getTranslationKey(segment);
            
            let label = tKey ? t(tKey) : segment;
            
            // Capitalize IDs or unknown segments (like request IDs)
            if (!tKey) {
              const formattedValue = segment.replace(/[-_]/g, " ");
              label = formattedValue.charAt(0).toUpperCase() + formattedValue.slice(1);
              if (label.length > 15) {
                label = t("common:details", "Details"); // Fallback for long IDs
              }
            }

            return (
              <motion.li 
                key={to}
                initial={{ opacity: 0, x: -5 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.1, duration: 0.3 }}
              >
                <div className="flex items-center">
                  <ChevronRight className="w-4 h-4 sm:w-5 sm:h-5 text-muted-foreground/70 rtl:rotate-180" />
                  {isLast ? (
                    <span className="ml-2 sm:ml-2.5 rtl:mr-2 sm:rtl:mr-2.5 rtl:ml-0 text-sm sm:text-base font-bold text-primary">
                      {label}
                    </span>
                  ) : (
                    <Link
                      to={to}
                      className="ml-2 sm:ml-2.5 rtl:mr-2 sm:rtl:mr-2.5 rtl:ml-0 text-sm sm:text-base font-semibold text-muted-foreground hover:text-primary transition-colors"
                    >
                      {label}
                    </Link>
                  )}
                </div>
              </motion.li>
            );
          })}
        </ol>
      </div>
    </motion.nav>
  );
}
