import SignUpHero from "../components/AuthHero/SignUpHero";
import SignUpForm from "../components/AuthForm/SignUpForm";
import { LanguageSwitcher } from "@/shared/ui/LanguageSwitcher";

export default function SignUp() {
  return (
    <>
      <div className="min-h-screen relative grid lg:grid-cols-2 bg-background dark:bg-background items-center justify-start">
        {/* Language Switcher */}
        <div className="absolute top-4 right-4 z-50 rtl:right-auto rtl:left-4">
          <LanguageSwitcher showLabel />
        </div>

        <SignUpHero />
        <SignUpForm />
      </div>
    </>
  );
}

