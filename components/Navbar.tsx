"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { Menu, X, Flower2 } from "lucide-react";
import { cn, navLinks, siteConfig } from "@/lib/utils";

export default function Navbar() {
  const pathname = usePathname();
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 16);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  // Close the mobile menu on route change
  useEffect(() => {
    setOpen(false);
  }, [pathname]);

  // Lock body scroll when the mobile menu is open
  useEffect(() => {
    if (open) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [open]);

  const solid = scrolled || open;

  return (
    <header
      className={cn(
        "fixed inset-x-0 top-0 z-50 transition-all duration-300",
        solid
          ? "border-b border-sage-100 bg-cream-100/95 backdrop-blur-md shadow-soft"
          : "bg-transparent"
      )}
      role="banner"
    >
      <nav
        aria-label="Primary"
        className="container flex h-20 items-center justify-between"
      >
        <Link
          href="/"
          className="flex items-center gap-2.5 focus-visible:rounded-lg"
          aria-label={`${siteConfig.shortName} — Home`}
        >
          <span
            className="inline-flex h-10 w-10 items-center justify-center rounded-full bg-sage-700 text-cream-50"
            aria-hidden="true"
          >
            <Flower2 className="h-5 w-5" />
          </span>
          <span className="flex flex-col leading-none">
            <span className="text-lg font-semibold tracking-tight text-sage-900">
              Santosha
            </span>
            <span className="text-[10px] font-medium uppercase tracking-[0.2em] text-sage-600">
              Yoga · Wellness
            </span>
          </span>
        </Link>

        {/* Desktop nav */}
        <ul className="hidden items-center gap-1 lg:flex">
          {navLinks.map((link) => {
            const active =
              link.href === "/"
                ? pathname === "/"
                : pathname?.startsWith(link.href);
            return (
              <li key={link.href}>
                <Link
                  href={link.href}
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    "rounded-full px-4 py-2 text-sm font-medium transition-colors",
                    active
                      ? "bg-sage-100 text-sage-900"
                      : "text-sage-800 hover:bg-sage-50 hover:text-sage-900"
                  )}
                >
                  {link.label}
                </Link>
              </li>
            );
          })}
        </ul>

        <div className="hidden lg:block">
          <Link
            href={siteConfig.bookingUrl}
            className="btn-primary"
            aria-label="Book a class now"
          >
            Book Now
          </Link>
        </div>

        {/* Mobile toggle */}
        <button
          type="button"
          className="inline-flex h-11 w-11 items-center justify-center rounded-full border border-sage-200 bg-cream-50 text-sage-800 lg:hidden"
          aria-label={open ? "Close menu" : "Open menu"}
          aria-expanded={open}
          aria-controls="mobile-menu"
          onClick={() => setOpen((v) => !v)}
        >
          {open ? (
            <X className="h-5 w-5" aria-hidden="true" />
          ) : (
            <Menu className="h-5 w-5" aria-hidden="true" />
          )}
        </button>
      </nav>

      {/* Mobile menu panel */}
      <div
        id="mobile-menu"
        role="dialog"
        aria-modal="true"
        aria-label="Mobile navigation"
        className={cn(
          "lg:hidden",
          "fixed inset-x-0 top-20 origin-top transform border-b border-sage-100 bg-cream-100 shadow-lift transition-all duration-300",
          open
            ? "pointer-events-auto translate-y-0 opacity-100"
            : "pointer-events-none -translate-y-2 opacity-0"
        )}
      >
        <ul className="container flex flex-col gap-1 py-6">
          {navLinks.map((link) => {
            const active =
              link.href === "/"
                ? pathname === "/"
                : pathname?.startsWith(link.href);
            return (
              <li key={link.href}>
                <Link
                  href={link.href}
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    "block rounded-xl px-4 py-3 text-base font-medium transition-colors",
                    active
                      ? "bg-sage-100 text-sage-900"
                      : "text-sage-800 hover:bg-sage-50"
                  )}
                >
                  {link.label}
                </Link>
              </li>
            );
          })}
          <li className="pt-3">
            <Link
              href={siteConfig.bookingUrl}
              className="btn-primary w-full"
              aria-label="Book a class now"
            >
              Book Now
            </Link>
          </li>
        </ul>
      </div>
    </header>
  );
}
