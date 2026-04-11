import type { Metadata } from "next";
import Link from "next/link";
import {
  Leaf,
  HeartPulse,
  Stars,
  CalendarDays,
  ArrowRight,
  Clock,
  CircleDollarSign,
} from "lucide-react";
import SectionHeading from "@/components/SectionHeading";

export const metadata: Metadata = {
  title: "Wellness Services — Ayurveda, Bodywork & Jyotish",
  description:
    "Ayurvedic consultations, therapeutic bodywork, Vedic astrology readings, and wellness workshops at Santosha in Indianapolis — integrative care rooted in tradition.",
  alternates: { canonical: "/services" },
  openGraph: {
    title: "Wellness Services | Santosha Indianapolis",
    description:
      "Ayurveda, bodywork, and Jyotish readings from certified practitioners in Indianapolis.",
    url: "/services",
  },
};

type Service = {
  id: string;
  icon: typeof Leaf;
  title: string;
  subtitle: string;
  description: string;
  details: string[];
  duration: string;
  note?: string;
};

const services: Service[] = [
  {
    id: "ayurveda",
    icon: Leaf,
    title: "Ayurvedic Consultations",
    subtitle: "Personalized wellness, rooted in 5,000 years of tradition.",
    description:
      "Ayurveda is yoga's sister science — a complete system of health that treats each person as a unique individual. In a consultation, we'll look at your constitution (dosha), current imbalances, lifestyle, and goals, then build a personalized plan of diet, daily routine, and herbal support.",
    details: [
      "Dosha and prakriti assessment",
      "Pulse and tongue evaluation",
      "Personalized daily routine (dinacharya)",
      "Food and lifestyle recommendations",
      "Herbal and supplement guidance",
    ],
    duration: "75 min initial · 45 min follow-up",
  },
  {
    id: "bodywork",
    icon: HeartPulse,
    title: "Therapeutic Bodywork",
    subtitle: "Hands-on care informed by yoga and Ayurveda.",
    description:
      "Our bodywork sessions integrate therapeutic massage with traditional Ayurvedic techniques like abhyanga (warm oil massage) and marma point therapy. Whether you're recovering from injury, managing chronic tension, or simply need to rest deeply, our practitioners meet you where you are.",
    details: [
      "Abhyanga (Ayurvedic warm oil massage)",
      "Marma point therapy",
      "Therapeutic deep tissue",
      "Yoga-informed alignment work",
      "Restorative nervous-system sessions",
    ],
    duration: "60 or 90 min sessions",
  },
  {
    id: "jyotish",
    icon: Stars,
    title: "Vedic Astrology (Jyotish)",
    subtitle: "Jyotish readings — the light of the Vedas.",
    description:
      "Jyotish, the traditional Vedic system of astrology, is a contemplative tool for understanding your life's rhythms, timing, and deeper patterns. Our readings are not about prediction — they're about clarity, and how to walk your own path with greater awareness.",
    details: [
      "Birth chart (janma kundali) reading",
      "Current planetary period (dasha) analysis",
      "Life timing and transitions",
      "Relationship and compatibility readings",
      "Recorded sessions for your review",
    ],
    duration: "60 or 90 min sessions",
    note: "Birth time, date, and location required for accurate charts.",
  },
  {
    id: "workshops",
    icon: CalendarDays,
    title: "Workshops & Retreats",
    subtitle: "Deeper dives throughout the year.",
    description:
      "Throughout the year we host workshops and short retreats on topics like meditation, pranayama, Ayurvedic cooking, yoga philosophy, and seasonal cleanses. Workshops are a wonderful way to meet other students and go deeper than a drop-in class allows.",
    details: [
      "Weekend intensives",
      "Seasonal Ayurvedic cleanses",
      "Philosophy and sutra study circles",
      "Guest teacher series",
      "Day-long silent practice",
    ],
    duration: "Varies by offering",
    note: "Workshop calendar updated monthly — check back or join our email list.",
  },
];

