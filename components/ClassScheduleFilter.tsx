"use client";

import { useMemo, useState } from "react";
import { Clock, User, Tag } from "lucide-react";
import { cn } from "@/lib/utils";

type ClassEntry = {
  id: string;
  day: Day;
  time: string;
  name: string;
  style: Style;
  teacher: string;
  length: string;
  level: string;
  community?: boolean;
};

type Day =
  | "Monday"
  | "Tuesday"
  | "Wednesday"
  | "Thursday"
  | "Friday"
  | "Saturday"
  | "Sunday";

type Style =
  | "Vinyasa"
  | "Hatha"
  | "Yin"
  | "Restorative"
  | "Ashtanga"
  | "Pranayama";

const DAYS: Day[] = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

const STYLES: Style[] = [
  "Vinyasa",
  "Hatha",
  "Yin",
  "Restorative",
  "Ashtanga",
  "Pranayama",
];

// Placeholder schedule — replace teacher names and times with live data when available.
const SCHEDULE: ClassEntry[] = [
  { id: "m1", day: "Monday", time: "6:00 AM", name: "Sunrise Vinyasa", style: "Vinyasa", teacher: "Teacher TBA", length: "60 min", level: "All Levels" },
  { id: "m2", day: "Monday", time: "9:30 AM", name: "Gentle Hatha", style: "Hatha", teacher: "Teacher TBA", length: "75 min", level: "Beginner" },
  { id: "m3", day: "Monday", time: "12:00 PM", name: "Lunchtime Flow", style: "Vinyasa", teacher: "Teacher TBA", length: "45 min", level: "All Levels", community: true },
  { id: "m4", day: "Monday", time: "6:00 PM", name: "Slow Flow & Meditation", style: "Hatha", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
  { id: "m5", day: "Monday", time: "7:45 PM", name: "Candlelit Yin", style: "Yin", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },

  { id: "t1", day: "Tuesday", time: "6:30 AM", name: "Mysore Ashtanga", style: "Ashtanga", teacher: "Teacher TBA", length: "90 min", level: "Intermediate" },
  { id: "t2", day: "Tuesday", time: "10:00 AM", name: "Morning Vinyasa", style: "Vinyasa", teacher: "Teacher TBA", length: "60 min", level: "All Levels" },
  { id: "t3", day: "Tuesday", time: "5:30 PM", name: "Pranayama Basics", style: "Pranayama", teacher: "Teacher TBA", length: "45 min", level: "All Levels", community: true },
  { id: "t4", day: "Tuesday", time: "7:00 PM", name: "Power Vinyasa", style: "Vinyasa", teacher: "Teacher TBA", length: "60 min", level: "Intermediate" },

  { id: "w1", day: "Wednesday", time: "6:00 AM", name: "Sunrise Flow", style: "Vinyasa", teacher: "Teacher TBA", length: "60 min", level: "All Levels" },
  { id: "w2", day: "Wednesday", time: "9:30 AM", name: "Therapeutic Hatha", style: "Hatha", teacher: "Teacher TBA", length: "75 min", level: "Beginner" },
  { id: "w3", day: "Wednesday", time: "5:30 PM", name: "Restore & Release", style: "Restorative", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
  { id: "w4", day: "Wednesday", time: "7:15 PM", name: "Midweek Vinyasa", style: "Vinyasa", teacher: "Teacher TBA", length: "60 min", level: "All Levels" },

  { id: "th1", day: "Thursday", time: "6:30 AM", name: "Mysore Ashtanga", style: "Ashtanga", teacher: "Teacher TBA", length: "90 min", level: "Intermediate" },
  { id: "th2", day: "Thursday", time: "12:00 PM", name: "Lunchtime Hatha", style: "Hatha", teacher: "Teacher TBA", length: "45 min", level: "All Levels", community: true },
  { id: "th3", day: "Thursday", time: "6:00 PM", name: "Slow Flow", style: "Vinyasa", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
  { id: "th4", day: "Thursday", time: "7:45 PM", name: "Yin & Meditation", style: "Yin", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },

  { id: "f1", day: "Friday", time: "6:00 AM", name: "Sunrise Vinyasa", style: "Vinyasa", teacher: "Teacher TBA", length: "60 min", level: "All Levels" },
  { id: "f2", day: "Friday", time: "9:30 AM", name: "Gentle Hatha", style: "Hatha", teacher: "Teacher TBA", length: "75 min", level: "Beginner" },
  { id: "f3", day: "Friday", time: "5:30 PM", name: "Friday Unwind", style: "Restorative", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },

  { id: "s1", day: "Saturday", time: "8:00 AM", name: "Weekend Vinyasa", style: "Vinyasa", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
  { id: "s2", day: "Saturday", time: "9:45 AM", name: "Community Class", style: "Hatha", teacher: "Teacher TBA", length: "60 min", level: "All Levels", community: true },
  { id: "s3", day: "Saturday", time: "11:15 AM", name: "Yin & Sound", style: "Yin", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
  { id: "s4", day: "Saturday", time: "4:00 PM", name: "Restorative", style: "Restorative", teacher: "Teacher TBA", length: "60 min", level: "All Levels" },

  { id: "su1", day: "Sunday", time: "8:30 AM", name: "Sunday Flow", style: "Vinyasa", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
  { id: "su2", day: "Sunday", time: "10:15 AM", name: "Philosophy & Practice", style: "Hatha", teacher: "Teacher TBA", length: "90 min", level: "All Levels" },
  { id: "su3", day: "Sunday", time: "5:00 PM", name: "Candlelit Restore", style: "Restorative", teacher: "Teacher TBA", length: "75 min", level: "All Levels" },
];

export default function ClassScheduleFilter() {
  const [day, setDay] = useState<Day | "All">("All");
  const [style, setStyle] = useState<Style | "All">("All");

  const filtered = useMemo(() => {
    return SCHEDULE.filter((c) => {
      const dayOk = day === "All" || c.day === day;
      const styleOk = style === "All" || c.style === style;
      return dayOk && styleOk;
    });
  }, [day, style]);

  return (
    <div>
      {/* Filter controls */}
      <div className="rounded-2xl border border-sage-100 bg-cream-50 p-5 shadow-soft md:p-6">
        <div className="space-y-5">
          {/* Day filter */}
          <fieldset>
            <legend className="text-xs font-semibold uppercase tracking-[0.2em] text-sage-700">
              Day
            </legend>
            <div
              role="radiogroup"
              aria-label="Filter by day"
              className="mt-3 flex flex-wrap gap-2"
            >
              <FilterPill
                label="All"
                active={day === "All"}
                onClick={() => setDay("All")}
              />
              {DAYS.map((d) => (
                <FilterPill
                  key={d}
                  label={d.slice(0, 3)}
                  fullLabel={d}
                  active={day === d}
                  onClick={() => setDay(d)}
                />
              ))}
            </div>
          </fieldset>

          {/* Style filter */}
          <fieldset>
            <legend className="text-xs font-semibold uppercase tracking-[0.2em] text-sage-700">
              Style
            </legend>
            <div
              role="radiogroup"
              aria-label="Filter by style"
              className="mt-3 flex flex-wrap gap-2"
            >
              <FilterPill
                label="All"
                active={style === "All"}
                onClick={() => setStyle("All")}
              />
              {STYLES.map((s) => (
                <FilterPill
                  key={s}
                  label={s}
                  active={style === s}
                  onClick={() => setStyle(s)}
                />
              ))}
            </div>
          </fieldset>
        </div>
      </div>

      {/* Results */}
      <div
        className="mt-8"
        aria-live="polite"
        aria-label={`${filtered.length} classes match your filters`}
      >
        <div className="mb-4 text-sm text-ink-muted">
          Showing{" "}
          <span className="font-semibold text-sage-900">{filtered.length}</span>{" "}
          {filtered.length === 1 ? "class" : "classes"}
        </div>

        {filtered.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-sage-200 bg-cream-50 p-12 text-center">
            <p className="text-ink-soft">
              No classes match those filters. Try a different day or style.
            </p>
          </div>
        ) : (
          <ul className="space-y-3">
            {filtered.map((c) => (
              <li key={c.id}>
                <article className="flex flex-col gap-4 rounded-2xl border border-sage-100 bg-cream-50 p-5 shadow-soft transition-colors hover:border-sage-300 md:flex-row md:items-center md:justify-between md:gap-6">
                  <div className="flex items-start gap-5 md:items-center">
                    <div className="min-w-[84px] shrink-0">
                      <div className="text-xs font-semibold uppercase tracking-[0.15em] text-sage-600">
                        {c.day.slice(0, 3)}
                      </div>
                      <div className="mt-1 text-lg font-semibold text-sage-900">
                        {c.time}
                      </div>
                    </div>
                    <div>
                      <div className="flex flex-wrap items-center gap-2">
                        <h3 className="text-base font-semibold text-sage-900">
                          {c.name}
                        </h3>
                        {c.community && (
                          <span className="inline-flex items-center rounded-full bg-terracotta-100 px-2 py-0.5 text-[10px] font-semibold uppercase tracking-[0.15em] text-terracotta-700">
                            $10 Community
                          </span>
                        )}
                      </div>
                      <div className="mt-1.5 flex flex-wrap gap-x-4 gap-y-1 text-xs text-ink-muted">
                        <span className="inline-flex items-center gap-1">
                          <Tag className="h-3 w-3" aria-hidden="true" />
                          {c.style}
                        </span>
                        <span className="inline-flex items-center gap-1">
                          <Clock className="h-3 w-3" aria-hidden="true" />
                          {c.length}
                        </span>
                        <span className="inline-flex items-center gap-1">
                          <User className="h-3 w-3" aria-hidden="true" />
                          {c.teacher}
                        </span>
                        <span>{c.level}</span>
                      </div>
                    </div>
                  </div>
                  <div className="shrink-0">
                    <a
                      href="#book"
                      className="btn-secondary w-full md:w-auto"
                      aria-label={`Book ${c.name} on ${c.day} at ${c.time}`}
                    >
                      Book
                    </a>
                  </div>
                </article>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

function FilterPill({
  label,
  fullLabel,
  active,
  onClick,
}: {
  label: string;
  fullLabel?: string;
  active: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      role="radio"
      aria-checked={active}
      aria-label={fullLabel ?? label}
      onClick={onClick}
      className={cn(
        "rounded-full border px-4 py-2 text-sm font-medium transition-colors",
        active
          ? "border-sage-700 bg-sage-700 text-cream-50"
          : "border-sage-200 bg-cream-50 text-sage-800 hover:border-sage-400 hover:bg-sage-50"
      )}
    >
      {label}
    </button>
  );
}
