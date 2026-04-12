import { RequestRow } from "@/features/requests/components/RequestRow";

import CriticalRequests from "./CriticalRequests";
import { Link } from "react-router";
import { useTranslation } from "react-i18next";

export default function RecentRequests() {
  const { t } = useTranslation('dashboard');

  return (
    <>
      <div className="w-full grid grid-cols-1 lg:grid-cols-12 gap-4  md:gap-6 lg:gap-8 my-6 md:my-8">
        <div className="col-span-1 lg:col-span-8 bg-bg-card pb-10 dark:bg-bg-card rounded-lg md:rounded-2xl shadow-card dark:shadow-card overflow-hidden">
          <div className="header flex flex-col sm:flex-row sm:justify-between sm:items-center gap-3 sm:gap-0 p-4 md:p-6 font-semibold text-base md:text-lg text-heading dark:text-heading border-b border-border">
            <span>{t('recentRequests.title')}</span>
            <Link to={"/admin/requests"} className="text-xs cursor-pointer bg-primary text-white px-3 md:px-4 py-2 rounded-full hover:opacity-90 transition self-start sm:self-auto">
              {t('recentRequests.viewAll')}
            </Link>
          </div>
          <div className="requests-list divide-y divide-border bg-bg-card dark:bg-bg-card">

            <RequestRow
              id={"REQ-2025-001"}
              userName="khaled mahmoud"
              userPhone="+966501234567"
              address="King Fahd Road, Riyadh"
              priority="critical"
              status="pending"
              timestamp="2 mins ago"
              compact
            />
            <RequestRow
              id={"REQ-2025-001"}
              userName="khale ahmed"
              userPhone="+966501234567"
              address="King Fahd Road, Riyadh"
              priority="high"
              status="enRoute"
              timestamp="2 mins ago"
              compact
            />
            <RequestRow
              id={"REQ-2025-001"}
              userName="khale ahmed"
              userPhone="+966501234567"
              address="King Fahd Road, Riyadh"
              priority="medium"
              status="pending"
              timestamp="2 mins ago"
              compact
            />
            <RequestRow
              id={"REQ-2025-001"}
              userName="mohamed ahmed"
              userPhone="+966501234567"
              address="King Fahd Road, Riyadh"
              priority="low"
              status="completed"
              timestamp="2 mins ago"
              compact
            />
          </div>
        </div>

        <div className="col-span-1 lg:col-span-4">
          <CriticalRequests />
        </div>
      </div>

    </>
  );
}
