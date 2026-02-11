import InputFiled from "../../../../shared/ui/FormInput/InputFiled";
import { faUser, faEnvelope, faLock } from "@fortawesome/free-solid-svg-icons";
import { Link } from "react-router";
import { useTranslation } from "react-i18next";

export default function SignUpForm() {
  const { t } = useTranslation(['auth', 'validation']);

  return (
    <div
      className="
        w-full max-w-md mx-auto
        bg-gray-100
        dark:bg-background
        py-4
        rounded-2xl
        shadow-xl
        border border-slate-200 dark:border-white/10
        text-sm
      "
    >
      <form className="text-sm">
        {/* Title */}
        <h2 className="text-3xl font-bold text-center my-6 text-heading">
          {t('auth:signUp.title')}
        </h2>

        {/* Inputs */}
        <div className=" px-6">
          <InputFiled
            label={t('auth:signUp.fullNameLabel')}
            id="fullName"
            name="fullName"
            icon={faUser}
            placeholder={t('auth:signUp.fullNamePlaceholder')}
            type="text"
          />

          <InputFiled
            label={t('auth:signUp.emailLabel')}
            id="email"
            name="email"
            icon={faEnvelope}
            placeholder={t('auth:signUp.emailPlaceholder')}
            type="email"
          />

          <InputFiled
            label={t('auth:signUp.passwordLabel')}
            id="password"
            name="password"
            icon={faLock}
            placeholder={t('auth:signUp.passwordPlaceholder')}
            type="password"
          />

          <InputFiled
            label={t('auth:signUp.confirmPasswordLabel')}
            id="confirmPassword"
            name="confirmPassword"
            icon={faLock}
            placeholder={t('auth:signUp.confirmPasswordPlaceholder')}
            type="password"
          />

          {/* Submit */}
          <div className="pt-4">
            <button
              type="submit"
              className="
                w-full
                bg-primary
                text-white
                py-3
                rounded-lg
                font-semibold
                hover:bg-primary/90
                focus:outline-none
                focus:ring-2
                focus:ring-primary/40
                transition
              "
            >
              {t('auth:signUp.submitButton')}
            </button>
          </div>
        </div>
      </form>

      <div className="mt-6 px-6 pt-6 border-t border-slate-300 dark:border-white/10 text-center">
        <p className="text-gray-600 dark:text-gray-400 text-sm">
          {t('auth:signUp.hasAccount')}{" "}
          <Link
            to={"/signin"}
            className="text-primary font-semibold hover:text-primary/80 transition"
          >
            {t('auth:signUp.signInLink')}
          </Link>
        </p>
      </div>
    </div>
  );
}

