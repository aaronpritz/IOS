import Link from "next/link";
import { ArrowRight, Leaf } from "lucide-react";
import { siteConfig } from "@/lib/utils";

export default function Hero() {
  return (
    <section
      className="relative isolate overflow-hidden bg-gradient-to-b from-sage-50 via-cream-100 to-cream-100"
      aria-labelledby="hero-heading"
    >
      {/* Decorative background blobs */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-0 -z-10 overflow-hidden"
      >
        <div className="absolute -left-32 top-10 h-80 w-80 rounded-full bg-sage-200/50 blur-3xl" />
        <div className="absolute -right-20 top-40 h-72 w-72 rounded-full bg-terracotta-100/50 blur-3xl" />
        <div className="absolute inset-0 bg-grain opacity-60" />
      </div>

      <div className="container py-20 md:py-28 lg:py-36">
        <div className="mx-auto max-w-4xl text-center">
          <span className="eyebrow animate-fade-in">
            <Leaf className="h-4 w-4" aria-hidden="true" />
            Indianapolis · Since the quiet dawn
          </span>

          <h1
            id="hero-heading"
            className="mt-6 animate-fade-up text-display-xl text-balance text-sage-900"
          >
            Find Your{" "}
            <span className="italic text-terracotta-600">Contentment</span>.
          </h1>

          <p
            className="mx-auto mt-7 max-w-2xl animate-fade-up text-lg text-pretty text-ink-soft md:text-xl"
            style={{ animationDelay: "120ms" }}
          >
            Santosha is a multidisciplinary yoga and wellness school in the
            heart of Indianapolis — offering affordable classes, Ayurveda,
            bodywork, and Yoga Alliance teacher training for every body and
            every stage of the path.
          </p>

          <div
            className="mt-10 flex animate-fade-up flex-col items-center justify-center gap-3 sm:flex-row"
            style={{ animationDelay: "240ms" }}
          >
            <Link
              href={siteConfig.bookingUrl}
              className="btn-primary w-full sm:w-auto"
              aria-label="Book your first yoga class"
            >
              Book Your First Class
              <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
            <Link
              href="/classes"
              className="btn-secondary w-full sm:w-auto"
              aria-label="View the weekly class schedule"
            >
              View Schedule
            </Link>
          </div>

          <dl className="mx-auto mt-14 grid max-w-2xl animate-fade-in grid-cols-3 gap-4 text-left sm:gap-10">
            <HeroStat label="First month" value="$50" hint="Unlimited classes" />
            <HeroStat label="Community" value="$10" hint="Drop-in rate" />
            <HeroStat label="Yoga Alliance" value="RYT 500" hint="Registered school" />
          </dl>
        </div>
      </div>
    </section>
  );
}

function HeroStat({
  label,
  value,
  hint,
}: {
  label: string;
  value: string;
  hint: string;
}) {
  return (
    <div>
      <dt className="text-[10px] font-semibold uppercase tracking-[0.22em] text-sage-600">
        {label}
      </dt>
      <dd className="mt-1 text-2xl font-semibold text-sage-900 sm:text-3xl">
        {value}
      </dd>
      <dd className="text-xs text-ink-muted">{hint}</dd>
    </div>
  );
}
