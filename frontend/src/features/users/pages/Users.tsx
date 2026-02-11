import AllUsers from "../components/AllUsers";
import { useTranslation } from "react-i18next";

export default function Users() {
  const { t } = useTranslation('users');

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
        <AllUsers />
      </section>
    </>
  );
}
