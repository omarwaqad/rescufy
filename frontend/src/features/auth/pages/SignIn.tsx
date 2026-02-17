import SignInForm from "../components/AuthForm/SignInForm";
import SignUpHero from "../components/AuthHero/SignUpHero";
import { LanguageSwitcher } from "@/shared/ui/LanguageSwitcher";

export default function SignIn() {
  return (
    <>
      <div className="min-h-screen flex justify-center items-center bg-background dark:bg-background relative">
        {/* Language Switcher - Top Right (LTR) / Top Left (RTL) */}
        <div className="absolute top-4 right-4 z-50 rtl:right-auto rtl:left-4">
          <LanguageSwitcher showLabel />
        </div>

        {/* Hero Section */}
        <div className="w-full grid lg:grid-cols-2 gap-10 items-center">
          <div className="hidden lg:block"><SignUpHero /></div>
          <div><SignInForm /></div>
        </div>
      </div>
    </>
  );
}

