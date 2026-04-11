import type { Metadata } from "next";
import Link from "next/link";
import {
  Flower2,
  Leaf,
  HeartPulse,
  Sparkles,
  GraduationCap,
  Users,
  BadgeCheck,
  HandHeart,
  ArrowRight,
} from "lucide-react";
import Hero from "@/components/Hero";
import SectionHeading from "@/components/SectionHeading";
import ServiceCard from "@/components/ServiceCard";
import ValueCard from "@/components/ValueCard";

export const metadata: Metadata = {
  title: "Indianapolis Yoga Studio, Ayurveda & Wellness School",
  description:
    "Santosha is an Indianapolis yoga studio and wellness school offering affordable classes, Ayurveda, bodywork, Jyotish readings, and Yoga Alliance teacher training. Find your contentment.",
  alternates: { canonical: "/" },
  openGraph: {
    title: "Santosha — Find Your Contentment in Indianapolis",
    description:
      "Affordable yoga, Ayurveda, bodywork, and teacher training at Santosha School in Indianapolis.",
    url: "/",
  },
};

export default function HomePage() {
  return (
    <>
      <Hero />

      {/* School + Studio identity */}
      <section className="section bg-cream-100" aria-labelledby="identity-heading">
        <div className="container grid gap-12 lg:grid-cols-2 lg:items-center lg:gap-20">
          <div className="space-y-6">
            <span className="eyebrow">
              <Flower2 className="h-4 w-4" aria-hidden="true" />
              A school. A studio. A sanctuary.
            </span>
            <h2
              id="identity-heading"
              className="text-display-lg text-balance text-sage-900"
            >
              More than a yoga studio — a home for the whole practice.
            </h2>
            <p className="text-lg text-pretty">
              Santosha means <em className="text-sage-800">contentment</em>: the
              quiet, steady joy that comes from returning to yourself. We built
              Santosha as both a studio where you can drop in for a class and a
              school where you can go deeper — into Ayurveda, bodywork, and the
              centuries-old lineage of yoga.
            </p>
            <p className="text-lg text-pretty">
              Whether you&apos;re new to the mat or walking the path toward
              teaching, you&apos;ll find a welcoming, inclusive community in the
              heart of Indianapolis.
            </p>
            <div className="flex flex-wrap gap-3 pt-2">
              <Link href="/classes" className="btn-primary">
                Explore Classes
                <ArrowRight className="h-4 w-4" aria-hidden="true" />
              </Link>
              <Link href="/teacher-training" className="btn-secondary">
                Teacher Training
              </Link>
            </div>
          </div>

          <div className="relative">
            <div className="absolute -inset-6 rounded-3xl bg-sage-100/60 blur-2xl" aria-hidden="true" />
            <div className="relative grid gap-4 rounded-3xl bg-cream-50 p-6 shadow-lift ring-1 ring-sage-100 sm:p-8">
              <div className="grid grid-cols-3 gap-4 text-center">
                <Stat value="200+" label="Hours of training" />
                <Stat value="4" label="Disciplines" />
                <Stat value="$10" label="Community classes" />
              </div>
              <div className="divider-leaf pt-2">
                <Leaf className="h-4 w-4" aria-hidden="true" />
              </div>
              <blockquote className="text-pretty text-center text-sage-800">
                <p className="italic leading-relaxed">
                  &ldquo;Santosha — contentment — is found not in what we
                  acquire, but in what we release.&rdquo;
                </p>
                <footer className="mt-3 text-xs uppercase tracking-[0.25em] text-sage-600">
                  — Yoga Sutras, 2.42
                </footer>
              </blockquote>
            </div>
          </div>
        </div>
      </section>

      {/* Services grid */}
      <section
        className="section bg-sage-50 bg-grain"
        aria-labelledby="services-heading"
      >
        <div className="container">
          <SectionHeading
            eyebrow="What we offer"
            title="Three paths. One practice."
            description="Our disciplines are designed to complement each other — each one a doorway into the same quiet center."
            id="services-heading"
          />

          <div className="mt-14 grid gap-6 md:grid-cols-3 md:gap-8">
            <ServiceCard
              icon={Flower2}
              title="Yoga"
              description="Daily classes for every body and every level — from gentle restorative to vigorous vinyasa, all grounded in tradition."
              href="/classes"
              linkLabel="View schedule"
            />
            <ServiceCard
              icon={Leaf}
              title="Ayurveda"
              description="Personalized Ayurvedic consultations that honor your unique constitution and bring your daily rhythms back into balance."
              href="/services"
              linkLabel="Book a consultation"
            />
            <ServiceCard
              icon={HeartPulse}
              title="Bodywork"
              description="Therapeutic bodywork rooted in yogic and Ayurvedic principles — a hands-on path to release, recover, and reset."
              href="/services"
              linkLabel="Explore bodywork"
            />
          </div>
        </div>
      </section>

      {/* Brand values */}
      <section className="section bg-cream-100" aria-labelledby="values-heading">
        <div className="container">
          <SectionHeading
            eyebrow="Our values"
            title="A practice built on four pillars."
            description="We believe wellness should be accessible, excellent, and rooted in real community."
            id="values-heading"
            align="center"
          />

          <div className="mt-14 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            <ValueCard
              icon={HandHeart}
              title="Affordable"
              description="From $10 community classes to sliding-scale workshops, we believe yoga belongs to everyone."
            />
            <ValueCard
              icon={Users}
              title="Community"
              description="A welcoming sangha where you&apos;ll be known by name, not by mat number."
            />
            <ValueCard
              icon={BadgeCheck}
              title="Certified"
              description="Yoga Alliance registered teachers and programs at the RYT200, RYT300, and RYT500 levels."
            />
            <ValueCard
              icon={Sparkles}
              title="Quality"
              description="Traditionally rooted, thoughtfully taught — no shortcuts, no trends, just the practice."
            />
          </div>
        </div>
      </section>

      {/* Teacher training CTA band */}
      <section
        className="section-sm bg-sage-800 text-cream-50"
        aria-labelledby="training-cta-heading"
      >
        <div className="container grid items-center gap-8 lg:grid-cols-[1.5fr_1fr]">
          <div>
            <span className="eyebrow text-sage-200">
              <GraduationCap className="h-4 w-4" aria-hidden="true" />
              Teacher Training
            </span>
            <h2
              id="training-cta-heading"
              className="mt-3 text-display-md text-balance text-cream-50"
            >
              Train with us. Teach with confidence.
            </h2>
            <p className="mt-4 max-w-2xl text-cream-100/90">
              Our Yoga Alliance registered RYT200, RYT300, and RYT500 programs
              are designed to build skilled, grounded, and deeply knowledgeable
              teachers. Applications open year-round.
            </p>
          </div>
          <div className="flex flex-wrap gap-3 lg:justify-end">
            <Link
              href="/teacher-training"
              className="btn bg-cream-50 text-sage-900 hover:bg-cream-200"
            >
              View Programs
              <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
            <Link
              href="/contact"
              className="btn border border-cream-50 text-cream-50 hover:bg-cream-50 hover:text-sage-900"
            >
              Inquire
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}

function Stat({ value, label }: { value: string; label: string }) {
  return (
    <div>
      <div className="text-3xl font-semibold text-sage-800 sm:text-4xl">
        {value}
      </div>
      <div className="mt-1 text-xs uppercase tracking-[0.18em] text-sage-600">
        {label}
      </div>
    </div>
  );
}
