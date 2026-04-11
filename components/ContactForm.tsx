"use client";

import { useState, type FormEvent } from "react";
import { Send, CheckCircle2 } from "lucide-react";
import { cn } from "@/lib/utils";

type Topic =
  | "General inquiry"
  | "Classes"
  | "Ayurvedic consultation"
  | "Bodywork"
  | "Jyotish reading"
  | "Teacher training";

const TOPICS: Topic[] = [
  "General inquiry",
  "Classes",
  "Ayurvedic consultation",
  "Bodywork",
  "Jyotish reading",
  "Teacher training",
];

type Status = "idle" | "submitting" | "success" | "error";

export default function ContactForm() {
  const [status, setStatus] = useState<Status>("idle");
  const [topic, setTopic] = useState<Topic>("General inquiry");

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setStatus("submitting");

    // No backend is wired yet — simulate a successful submission client-side
    // so the form gives accessible feedback. Replace with a real handler
    // (Server Action, API route, or third-party form service) in production.
    window.setTimeout(() => {
      setStatus("success");
    }, 650);
  }

  if (status === "success") {
    return (
      <div
        role="status"
        aria-live="polite"
        className="card flex flex-col items-start gap-4 bg-sage-50 text-left"
      >
        <div className="inline-flex h-12 w-12 items-center justify-center rounded-full bg-sage-700 text-cream-50">
          <CheckCircle2 className="h-6 w-6" aria-hidden="true" />
        </div>
        <h3 className="text-xl font-semibold text-sage-900">
          Message received.
        </h3>
        <p className="text-ink-soft">
          Thank you for reaching out. We&apos;ll respond personally, usually
          within one business day. In the meantime, breathe deeply.
        </p>
        <button
          type="button"
          className="btn-secondary"
          onClick={() => setStatus("idle")}
          aria-label="Send another message"
        >
          Send another message
        </button>
      </div>
    );
  }

  const submitting = status === "submitting";

  return (
    <form onSubmit={onSubmit} className="card space-y-6" noValidate>
      <div className="grid gap-5 sm:grid-cols-2">
        <Field id="name" label="Your name" required>
          <input
            id="name"
            name="name"
            type="text"
            required
            autoComplete="name"
            disabled={submitting}
            className={inputClasses}
            aria-required="true"
          />
        </Field>
        <Field id="email" label="Email" required>
          <input
            id="email"
            name="email"
            type="email"
            required
            autoComplete="email"
            disabled={submitting}
            className={inputClasses}
            aria-required="true"
          />
        </Field>
      </div>

      <Field id="phone" label="Phone (optional)">
        <input
          id="phone"
          name="phone"
          type="tel"
          autoComplete="tel"
          disabled={submitting}
          className={inputClasses}
        />
      </Field>

      <Field id="topic" label="What's this about?" required>
        <select
          id="topic"
          name="topic"
          required
          disabled={submitting}
          value={topic}
          onChange={(e) => setTopic(e.target.value as Topic)}
          className={cn(inputClasses, "bg-cream-50")}
          aria-required="true"
        >
          {TOPICS.map((t) => (
            <option key={t} value={t}>
              {t}
            </option>
          ))}
        </select>
      </Field>

      <Field id="message" label="Message" required>
        <textarea
          id="message"
          name="message"
          required
          rows={5}
          disabled={submitting}
          className={cn(inputClasses, "min-h-[140px] resize-y")}
          placeholder="Tell us a little about what you're looking for..."
          aria-required="true"
        />
      </Field>

      <div className="flex flex-col items-start gap-3 sm:flex-row sm:items-center sm:justify-between">
        <p className="text-xs text-ink-muted">
          By submitting, you agree to be contacted about your inquiry. We never
          share your information.
        </p>
        <button
          type="submit"
          className="btn-primary w-full sm:w-auto"
          disabled={submitting}
          aria-label="Send message"
        >
          {submitting ? "Sending..." : "Send Message"}
          {!submitting && <Send className="h-4 w-4" aria-hidden="true" />}
        </button>
      </div>
    </form>
  );
}

const inputClasses =
  "w-full rounded-xl border border-sage-200 bg-cream-50 px-4 py-3 text-base text-ink placeholder:text-ink-muted/70 shadow-sm transition-colors focus:border-sage-600 focus:outline-none focus:ring-2 focus:ring-sage-600/30 disabled:cursor-not-allowed disabled:opacity-60";

function Field({
  id,
  label,
  required = false,
  children,
}: {
  id: string;
  label: string;
  required?: boolean;
  children: React.ReactNode;
}) {
  return (
    <div>
      <label
        htmlFor={id}
        className="mb-1.5 block text-sm font-semibold text-sage-900"
      >
        {label}
        {required && (
          <span aria-hidden="true" className="ml-1 text-terracotta-600">
            *
          </span>
        )}
      </label>
      {children}
    </div>
  );
}
