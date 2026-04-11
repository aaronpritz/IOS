"use client";

import Link from "next/link";
import { Calendar } from "lucide-react";
import { siteConfig } from "@/lib/utils";

/**
 * Sticky mobile-only Book Now bar. Hidden on lg and up (where the Navbar's
 * "Book Now" button is always visible).
 */
export default function MobileBookNow() {
  return (
    <div
      className="fixed inset-x-0 bottom-0 z-40 border-t border-sage-200 bg-cream-50/95 p-3 shadow-lift backdrop-blur-md lg:hidden"
      role="region"
      aria-label="Book a class"
    >
      <Link
        href={siteConfig.bookingUrl}
        className="btn-primary w-full text-base"
        aria-label="Book a class now"
      >
        <Calendar className="h-4 w-4" aria-hidden="true" />
        Book Now
      </Link>
    </div>
  );
}
