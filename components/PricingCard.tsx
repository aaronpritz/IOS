import Link from "next/link";
import { Check, ArrowRight } from "lucide-react";
import { cn, siteConfig } from "@/lib/utils";

type Props = {
  name: string;
  price: string;
  unit: string;
  description: string;
  features: string[];
  cta: string;
  badge?: string;
  featured?: boolean;
};

export default function PricingCard({
  name,
  price,
  unit,
  description,
  features,
  cta,
  badge,
  featured = false,
}: Props) {
  return (
    <article
      className={cn(
        "relative flex h-full flex-col rounded-2xl p-8 shadow-soft transition-all duration-300",
        featured
          ? "border-2 border-terracotta-400 bg-cream-50 shadow-lift lg:-translate-y-2"
          : "border border-sage-100 bg-cream-50 hover:-translate-y-1 hover:shadow-lift"
      )}
      aria-labelledby={`plan-${name.replace(/\s+/g, "-").toLowerCase()}`}
    >
      {badge && (
        <div className="absolute -top-3 left-1/2 -translate-x-1/2">
          <span className="inline-flex items-center rounded-full bg-terracotta-500 px-4 py-1 text-xs font-semibold uppercase tracking-[0.15em] text-cream-50 shadow-soft">
            {badge}
          </span>
        </div>
      )}

      <h3
        id={`plan-${name.replace(/\s+/g, "-").toLowerCase()}`}
        className="text-xl font-semibold text-sage-900"
      >
        {name}
      </h3>

      <div className="mt-5 flex items-baseline gap-2">
        <span className="text-5xl font-semibold tracking-tight text-sage-900">
          {price}
        </span>
        <span className="text-sm text-ink-muted">/ {unit}</span>
      </div>

      <p className="mt-4 text-sm leading-relaxed text-ink-soft">{description}</p>

      <ul className="mt-7 flex-1 space-y-3" aria-label={`${name} features`}>
        {features.map((f) => (
          <li key={f} className="flex items-start gap-3 text-sm text-sage-900">
            <Check
              className={cn(
                "mt-0.5 h-5 w-5 shrink-0",
                featured ? "text-terracotta-500" : "text-sage-600"
              )}
              aria-hidden="true"
            />
            <span>{f}</span>
          </li>
        ))}
      </ul>

      <div className="mt-8">
        <Link
          href={siteConfig.bookingUrl}
          className={cn(
            "w-full",
            featured ? "btn-terracotta" : "btn-primary"
          )}
          aria-label={`${cta} — ${name}`}
        >
          {cta}
          <ArrowRight className="h-4 w-4" aria-hidden="true" />
        </Link>
      </div>
    </article>
  );
}
