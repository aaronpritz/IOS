import type { Metadata } from "next";
import Link from "next/link";
import {
  GraduationCap,
  BookOpen,
  Users,
  Sparkles,
  ArrowRight,
  Download,
  CheckCircle2,
  ScrollText,
  HeartPulse,
} from "lucide-react";
import SectionHeading from "@/components/SectionHeading";

export const metadata: Metadata = {
  title: "Yoga Teacher Training — RYT200, RYT300 & RYT500",
  description:
    "Yoga Alliance registered teacher training in Indianapolis. Santosha offers RYT200, RYT300, and RYT500 programs — traditionally rooted, thoughtfully taught.",
  alternates: { canonical: "/teacher-training" },
  openGraph: {
    title: "Yoga Teacher Training | Santosha Indianapolis",
    description:
      "RYT200, RYT300, and RYT500 yoga teacher training programs in Indianapolis.",
    url: "/teacher-training",
  },
};

type Program = {
  id: string;
  level: "RYT 200" | "RYT 300" | "RYT 500";
  title: string;
  hours: string;
  length: string;
  description: string;
  curriculum: string[];
  outcomes: string[];
  featured?: boolean;
};

const programs: Program[] = [
  {
    id: "ryt200",
    level: "RYT 200",
    title: "Foundation Teacher Training",
    hours: "200 hours",
    length: "9 months · weekend format",
    description:
      "Our RYT200 is the doorway into teaching. You'll build a rock-solid foundation in asana, anatomy, philosophy, and the art of teaching — everything you need to lead your first classes with confidence.",
    curriculum: [
      "Asana technique, alignment, and modifications",
      "Functional anatomy and biomechanics",
      "Yoga history and classical philosophy (Sutras, Gita)",
      "Pranayama and meditation foundations",
      "Sanskrit pronunciation and key terminology",
      "Sequencing, cueing, and class design",
      "Teaching methodology and practicum",
    ],
    outcomes: [
      "Yoga Alliance RYT 200 eligibility",
      "Confidence to teach a complete 60-minute class",
      "A personal daily practice",
      "A community of co-trainees for life",
    ],
    featured: true,
  },
  {
    id: "ryt300",
    level: "RYT 300",
    title: "Advanced Teacher Training",
    hours: "300 hours",
    length: "12 months · modular format",
    description:
      "Designed for RYT200 graduates ready to deepen. The 300 is where philosophy, subtle body, therapeutic application, and advanced teaching craft all come together. Modular so you can train at your own pace.",
    curriculum: [
      "Advanced asana, pranayama, and meditation",
      "Subtle body: chakras, nadis, koshas",
      "Therapeutic yoga and common conditions",
      "Trauma-informed teaching",
      "Ayurvedic principles for yoga teachers",
      "Advanced philosophy and sutra study",
      "Mentorship and teaching intensive",
    ],
    outcomes: [
      "Yoga Alliance RYT 500 eligibility (combined with RYT200)",
      "Tools to work with specialized populations",
      "A clear personal teaching voice",
      "Expanded scope of practice",
    ],
  },
  {
    id: "ryt500",
    level: "RYT 500",
    title: "Full RYT 500 Pathway",
    hours: "500 hours total",
    length: "21 months · combined",
    description:
      "The complete path: take our RYT200 followed by the RYT300 as a single, integrated journey. Graduates leave as confident, well-rounded teachers grounded in both the classical tradition and contemporary teaching skills.",
    curriculum: [
      "All RYT200 foundation content",
      "All RYT300 advanced content",
      "Integrated mentorship throughout",
      "Final teaching intensive and review",
    ],
    outcomes: [
      "Full Yoga Alliance RYT 500 eligibility",
      "Deep philosophical and practical grounding",
      "Readiness to lead workshops, immersions, and retreats",
      "Lifetime alumni community",
    ],
  },
];

const pillars = [
  {
    icon: ScrollText,
    title: "Rooted in tradition",
    description:
      "We teach directly from the classical texts — the Yoga Sutras, the Hatha Yoga Pradipika, the Bhagavad Gita — not secondhand summaries.",
  },
  {
    icon: Users,
    title: "Small cohorts",
    description:
      "Trainings cap at 16 students. You'll be mentored by name, not lost in a crowd.",
  },
  {
    icon: HeartPulse,
    title: "Trauma-informed",
    description:
      "All our programs include trauma-informed teaching modules. You'll leave prepared to hold space for every kind of student.",
  },
  {
    icon: Sparkles,
    title: "Yoga Alliance registered",
    description:
      "Santosha is a Yoga Alliance RYS (Registered Yoga School) at the 200, 300, and 500 hour levels.",
  },
];

