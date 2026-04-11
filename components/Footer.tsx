import Link from "next/link";
import { Flower2, MapPin, Phone, Mail } from "lucide-react";
import { navLinks, siteConfig } from "@/lib/utils";

export default function Footer() {
  const year = new Date().getFullYear();
  const { address, phone, phoneHref, email, emailHref } = siteConfig;

  return (
    <footer
      className="border-t border-sage-200 bg-sage-900 text-cream-100"
      role="contentinfo"
    >
      <div className="container py-16 md:py-20">
        <div className="grid gap-12 md:grid-cols-4">
          {/* Brand & mission */}
          <div className="md:col-span-2">
            <Link
              href="/"
              className="flex items-center gap-3"
              aria-label={`${siteConfig.shortName} — Home`}
            >
              <span
                className="inline-flex h-11 w-11 items-center justify-center rounded-full bg-cream-100 text-sage-900"
                aria-hidden="true"
              >
                <Flower2 className="h-5 w-5" />
              </span>
              <span className="flex flex-col leading-none">
                <span className="text-xl font-semibold tracking-tight text-cream-50">
                  Santosha
                </span>
                <span className="text-[10px] font-medium uppercase tracking-[0.22em] text-sage-300">
                  Yoga · Wellness School
                </span>
              </span>
            </Link>
            <p className="mt-6 max-w-md text-cream-100/80">
              Santosha — contentment — is a multidisciplinary yoga and wellness
              school in Indianapolis. We teach yoga, Ayurveda, and bodywork
              rooted in tradition, accessible to every body, for the whole of a
              life.
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              <Link
                href={siteConfig.bookingUrl}
                className="btn bg-cream-50 text-sage-900 hover:bg-cream-200"
              >
                Book a Class
              </Link>
              <Link
                href="/teacher-training"
                className="btn border border-cream-100/30 text-cream-50 hover:bg-cream-50/10"
              >
                Teacher Training
              </Link>
            </div>
          </div>

          {/* Quick links */}
          <nav aria-label="Footer navigation">
            <h2 className="text-xs font-semibold uppercase tracking-[0.22em] text-sage-300">
              Explore
            </h2>
            <ul className="mt-5 space-y-3">
              {navLinks.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-cream-100/90 hover:text-cream-50"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>

          {/* Visit */}
          <div>
            <h2 className="text-xs font-semibold uppercase tracking-[0.22em] text-sage-300">
              Visit
            </h2>
            <ul className="mt-5 space-y-4 text-sm">
              <li className="flex items-start gap-3">
                <MapPin
                  className="mt-0.5 h-4 w-4 shrink-0 text-sage-300"
                  aria-hidden="true"
                />
                <address className="not-italic text-cream-100/90">
                  {address.street}
                  <br />
                  {address.city}, {address.state} {address.zip}
                </address>
              </li>
              <li className="flex items-start gap-3">
                <Phone
                  className="mt-0.5 h-4 w-4 shrink-0 text-sage-300"
                  aria-hidden="true"
                />
                <a
                  href={phoneHref}
                  className="text-cream-100/90 hover:text-cream-50"
                  aria-label={`Call Santosha at ${phone}`}
                >
                  {phone}
                </a>
              </li>
              <li className="flex items-start gap-3">
                <Mail
                  className="mt-0.5 h-4 w-4 shrink-0 text-sage-300"
                  aria-hidden="true"
                />
                <a
                  href={emailHref}
                  className="break-all text-cream-100/90 hover:text-cream-50"
                  aria-label={`Email Santosha at ${email}`}
                >
                  {email}
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-14 flex flex-col items-start justify-between gap-4 border-t border-sage-700/60 pt-8 text-xs text-sage-300 sm:flex-row sm:items-center">
          <div>
            © {year} {siteConfig.name}. All rights reserved.
          </div>
          <div className="italic">
            &ldquo;Santosha — contentment — brings supreme happiness.&rdquo; —
            Yoga Sutras 2.42
          </div>
        </div>
      </div>
    </footer>
  );
}
