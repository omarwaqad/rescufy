export function RequestDetailsSkeleton() {

  return (
    <aside className="h-fit rounded-2xl border border-border/60 bg-bg-card p-5 shadow-card xl:sticky xl:top-4 overflow-hidden">
      <div className="animate-pulse">
        <div className="h-4 w-32 rounded bg-surface-muted dark:bg-surface-muted/30" />
        <div className="mt-2 h-3 w-48 rounded bg-surface-muted dark:bg-surface-muted/30" />

        <div className="mt-4 space-y-3">
          <div className="rounded-xl border border-border/40 bg-surface-muted/40 p-3 px-3 py-2.5 dark:border-border/30 dark:bg-surface-muted/20">
            <div className="flex items-center justify-between gap-3">
              <div className="h-2.5 w-24 rounded bg-surface-muted dark:bg-surface-muted/30" />
              <div className="h-5 w-20 rounded-full bg-surface-muted dark:bg-surface-muted/30" />
            </div>
            <div className="mt-3 h-4 w-36 rounded bg-surface-muted dark:bg-surface-muted/30" />
            <div className="mt-3 h-6 w-16 rounded-full bg-surface-muted dark:bg-surface-muted/30" />
          </div>

          <div className="rounded-xl border border-border/40 bg-surface-muted/40 px-3 py-2.5 dark:border-border/30 dark:bg-surface-muted/20">
            <div className="h-2.5 w-28 rounded bg-surface-muted dark:bg-surface-muted/30" />
            <div className="mt-2 h-4 w-32 rounded bg-surface-muted dark:bg-surface-muted/30" />
            <div className="mt-2 flex items-center gap-1.5">
              <div className="h-3.5 w-3.5 rounded-full bg-surface-muted dark:bg-surface-muted/30" />
              <div className="h-3 w-4/5 rounded bg-surface-muted dark:bg-surface-muted/30" />
            </div>
            <div className="mt-3 space-y-1.5">
              <div className="h-3 w-full rounded bg-surface-muted dark:bg-surface-muted/30" />
              <div className="h-3 w-5/6 rounded bg-surface-muted dark:bg-surface-muted/30" />
            </div>
          </div>

          <div className="rounded-xl border border-border/40 bg-surface-muted/40 px-3 py-2.5 dark:border-border/30 dark:bg-surface-muted/20">
            <div className="h-2.5 w-32 rounded bg-surface-muted dark:bg-surface-muted/30" />
            <div className="mt-2 h-4 w-28 rounded bg-surface-muted dark:bg-surface-muted/30" />
            <div className="mt-2 h-3 w-20 rounded bg-surface-muted dark:bg-surface-muted/30" />
          </div>
        </div>

        <div className="mt-4 rounded-xl border border-border/40 bg-surface-muted/40 p-3 dark:border-border/40 dark:bg-surface-muted/15">
          <div className="h-3 w-16 rounded bg-surface-muted dark:bg-surface-muted/30" />
          <div className="mt-3 space-y-2">
            <div className="h-9 w-full rounded-lg bg-surface-muted dark:bg-surface-muted/30" />
            <div className="h-9 w-full rounded-lg bg-surface-muted dark:bg-surface-muted/30" />
            <div className="h-9 w-full rounded-lg bg-surface-muted dark:bg-surface-muted/30" />
          </div>
        </div>
      </div>
    </aside>
  );
}