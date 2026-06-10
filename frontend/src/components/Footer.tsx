import { Link } from "react-router";

export default function Footer() {
  return (
    <footer className="border-t border-border/50 bg-background-second/95 backdrop-blur-xl mt-auto">
      <div className="mx-auto w-full flex flex-col md:flex-row items-center justify-between gap-4 md:gap-3 px-4 sm:px-6 lg:px-10 py-4 md:py-3 text-sm">

        {/* Left — brand + nav */}
        <div className="flex flex-col sm:flex-row items-center gap-3 sm:gap-4 w-full md:w-auto">

          {/* Brand */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-bold text-heading">Rescufy</span>
          </div>

          {/* Divider visible only on sm screens and up */}
          <div className="hidden sm:block h-3.5 w-px bg-border/50" />

          {/* Nav links */}
          <nav className="flex flex-wrap justify-center items-center gap-3 sm:gap-4 text-muted">
            <Link to="/admin" className="transition hover:text-primary">Dashboard</Link>
            <Link to="/admin/requests" className="transition hover:text-primary">Requests</Link>
            <Link to="/admin/analytics" className="transition hover:text-primary">Analytics</Link>
          </nav>
        </div>

        {/* Right — status pill + copyright */}
        <div className="flex flex-col-reverse sm:flex-row flex-wrap items-center justify-center gap-3 sm:gap-4 w-full md:w-auto mt-2 md:mt-0">
          <span className="text-xs text-muted">© {new Date().getFullYear()} Rescufy</span>
          
          <div className="flex items-center gap-1.5 rounded-full border border-emerald-500/20 bg-emerald-500/10 px-2.5 py-1.5 sm:py-1 text-xs font-medium text-emerald-500 dark:text-emerald-400 shadow-sm">
            <span className="h-1.5 w-1.5 rounded-full bg-emerald-500 dark:bg-emerald-400 shadow-[0_0_8px_rgba(52,211,153,0.6)] animate-pulse" />
            All systems operational
          </div>
        </div>

      </div>
    </footer>
  );
}