export default function ServicesPage() {
  return (
    <>
      {/* Header */}
      <section className="section-sm bg-cream-100" aria-labelledby="services-heading">
        <div className="container max-w-4xl text-center">
          <span className="eyebrow">Wellness Services</span>
          <h1
            id="services-heading"
            className="mt-4 text-display-lg text-balance text-sage-900"
          >
            Integrative care, taught by the tradition.
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-pretty">
            Beyond the mat, Santosha offers a full suite of wellness services
            rooted in the classical Vedic sciences — Ayurveda, bodywork, and
            Jyotish — alongside workshops that go deeper than any single class
            can.
          </p>
        </div>
      </section>

      {/* Services list */}
      <section className="section bg-sage-50 bg-grain" aria-label="Services">
        <div className="container space-y-20 lg:space-y-28">
          {services.map((service, idx) => {
            const Icon = service.icon;
            const reversed = idx % 2 === 1;
            return (
              <article
                key={service.id}
                id={service.id}
                className="scroll-mt-28"
                aria-labelledby={`svc-${service.id}`}
              >
                <div
                  className={`grid gap-10 lg:grid-cols-2 lg:items-center lg:gap-16 ${
                    reversed ? "lg:[&>div:first-child]:order-2" : ""
                  }`}
                >
                  <div>
                    <div className="mb-5 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-sage-100 text-sage-700">
                      <Icon className="h-7 w-7" aria-hidden="true" />
                    </div>
                    <h2
                      id={`svc-${service.id}`}
                      className="text-display-md text-balance text-sage-900"
                    >
                      {service.title}
                    </h2>
                    <p className="mt-2 text-base font-medium italic text-sage-700">
                      {service.subtitle}
                    </p>
                    <p className="mt-5 text-pretty">{service.description}</p>
                    <div className="mt-6 flex flex-wrap gap-x-6 gap-y-2 text-sm text-sage-800">
                      <span className="inline-flex items-center gap-2">
                        <Clock className="h-4 w-4" aria-hidden="true" />
                        {service.duration}
                      </span>
                      <span className="inline-flex items-center gap-2">
                        <CircleDollarSign className="h-4 w-4" aria-hidden="true" />
                        Contact for pricing
                      </span>
                    </div>
                    {service.note && (
                      <p className="mt-4 rounded-xl border border-sage-200 bg-cream-50 p-3 text-xs text-sage-700">
                        {service.note}
                      </p>
                    )}
                    <div className="mt-7">
                      <Link href="/contact" className="btn-primary">
                        Book {service.title.split(" ")[0]}
                        <ArrowRight className="h-4 w-4" aria-hidden="true" />
                      </Link>
                    </div>
                  </div>

                  <div>
                    <div className="card">
                      <h3 className="text-xs font-semibold uppercase tracking-[0.2em] text-sage-700">
                        What&apos;s included
                      </h3>
                      <ul className="mt-5 space-y-3">
                        {service.details.map((d) => (
                          <li
                            key={d}
                            className="flex items-start gap-3 text-sage-900"
                          >
                            <span
                              aria-hidden="true"
                              className="mt-2 inline-block h-1.5 w-1.5 shrink-0 rounded-full bg-terracotta-500"
                            />
                            <span className="text-sm leading-relaxed">{d}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              </article>
            );
          })}
        </div>
      </section>

      {/* Bottom CTA */}
      <section className="section-sm bg-cream-100">
        <div className="container max-w-3xl rounded-3xl bg-sage-800 p-10 text-center text-cream-50 shadow-lift md:p-14">
          <h2 className="text-display-md text-balance text-cream-50">
            Not sure where to start?
          </h2>
          <p className="mx-auto mt-4 max-w-xl text-cream-100/90">
            Send us a message describing what&apos;s going on, and we&apos;ll help
            you choose the service that fits best. There&apos;s no pressure, and
            no wrong door.
          </p>
          <div className="mt-7 flex flex-wrap justify-center gap-3">
            <Link
              href="/contact"
              className="btn bg-cream-50 text-sage-900 hover:bg-cream-200"
            >
              Contact Us
              <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
            <Link
              href="/pricing"
              className="btn border border-cream-50 text-cream-50 hover:bg-cream-50 hover:text-sage-900"
            >
              See Class Pricing
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
