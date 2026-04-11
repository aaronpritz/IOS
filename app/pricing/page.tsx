import type { Metadata } from "next";
import Link from "next/link";
import { HandHeart, Info, ArrowRight } from "lucide-react";
import SectionHeading from "@/components/SectionHeading";
import PricingCard from "@/components/PricingCard";

export const metadata: Metadata = {
  title: "Pricing — Memberships & Class Packs",
  description:
    "Affordable Indianapolis yoga pricing at Santosha: $50 first-month unlimited, $90 monthly autopay, class packs from $60, and $10 community classes.",
  alternates: { canonical: "/pricing" },
  openGraph: {
    title: "Pricing | Santosha Indianapolis Yoga",
    description:
      "Transparent, affordable Indianapolis yoga pricing. Class packs, memberships, and $10 community classes.",
    url: "/pricing",
  },
};

const plans = [
  {
    name: "New Member Unlimited",
    price: "$50",
    unit: "first month",
    description:
      "The best way to start. Unlimited classes for your first 30 days — try every style, meet every teacher, and see what clicks.",
    features: [
      "Unlimited classes for 30 days",
      "Access to all class styles",
      "New student welcome session",
      "No commitment after first month",
    ],
    cta: "Start Your First Month",
    badge: "Best Value",
    featured: true,
  },
  {
    name: "Monthly Autopay",
    price: "$90",
    unit: "per month",
    description:
      "Unlimited classes, month after month. Cancel anytime. Our most-loved membership for daily practitioners.",
    features: [
      "Unlimited classes, every month",
      "Early access to workshops",
      "Member pricing on services",
      "Cancel anytime",
    ],
    cta: "Become a Member",
  },
  {
    name: "5-Class Pack",
    price: "$60",
    unit: "5 classes",
    description:
      "Flexibility without commitment. Use any 5 classes at your own pace — great for busy schedules.",
    features: [
      "5 classes, any style",
      "Valid for 6 months",
      "Drop in at any time",
      "Shareable is not permitted",
    ],
    cta: "Buy 5-Class Pack",
  },
  {
    name: "Single Class",
    price: "$20",
    unit: "drop-in",
    description:
      "Just passing through, or testing the waters? Drop in for a single class, no strings attached.",
    features: [
      "One class of your choice",
      "Any style, any teacher",
      "Valid any day we're open",
    ],
    cta: "Drop In",
  },
  {
    name: "20-Class Pack",
    price: "$300",
    unit: "20 classes",
    description:
      "A steady practice at a lower per-class rate. Ideal for students who can't quite commit to unlimited.",
    features: [
      "20 classes — just $15 each",
      "Valid for 12 months",
      "Share with a household member",
      "No monthly charges",
    ],
    cta: "Buy 20-Class Pack",
  },
  {
    name: "100-Class Pack",
    price: "$1,200",
    unit: "100 classes",
    description:
      "Our biggest savings — $12 per class. For truly dedicated practitioners and students planning a full year of practice.",
    features: [
      "100 classes — just $12 each",
      "Valid for 24 months",
      "Includes member workshop pricing",
      "Shareable with one household member",
    ],
    cta: "Buy 100-Class Pack",
  },
];

export default function PricingPage() {
  return (
    <>
      {/* Header */}
      <section className="section-sm bg-cream-100" aria-labelledby="pricing-heading">
        <div className="container max-w-4xl text-center">
          <span className="eyebrow">Pricing</span>
          <h1
            id="pricing-heading"
            className="mt-4 text-display-lg text-balance text-sage-900"
          >
            Transparent pricing. No surprises.
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-pretty">
            We believe yoga should be accessible, so we keep our pricing simple
            and honest. Pick the option that fits your life — you can always
            upgrade later.
          </p>
        </div>
      </section>

      {/* Community class banner */}
      <section aria-label="Community classes" className="pb-4">
        <div className="container">
          <div className="mx-auto flex max-w-4xl items-start gap-4 rounded-2xl border border-terracotta-200 bg-terracotta-50 p-5 md:items-center md:p-6">
            <div
              className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-terracotta-500 text-cream-50"
              aria-hidden="true"
            >
              <HandHeart className="h-5 w-5" />
            </div>
            <div>
              <h2 className="text-base font-semibold text-terracotta-800">
                $10 Community Classes
              </h2>
              <p className="mt-1 text-sm text-ink-soft">
                Several times a week we offer community classes at just{" "}
                <strong className="text-terracotta-800">$10 a session</strong>,
                so no one is turned away by cost. Check the schedule for
                community class times — no membership required.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Plans grid */}
      <section
        className="section-sm bg-cream-100"
        aria-labelledby="plans-heading"
      >
        <div className="container">
          <SectionHeading
            eyebrow="Memberships & Packs"
            title="Pick your plan."
            description="All pricing is in US dollars. Taxes included. No hidden fees."
            id="plans-heading"
            align="center"
          />

          <div className="mt-14 grid gap-6 md:grid-cols-2 lg:grid-cols-3 lg:gap-8">
            {plans.map((plan) => (
              <PricingCard key={plan.name} {...plan} />
            ))}
          </div>
        </div>
      </section>

      {/* FAQ / Fine print */}
      <section
        className="section-sm bg-sage-50 bg-grain"
        aria-labelledby="fine-print-heading"
      >
        <div className="container max-w-3xl">
          <h2
            id="fine-print-heading"
            className="flex items-center gap-3 text-display-md text-sage-900"
          >
            <Info className="h-6 w-6 text-sage-700" aria-hidden="true" />
            Good to know
          </h2>
          <dl className="mt-8 space-y-6">
            <div>
              <dt className="font-semibold text-sage-900">
                Can I freeze my membership?
              </dt>
              <dd className="mt-1 text-ink-soft">
                Yes — monthly autopay members can freeze for up to 2 months per
                year with no fee. Just let us know a week in advance.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-sage-900">
                Do class packs expire?
              </dt>
              <dd className="mt-1 text-ink-soft">
                The 5-class pack is valid for 6 months, the 20-class pack for
                12 months, and the 100-class pack for 24 months from purchase.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-sage-900">
                Is there financial assistance?
              </dt>
              <dd className="mt-1 text-ink-soft">
                Always. Our $10 community classes are open to everyone, no
                questions asked. For students needing deeper support, we offer
                a limited-scholarship membership — please reach out.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-sage-900">
                What about teacher training costs?
              </dt>
              <dd className="mt-1 text-ink-soft">
                Teacher training pricing is separate from class pricing and
                includes tuition, materials, and mentorship. Contact us for the
                current rate and payment plan options.
              </dd>
            </div>
          </dl>
        </div>
      </section>

      {/* CTA */}
      <section className="section-sm bg-cream-100">
        <div className="container max-w-3xl text-center">
          <h2 className="text-display-md text-balance text-sage-900">
            Ready to begin?
          </h2>
          <p className="mt-4 text-pretty">
            Start with our new member special and see how a daily practice can
            change your life.
          </p>
          <div className="mt-7 flex flex-wrap justify-center gap-3">
            <Link href="/contact" className="btn-primary">
              Start First Month — $50
              <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
            <Link href="/classes" className="btn-secondary">
              See the Schedule
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
