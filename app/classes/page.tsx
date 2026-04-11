import type { Metadata } from "next";
import { Flame, Wind, Waves, Moon, Sun, Sprout } from "lucide-react";
import SectionHeading from "@/components/SectionHeading";
import ClassScheduleFilter from "@/components/ClassScheduleFilter";

export const metadata: Metadata = {
  title: "Yoga Classes & Schedule",
  description:
    "Browse our weekly yoga class schedule in Indianapolis. Vinyasa, Hatha, Restorative, Yin, and affordable community classes — taught by certified, experienced instructors.",
  alternates: { canonical: "/classes" },
  openGraph: {
    title: "Yoga Classes & Schedule | Santosha Indianapolis",
    description:
      "Affordable Indianapolis yoga — Vinyasa, Hatha, Yin, Restorative, and community classes.",
    url: "/classes",
  },
};

const classTypes = [
  {
    icon: Flame,
    name: "Vinyasa",
    level: "All Levels",
    description:
      "A dynamic, breath-led flow that builds strength, flexibility, and focus. Expect steady movement, creative sequencing, and a strong finish.",
  },
  {
    icon: Sprout,
    name: "Hatha",
    level: "Beginner → Intermediate",
    description:
      "Traditional postures held with precision and intention. The foundation from which all modern yoga grows — perfect for building your base.",
  },
  {
    icon: Waves,
    name: "Yin",
    level: "All Levels",
    description:
      "Long, quiet holds that open the deep connective tissues. A meditative practice that teaches you how to soften and stay.",
  },
  {
    icon: Moon,
    name: "Restorative",
    level: "All Levels",
    description:
      "Fully supported postures with bolsters and blankets. The nervous system resets, the breath deepens, and the body finally rests.",
  },
  {
    icon: Sun,
    name: "Ashtanga",
    level: "Intermediate",
    description:
      "The traditional, set sequence practiced in the Mysore lineage. Disciplined, rigorous, and deeply transformative over time.",
  },
  {
    icon: Wind,
    name: "Pranayama & Meditation",
    level: "All Levels",
    description:
      "Breathwork and seated meditation practices drawn directly from classical yoga texts. The subtle practice that changes everything.",
  },
];

export default function ClassesPage() {
  return (
    <>
      {/* Page header */}
      <section className="section-sm bg-cream-100" aria-labelledby="classes-heading">
        <div className="container max-w-4xl text-center">
          <span className="eyebrow">Classes & Schedule</span>
          <h1
            id="classes-heading"
            className="mt-4 text-display-lg text-balance text-sage-900"
          >
            Affordable Indianapolis yoga, seven days a week.
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-pretty">
            From sunrise Vinyasa to candlelit Yin, our weekly schedule is built
            around the rhythms of real life in Indianapolis. Drop in, try a new
            style, or commit to a daily practice — every class is taught by
            certified instructors and welcomes every body.
          </p>
        </div>
      </section>

      {/* Class types */}
      <section
        className="section bg-sage-50 bg-grain"
        aria-labelledby="class-types-heading"
      >
        <div className="container">
          <SectionHeading
            eyebrow="Class types"
            title="Find the practice that meets you where you are."
            description="Not sure where to start? Hatha and Restorative are our most beginner-friendly offerings. Our front desk is always happy to help you choose."
            id="class-types-heading"
          />

          <div className="mt-14 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {classTypes.map((c) => {
              const Icon = c.icon;
              return (
                <article
                  key={c.name}
                  className="card-lift"
                  aria-labelledby={`class-${c.name}`}
                >
                  <div className="mb-5 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-sage-100 text-sage-700">
                    <Icon className="h-6 w-6" aria-hidden="true" />
                  </div>
                  <h3
                    id={`class-${c.name}`}
                    className="text-xl font-semibold text-sage-900"
                  >
                    {c.name}
                  </h3>
                  <div className="mt-1 text-xs font-medium uppercase tracking-[0.15em] text-terracotta-600">
                    {c.level}
                  </div>
                  <p className="mt-4 text-sm leading-relaxed text-ink-soft">
                    {c.description}
                  </p>
                </article>
              );
            })}
          </div>
        </div>
      </section>

      {/* Schedule */}
      <section className="section bg-cream-100" aria-labelledby="schedule-heading">
        <div className="container">
          <SectionHeading
            eyebrow="Weekly schedule"
            title="This week at the studio."
            description="Filter by day or style to find your next class. Class times are posted one week in advance and may shift slightly with holidays."
            id="schedule-heading"
          />

          <div className="mt-12">
            <ClassScheduleFilter />
          </div>
        </div>
      </section>

      {/* SEO copy block */}
      <section
        className="section-sm bg-sage-800 text-cream-50"
        aria-labelledby="seo-heading"
      >
        <div className="container max-w-3xl text-center">
          <h2
            id="seo-heading"
            className="text-display-md text-balance text-cream-50"
          >
            Affordable yoga in the heart of Indianapolis.
          </h2>
          <p className="mt-5 text-pretty text-cream-100/90">
            Santosha is one of the most affordable yoga studios in Indianapolis,
            offering $10 community classes, discounted class packs, and a
            first-month unlimited special for new members. Located just off
            Cedar Place Drive near Keystone, our Indianapolis yoga studio
            welcomes students from Broad Ripple, Carmel, Meridian-Kessler, Nora,
            and Castleton. Come drop in, meet our teachers, and find out why
            Santosha is Indianapolis&apos;s favorite neighborhood yoga school.
          </p>
        </div>
      </section>
    </>
  );
}
