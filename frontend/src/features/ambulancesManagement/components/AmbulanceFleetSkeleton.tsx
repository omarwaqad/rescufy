export function AmbulanceFleetSkeleton() {
  return (
    <div className="grid grid-cols-1 gap-4 rounded-xl border border-border/50 bg-surface-muted/35 p-2 md:p-3 lg:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4">
      {Array.from({ length: 8 }).map((_, index) => (
        <article
          key={index}
          className="relative w-full overflow-hidden rounded-2xl border border-border/70 bg-bg-card p-4 shadow-soft"
        >
          <div className="animate-pulse">
            <div className="absolute inset-y-0 left-0 w-1 bg-surface-muted" />

            <div className="flex items-start justify-between gap-3">
              <div className="min-w-0 flex-1">
                <div className="h-3 w-12 rounded bg-surface-muted" />
                <div className="mt-2 h-5 w-2/3 rounded bg-surface-muted" />
                <div className="mt-2 h-3 w-24 rounded bg-surface-muted" />
              </div>
              <div className="h-6 w-20 rounded-full bg-surface-muted" />
            </div>

            <div className="mt-3 flex items-center justify-end gap-1.5">
              <div className="h-7 w-7 rounded-md bg-surface-muted" />
              <div className="h-7 w-7 rounded-md bg-surface-muted" />
              <div className="h-7 w-7 rounded-md bg-surface-muted" />
            </div>

            <div className="mt-4 rounded-lg border border-border/50 bg-surface-muted/40 px-3 py-2">
              <div className="h-3 w-full rounded bg-surface-muted" />
            </div>

            <div className="mt-4 grid grid-cols-3 gap-2">
              <div className="h-9 rounded-lg bg-surface-muted" />
              <div className="h-9 rounded-lg bg-surface-muted" />
              <div className="h-9 rounded-lg bg-surface-muted" />
            </div>
          </div>
        </article>
      ))}
    </div>
  );
}
