import InputFiled from "../../../../shared/ui/FormInput/InputFiled";
import { faEnvelope, faLock } from "@fortawesome/free-solid-svg-icons";

import { Link } from "react-router";

import { useTranslation } from "react-i18next";

import useSignIn from "../../hooks/useSignIn";

export default function SignInForm() {
  const { formik, isLoading } = useSignIn();
  const { t } = useTranslation("auth");

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
      <form className="text-sm" onSubmit={formik.handleSubmit}>
        {/* Title */}
        <h2 className="text-3xl font-bold text-center my-6 text-heading">
          {t("auth:signIn.title")}
        </h2>

        {/* Inputs */}
        <div className=" px-6">
          <InputFiled
            label={t("auth:signIn.emailLabel")}
            id="email"
            icon={faEnvelope}
            placeholder={t("auth:signIn.emailPlaceholder")}
            type="email"
            name="email"
            value={formik.values.email}
            onChange={formik.handleChange}
            onBlur={formik.handleBlur}
            error={
              formik.touched.email && formik.errors.email
                ? formik.errors.email
                : undefined
            }
          />

          <InputFiled
            label={t("auth:signIn.passwordLabel")}
            id="password"
            icon={faLock}
            placeholder={t("auth:signIn.passwordPlaceholder")}
            type="password"
            name="password"
            value={formik.values.password}
            onChange={formik.handleChange}
            onBlur={formik.handleBlur}
            error={
              formik.touched.password && formik.errors.password
                ? formik.errors.password
                : undefined
            }
          />

          {/* Submit */}
          <div className="pt-4">
            <button
              type="submit"
              disabled={isLoading || !formik.isValid}
              className="
            cursor-pointer
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
                disabled:opacity-50
                disabled:cursor-not-allowed
                flex
                items-center
                justify-center
                gap-2
              "
            >
              {isLoading && (
                <svg
                  className="animate-spin h-5 w-5"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    className="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    strokeWidth="4"
                  ></circle>
                  <path
                    className="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  ></path>
                </svg>
              )}
              <span>
                {isLoading ? t("auth:signIn.loggingIn") : t("auth:signIn.submitButton")}
              </span>
            </button>
          </div>
        </div>
      </form>

      <div className="mt-6 px-6 pt-6 border-t border-slate-300 dark:border-white/10 text-center">
        <p className="text-gray-600 dark:text-gray-400 text-sm">
          {t("auth:signIn.noAccount")}{" "}
          <Link
            to={"/signup"}
            className="text-primary font-semibold hover:text-primary/80 transition"
          >
            {t("auth:signIn.signUpLink")}
          </Link>
        </p>
      </div>
    </div>
  );
}
