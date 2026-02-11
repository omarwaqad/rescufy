import { StatCard } from "./StatCard";
import { Users, Activity, Clock, DollarSign } from "lucide-react";
import RecentRequests from "./RecentRequests";
import { useTranslation } from "react-i18next";

export default function DashBoardContent() {
  const { t } = useTranslation('dashboard');

  return (
    <>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 md:gap-4 lg:gap-6 mb-6 md:mb-8">

        <StatCard
          title={t('stats.totalUsers')}
          value="1,234"
          icon={Users}
          trend={{ value: "+12%", isPositive: true }}
          variant="default"
        />

        <StatCard
          title={t('stats.activeSessions')}
          value="567"
          icon={Activity}
          trend={{ value: "-2%", isPositive: false }}
          variant="critical"
        />

        <StatCard
          title={t('stats.totalRevenue')}
          value="$45,678"
          icon={DollarSign}
          trend={{ value: "+5%", isPositive: true }}
          variant="success"
        />

        <StatCard
          title={t('stats.pendingTasks')}
          value="89"
          icon={Clock}
          trend={{ value: "+10%", isPositive: true }}
          variant="warning"
        />
      </div>
      <RecentRequests />

    </>
  );
}
