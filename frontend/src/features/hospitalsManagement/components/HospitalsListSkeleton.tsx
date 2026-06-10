export function HospitalsListSkeleton() {
  return (
    <div className="grid grid-cols-1 gap-4 rounded-2xl bg-surface-muted/20 p-1 md:p-2 lg:grid-cols-2">
      {Array.from({ length: 6 }).map((_, index) => (
        <article
          key={index}
          className="relative w-full overflow-hidden rounded-2xl border border-border bg-bg-card p-4 shadow-card"
        >
          <div className="animate-pulse">
            <div className="absolute inset-x-0 top-0 h-1 bg-surface-muted" />

            <div className="flex items-start justify-between gap-3">
              <div className="min-w-0 flex-1">
                <div className="h-3 w-20 rounded bg-surface-muted" />
                <div className="mt-2 h-5 w-2/3 rounded bg-surface-muted" />
              </div>
              <div className="h-6 w-20 rounded-full bg-surface-muted" />
            </div>

            <div className="mt-3 space-y-2 rounded-xl border border-border/60 bg-surface-muted/35 px-3 py-2.5">
              <div className="h-3 w-40 rounded bg-surface-muted" />
              <div className="h-3 w-3/4 rounded bg-surface-muted" />
              <div className="grid grid-cols-2 gap-2">
                <div className="h-3 rounded bg-surface-muted" />
                <div className="h-3 rounded bg-surface-muted" />
              </div>
            </div>

            <div className="mt-3 rounded-xl border border-border/60 bg-surface-muted/25 px-3 py-3">
              <div className="mb-2 flex items-center justify-between">
                <div className="h-3 w-20 rounded bg-surface-muted" />
                <div className="h-3 w-14 rounded bg-surface-muted" />
              </div>
              <div className="h-2 rounded-full bg-surface-muted" />
              <div className="mt-2 grid grid-cols-3 gap-2">
                <div className="h-7 rounded bg-surface-muted" />
                <div className="h-7 rounded bg-surface-muted" />
                <div className="h-7 rounded bg-surface-muted" />
              </div>
            </div>

            <div className="mt-4 flex items-center justify-between gap-2">
              <div className="h-8 w-20 rounded-lg bg-surface-muted" />
              <div className="flex items-center gap-1.5">
                <div className="h-8 w-8 rounded-lg bg-surface-muted" />
                <div className="h-8 w-8 rounded-lg bg-surface-muted" />
                <div className="h-8 w-8 rounded-lg bg-surface-muted" />
              </div>
            </div>
          </div>
        </article>
      ))}
    </div>
  );
}
