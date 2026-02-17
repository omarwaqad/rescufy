import AllAmbulances from "../components/AllAmbulances";
import { useTranslation } from "react-i18next";

export default function AmbulancesManagement() {
  const { t } = useTranslation('ambulances');

  return (
    <>
      <section className="w-full xl:px-12">
        <header>
          <h1 className="text-heading mb-2 text-4xl font-semibold">
            {t('pageHeader.title')}
          </h1>
          <p className="text-muted text-sm mt-1">
            {t('pageHeader.subtitle')}
          </p>
        </header>
        <AllAmbulances />
      </section>
    </>
  );
}
