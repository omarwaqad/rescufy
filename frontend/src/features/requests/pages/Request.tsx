
import AllRequests from "../components/AllRequests";
import { useTranslation } from "react-i18next";

export default function Request() {
  const { t } = useTranslation('requests');

  return (
    <>
      <section className=" w-ful xl:px-12 ">
        <header>
          <h1 className="text-heading mb-2 text-4xl font-semibold">
            {t('pageHeader.title')}
          </h1>
          <span className="text-muted text-sm">
            {t('pageHeader.subtitle')}
          </span>
        </header>
        <main className="mt-8">
          {/* Request list and filters will go here */}

        

          {/* all requests here */}

          <AllRequests />
        </main>
      </section>
    </>
  );
}
