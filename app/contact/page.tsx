import type { Metadata } from "next";
import { MapPin, Phone, Mail, Clock } from "lucide-react";
import SectionHeading from "@/components/SectionHeading";
import ContactForm from "@/components/ContactForm";
import { siteConfig } from "@/lib/utils";

export const metadata: Metadata = {
  title: "Contact & Location",
  description: `Visit Santosha at ${siteConfig.address.street}, ${siteConfig.address.city}, ${siteConfig.address.state} ${siteConfig.address.zip}. Call ${siteConfig.phone} or email us to book a class, consultation, or training.`,
  alternates: { canonical: "/contact" },
  openGraph: {
    title: "Contact Santosha | Indianapolis Yoga & Wellness",
    description:
      "Contact Santosha School of Yoga & Wellness in Indianapolis. Phone, email, and studio location.",
    url: "/contact",
  },
};

export default function ContactPage() {
  const { address, phone, phoneHref, email, emailHref } = siteConfig;

  return (
    <>
      {/* Header */}
      <section
        className="section-sm bg-cream-100"
        aria-labelledby="contact-heading"
      >
        <div className="container max-w-4xl text-center">
          <span className="eyebrow">Contact & Location</span>
          <h1
            id="contact-heading"
            className="mt-4 text-display-lg text-balance text-sage-900"
          >
            We&apos;d love to hear from you.
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-pretty">
            Questions about classes, services, or training? Reach out — we
            answer every message personally, usually within one business day.
          </p>
        </div>
      </section>

      {/* Contact grid */}
      <section className="section-sm bg-cream-100" aria-label="Contact details">
        <div className="container grid gap-10 lg:grid-cols-2 lg:gap-14">
          {/* Details card */}
          <aside className="space-y-6" aria-label="Studio information">
            <div className="card">
              <h2 className="text-xl font-semibold text-sage-900">
                Visit the studio
              </h2>
              <ul className="mt-6 space-y-5">
                <li className="flex items-start gap-4">
                  <span
                    className="mt-1 inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-sage-100 text-sage-700"
                    aria-hidden="true"
                  >
                    <MapPin className="h-5 w-5" />
                  </span>
                  <div>
                    <div className="text-xs font-semibold uppercase tracking-[0.15em] text-sage-700">
                      Address
                    </div>
                    <address className="mt-1 not-italic text-ink-soft">
                      {address.street}
                      <br />
                      {address.city}, {address.state} {address.zip}
                    </address>
                  </div>
                </li>
                <li className="flex items-start gap-4">
                  <span
                    className="mt-1 inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-sage-100 text-sage-700"
                    aria-hidden="true"
                  >
                    <Phone className="h-5 w-5" />
                  </span>
                  <div>
                    <div className="text-xs font-semibold uppercase tracking-[0.15em] text-sage-700">
                      Phone
                    </div>
                    <a
                      href={phoneHref}
                      className="mt-1 inline-block text-lg font-medium text-sage-900 hover:text-sage-700"
                      aria-label={`Call Santosha at ${phone}`}
                    >
                      {phone}
                    </a>
                  </div>
                </li>
                <li className="flex items-start gap-4">
                  <span
                    className="mt-1 inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-sage-100 text-sage-700"
                    aria-hidden="true"
                  >
                    <Mail className="h-5 w-5" />
                  </span>
                  <div>
                    <div className="text-xs font-semibold uppercase tracking-[0.15em] text-sage-700">
                      Email
                    </div>
                    <a
                      href={emailHref}
                      className="mt-1 inline-block break-all text-lg font-medium text-sage-900 hover:text-sage-700"
                      aria-label={`Email Santosha at ${email}`}
                    >
                      {email}
                    </a>
                  </div>
                </li>
                <li className="flex items-start gap-4">
                  <span
                    className="mt-1 inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-sage-100 text-sage-700"
                    aria-hidden="true"
                  >
                    <Clock className="h-5 w-5" />
                  </span>
                  <div>
                    <div className="text-xs font-semibold uppercase tracking-[0.15em] text-sage-700">
                      Studio hours
                    </div>
                    <div className="mt-1 space-y-0.5 text-ink-soft">
                      <div>Mon – Fri · 6:00 AM – 9:00 PM</div>
                      <div>Sat – Sun · 7:00 AM – 6:00 PM</div>
                    </div>
                  </div>
                </li>
              </ul>
            </div>

            {/* Map placeholder */}
            <div
              className="overflow-hidden rounded-2xl border border-sage-100 bg-cream-50 shadow-soft"
              aria-label="Studio location map"
            >
              <div className="relative aspect-[16/10] w-full">
                {/* Google Maps embed placeholder — replace `src` with a real embed */}
                <iframe
                  title={`Map to ${siteConfig.name}`}
                  src={`https://www.google.com/maps?q=${encodeURIComponent(
                    `${address.street}, ${address.city}, ${address.state} ${address.zip}`
                  )}&output=embed`}
                  loading="lazy"
                  referrerPolicy="no-referrer-when-downgrade"
                  className="absolute inset-0 h-full w-full border-0"
                  allowFullScreen
                />
              </div>
              <div className="flex items-center justify-between gap-4 border-t border-sage-100 p-4 text-sm">
                <span className="text-ink-soft">
                  {address.street}, {address.city}
                </span>
                <a
                  href={`https://maps.google.com/?q=${encodeURIComponent(
                    `${address.street}, ${address.city}, ${address.state} ${address.zip}`
                  )}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="link-underline font-medium"
                  aria-label="Open directions in Google Maps"
                >
                  Get directions
                </a>
              </div>
            </div>
          </aside>

          {/* Form */}
          <div>
            <SectionHeading
              eyebrow="Send a message"
              title="Tell us what you need."
              description="Whether you're exploring a class, booking a consultation, or considering teacher training — start here."
            />
            <div className="mt-8">
              <ContactForm />
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
