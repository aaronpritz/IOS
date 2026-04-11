import Link from "next/link";
import { ArrowRight, type LucideIcon } from "lucide-react";

type Props = {
  icon: LucideIcon;
  title: string;
  description: string;
  href: string;
  linkLabel: string;
};

export default function ServiceCard({
  icon: Icon,
  title,
  description,
  href,
  linkLabel,
}: Props) {
  return (
    <article className="card-lift group flex flex-col">
      <div className="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-sage-100 text-sage-700 transition-colors group-hover:bg-sage-200">
        <Icon className="h-7 w-7" aria-hidden="true" />
      </div>
      <h3 className="text-2xl font-semibold text-sage-900">{title}</h3>
      <p className="mt-4 flex-1 text-pretty text-ink-soft">{description}</p>
      <Link
        href={href}
        className="mt-8 inline-flex items-center gap-2 text-sm font-semibold text-sage-800 transition-colors hover:text-sage-900"
        aria-label={`${linkLabel} — ${title}`}
      >
        {linkLabel}
        <ArrowRight
          className="h-4 w-4 transition-transform group-hover:translate-x-1"
          aria-hidden="true"
        />
      </Link>
    </article>
  );
}
