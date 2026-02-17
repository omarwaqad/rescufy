import Logo from "@/shared/common/Logo";
import { useTranslation } from "react-i18next";

export default function SignInHero() {
  const { t } = useTranslation('auth');

  return (
    <>
      {/* Background glow */}
      <div className=" absolute   h-125 bg-purple-400/20 rounded-full blur-3xl" />

      <div className="relative z-10 h-full flex items-center  justify-center ">
        <div className="max-w-xl px-12">
          {/* Logo */}
          <div className="mb-10">
            <Logo  />
          </div>

          {/* Headline */}
          <h1 className="text-5xl font-extrabold text-heading">
            {t('signInHero.headline')} <span className="text-indigo-600">{t('signInHero.headlineHighlight')}</span>
          </h1>

          {/* Description */}
          <p className="mt-6 text-lg text-gray-600 dark:text-gray-400 max-w-md">
            {t('signInHero.description')}
          </p>
        </div>
      </div>
    </>
  );
}
