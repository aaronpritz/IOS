import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Merge Tailwind class names, resolving conflicts predictably.
 */
export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}

/**
 * Shared site metadata used across pages and structured data.
 */
export const siteConfig = {
  name: "Santosha School of Yoga & Wellness",
  shortName: "Santosha",
  tagline: "Find Your Contentment",
  description:
    "Santosha is a multidisciplinary yoga and wellness school in Indianapolis offering affordable classes, Ayurveda, bodywork, and Yoga Alliance teacher training.",
  url: "https://santoshaschool.com",
  address: {
    street: "8580 Cedar Place Drive #120",
    city: "Indianapolis",
    state: "IN",
    zip: "46240",
  },
  phone: "317-437-5375",
  phoneHref: "tel:+13174375375",
  email: "santosha.school@gmail.com",
  emailHref: "mailto:santosha.school@gmail.com",
  bookingUrl: "#book",
} as const;

/**
 * Primary navigation links used by Navbar and Footer.
 */
export const navLinks = [
  { href: "/", label: "Home" },
  { href: "/classes", label: "Classes" },
  { href: "/services", label: "Services" },
  { href: "/teacher-training", label: "Teacher Training" },
  { href: "/pricing", label: "Pricing" },
  { href: "/contact", label: "Contact" },
] as const;
