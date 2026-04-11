import type { LucideIcon } from "lucide-react";

type Props = {
  icon: LucideIcon;
  title: string;
  description: string;
};

export default function ValueCard({ icon: Icon, title, description }: Props) {
  return (
    <div className="card text-center">
      <div
        className="mx-auto mb-5 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-terracotta-100 text-terracotta-600"
        aria-hidden="true"
      >
        <Icon className="h-6 w-6" />
      </div>
      <h3 className="text-lg font-semibold text-sage-900">{title}</h3>
      <p className="mt-3 text-sm leading-relaxed text-ink-soft">{description}</p>
    </div>
  );
}
