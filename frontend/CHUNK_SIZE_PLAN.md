# Chunk Size Warning Plan

## Goal
Remove or greatly reduce the Vite warning about chunks larger than 500 kB, while keeping the codebase clean and easy to maintain.

## Current Situation
- Build passes, but one JS bundle is too large after minification.
- Main cause: many pages and vendor libraries are loaded in the first bundle.

## Simple Plan

### 1) Route-level code splitting (first priority)
- Target file: `src/app/routes/Router.tsx`
- Replace direct page imports with lazy loading.
- Load each page only when its route is visited.
- Use a shared fallback loader component while lazy pages load.

Expected result:
- Smaller initial bundle.
- Faster first load.

### 2) Split vendor chunks in Vite (second priority)
- Target file: `vite.config.ts`
- Add `build.rollupOptions.output.manualChunks` and group common libraries.

Suggested groups:
- `react-vendor`: react, react-dom
- `router-vendor`: react-router, react-router-dom
- `ui-vendor`: radix, framer-motion, sonner
- `icons-vendor`: fontawesome packages

Expected result:
- Better cache behavior.
- No single huge vendor chunk.

### 3) Keep icon usage minimal (third priority)
- Continue importing only used icons.
- Avoid large icon packs in one barrel import.

Expected result:
- Lower JS size with minimal code change.

## Validation Checklist
1. Run `npm run build`.
2. Confirm main warning is gone or reduced.
3. Compare generated file sizes in `dist/assets`.
4. Verify app routing and loading states still work.

## If Warning Still Appears
- Raise `build.chunkSizeWarningLimit` only after steps 1 and 2 are complete.
- This should be the last step, not the first.

## Definition of Done
- Initial chunk drops below warning threshold, or warning is significantly reduced with justified limit.
- Route navigation works correctly.
- Build remains green.
