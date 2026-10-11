# GAME ZONE — new project starter
Owner: Bittu | Developer: Nodit

This is a Next.js + Supabase project intended for Vercel hosting. It includes a responsive neon gaming UI, voice intro, PS3/PS4 game catalog, phone OTP UI, booking APIs, PostgreSQL overlap protection, booking history and a restricted admin dashboard.

## Important: this is a starter, not yet verified production software
The files have been generated but have NOT been installed, built, deployed or end-to-end tested in this environment. Treat every feature as unverified until you run the tests below. Real SMS needs provider setup. Do not accept real customer bookings until tested.

## Phone setup (no local computer required)
1. Create a Supabase project at https://supabase.com and open SQL Editor.
2. Open `supabase/schema.sql`, copy all SQL, paste it in SQL Editor and run it. Check for any SQL error.
3. In Supabase Project Settings > API, copy Project URL, anon/publishable key, and service_role/secret key. Keep the service role key private.
4. In Supabase Authentication > Providers > Phone, enable phone auth and configure an SMS provider. Configure OTP expiry/rate limits. Provider credentials are required for actual SMS delivery and may cost money. Follow current Supabase/Twilio provider instructions for your project region.
5. Create a GitHub repository and upload all files/folders in this project. Do not upload `.env` or secrets.
6. Import that repository into Vercel. Add these Environment Variables in Vercel Project Settings > Environment Variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY` (server-only secret; never prefix with NEXT_PUBLIC)
   - `ADMIN_PHONE_1` (first admin verified phone in E.164 format, e.g. +919876543210)
   - `ADMIN_PHONE_2` (second different admin verified phone in E.164 format)
7. Redeploy after setting variables. Do NOT use NEXT_PUBLIC_ADMIN_PHONE variables. Admin allowlist is checked server-side only.
8. Open the deployed URL and test the checklist below before real use.

## Local development
Install Node.js 20+ and run:
`npm install`
`cp .env.example .env.local` (fill real values)
`npm run dev`
For a production compile: `npm run build` then `npm start`.

## Current features implemented in code
- Dark neon responsive landing page, animated welcome intro and browser speech synthesis.
- PS3/PS4-compatible game catalog, configurable rates, opening/closing times, offers and brand fields.
- Supabase phone OTP request/verification UI.
- Booking form asks name and phone manually even after login.
- Server-side price calculation, compatibility check, opening-hours validation, future time validation and booking persistence.
- PostgreSQL exclusion constraint prevents overlapping pending/confirmed bookings on the same physical console unit.
- Customer booking history and cancellation of eligible pending bookings.
- Admin routes verify authenticated phone against exactly two distinct server environment phone values.
- Admin dashboard: booking status changes, rates/branding/hours/offers, add/deactivate games, add console units and delete cancelled/completed history.
- RLS denies direct browser table access; data routes use server-only service role key.

## Known limitations / not yet verified
- No successful `npm install`, `npm run build`, browser test or deployed test has been run for this generated project. API and UI may need fixes found by the compiler/runtime.
- Supabase phone provider and real SMS delivery are NOT configured by this code; configure and verify them in Supabase.
- Business date/time parsing is currently fixed to India Standard Time (UTC+05:30), suitable for Kurkheda, Maharashtra. If the business moves, make timezone configurable and test daylight-saving behavior.
- The starter seeds one PS3 and one PS4 physical unit. Add the actual number of physical consoles from Admin. Each unit is independently bookable.
- Game cover URLs are optional; default cards use generated styling, not licensed game artwork. Only use images you have permission to use.
- Customer notification SMS after booking is not implemented. OTP SMS is separate from booking confirmation messages.
- No online payment integration, automatic reminders, email receipts, multi-day bookings, recurring opening hours, or business holiday calendar.
- Discount is a global percentage, not per-game/per-time offer targeting.
- Admin can add games and console units, but this first version does not offer editing an existing game's details or deactivating a console unit from the UI.
- Booking history deletion permanently deletes only cancelled/completed rows; pending and confirmed rows are intentionally protected by this UI action.
- Exactly two admin phone values must be configured and unique. If they are missing or identical, no phone receives admin access. Verify both numbers with SMS OTP before testing admin login.
- SQL exclusion constraint requires PostgreSQL extension `btree_gist`. The schema enables it; if Supabase reports a permission/extension error, resolve it in Database > Extensions before using booking.
- `next lint` may not exist in some Next.js 15 setups; use `npm run build` as the primary static check or replace lint script with ESLint config.

## Minimum test checklist
1. Run `npm install` and `npm run build`; fix all errors before deploy.
2. Confirm `GET /api/public` returns settings, games and units after SQL setup.
3. Test SMS OTP on a real phone and confirm invalid/expired OTP fails.
4. Try booking without login (must fail), then login and create a future booking.
5. Try the same unit and overlapping time twice from two accounts/devices; second booking must fail.
6. Try a game with incompatible console; server must reject it.
7. Test opening hours, 1/2-hour prices and discount calculations.
8. Confirm a customer can only see their own booking history and cannot cancel another user's booking.
9. Sign in with each of the two admin numbers and verify admin dashboard works.
10. Sign in with a third number and verify admin API returns 403.
11. Confirm admin price/game changes persist after refresh and redeploy.
12. Confirm cancelled/completed history deletion requires typing `DELETE HISTORY`.
13. Test mobile widths and all buttons; inspect Vercel logs and Supabase logs for errors.
14. Do not go live until backups, privacy notice, business timezone and provider configuration are confirmed.