export default function TeacherTrainingPage() {
  return (
    <>
      {/* Header */}
      <section className="section-sm bg-cream-100" aria-labelledby="tt-heading">
        <div className="container max-w-4xl text-center">
          <span className="eyebrow">
            <GraduationCap className="h-4 w-4" aria-hidden="true" />
            Professional Training
          </span>
          <h1
            id="tt-heading"
            className="mt-4 text-display-lg text-balance text-sage-900"
          >
            Become the teacher your students deserve.
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-pretty">
            Our Yoga Alliance registered teacher training programs are built
            for the long game: not weekend certifications, but real
            transformation. Whether you want to teach, deepen your own
            practice, or both — Santosha will meet you with rigor, warmth, and
            tradition.
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Link href="/contact" className="btn-primary">
              Inquire About Training
              <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
            <Link href="/contact" className="btn-secondary">
              <Download className="h-4 w-4" aria-hidden="true" />
              Download Info Guide
            </Link>
          </div>
        </div>
      </section>

      {/* Pillars */}
      <section
        className="section-sm bg-sage-50 bg-grain"
        aria-labelledby="pillars-heading"
      >
        <div className="container">
          <h2 id="pillars-heading" className="sr-only">
            Our approach
          </h2>
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {pillars.map((p) => {
              const Icon = p.icon;
              return (
                <div key={p.title} className="card">
                  <div className="mb-4 inline-flex h-11 w-11 items-center justify-center rounded-xl bg-sage-100 text-sage-700">
                    <Icon className="h-5 w-5" aria-hidden="true" />
                  </div>
                  <h3 className="text-lg font-semibold text-sage-900">
                    {p.title}
                  </h3>
                  <p className="mt-2 text-sm leading-relaxed text-ink-soft">
                    {p.description}
                  </p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Programs */}
      <section className="section bg-cream-100" aria-labelledby="programs-heading">
        <div className="container">
          <SectionHeading
            eyebrow="Programs"
            title="Three paths into teaching."
            description="Every program includes mentorship, lifetime alumni access, and graduation with a traditional ceremony."
            id="programs-heading"
          />

          <div className="mt-14 space-y-10 lg:space-y-14">
            {programs.map((program) => (
              <article
                key={program.id}
                id={program.id}
                className={`scroll-mt-28 rounded-3xl border bg-cream-50 p-8 shadow-soft md:p-12 ${
                  program.featured
                    ? "border-terracotta-300 ring-1 ring-terracotta-200"
                    : "border-sage-100"
                }`}
                aria-labelledby={`program-${program.id}`}
              >
                <div className="flex flex-wrap items-start justify-between gap-4">
                  <div>
                    <div className="flex items-center gap-3">
                      <span className="inline-flex items-center rounded-full bg-sage-700 px-3 py-1 text-xs font-semibold uppercase tracking-[0.15em] text-cream-50">
                        {program.level}
                      </span>
                      {program.featured && (
                        <span className="inline-flex items-center rounded-full bg-terracotta-500 px-3 py-1 text-xs font-semibold uppercase tracking-[0.15em] text-cream-50">
                          Most Popular
                        </span>
                      )}
                    </div>
                    <h3
                      id={`program-${program.id}`}
                      className="mt-4 text-display-md text-sage-900"
                    >
                      {program.title}
                    </h3>
                    <div className="mt-2 text-sm text-sage-700">
                      <span className="font-semibold">{program.hours}</span>
                      {" · "}
                      <span>{program.length}</span>
                    </div>
                  </div>
                  <Link
                    href="/contact"
                    className="btn-primary shrink-0"
                    aria-label={`Apply to ${program.level} ${program.title}`}
                  >
                    Apply Now
                    <ArrowRight className="h-4 w-4" aria-hidden="true" />
                  </Link>
                </div>

                <p className="mt-6 max-w-3xl text-pretty">{program.description}</p>

                <div className="mt-10 grid gap-10 md:grid-cols-2">
                  <div>
                    <h4 className="flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.2em] text-sage-700">
                      <BookOpen className="h-4 w-4" aria-hidden="true" />
                      Curriculum
                    </h4>
                    <ul className="mt-5 space-y-3">
                      {program.curriculum.map((c) => (
                        <li key={c} className="flex items-start gap-3">
                          <CheckCircle2
                            className="mt-0.5 h-5 w-5 shrink-0 text-sage-600"
                            aria-hidden="true"
                          />
                          <span className="text-sm leading-relaxed text-sage-900">
                            {c}
                          </span>
                        </li>
                      ))}
                    </ul>
                  </div>
                  <div>
                    <h4 className="flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.2em] text-sage-700">
                      <Sparkles className="h-4 w-4" aria-hidden="true" />
                      What you leave with
                    </h4>
                    <ul className="mt-5 space-y-3">
                      {program.outcomes.map((o) => (
                        <li key={o} className="flex items-start gap-3">
                          <CheckCircle2
                            className="mt-0.5 h-5 w-5 shrink-0 text-terracotta-500"
                            aria-hidden="true"
                          />
                          <span className="text-sm leading-relaxed text-sage-900">
                            {o}
                          </span>
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>

      {/* Bottom CTA */}
      <section className="section-sm bg-sage-800 text-cream-50">
        <div className="container max-w-3xl text-center">
          <h2 className="text-display-md text-balance text-cream-50">
            Have questions? We love them.
          </h2>
          <p className="mx-auto mt-5 max-w-2xl text-cream-100/90">
            Training is a major commitment. Reach out and we&apos;ll set up a
            free call with our lead trainer to talk through your goals and
            answer anything you&apos;d like to know.
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Link
              href="/contact"
              className="btn bg-cream-50 text-sage-900 hover:bg-cream-200"
            >
              Schedule a Call
              <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
            <Link
              href="/contact"
              className="btn border border-cream-50 text-cream-50 hover:bg-cream-50 hover:text-sage-900"
            >
              <Download className="h-4 w-4" aria-hidden="true" />
              Download Info Guide
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
