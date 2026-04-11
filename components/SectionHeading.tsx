import { cn } from "@/lib/utils";

type Props = {
  eyebrow?: string;
  title: string;
  description?: string;
  align?: "left" | "center";
  id?: string;
};

export default function SectionHeading({
  eyebrow,
  title,
  description,
  align = "left",
  id,
}: Props) {
  return (
    <div
      className={cn(
        "max-w-3xl",
        align === "center" && "mx-auto text-center"
      )}
    >
      {eyebrow && <span className="eyebrow">{eyebrow}</span>}
      <h2
        id={id}
        className="mt-4 text-display-lg text-balance text-sage-900"
      >
        {title}
      </h2>
      {description && (
        <p className="mt-5 text-lg text-pretty text-ink-soft">{description}</p>
      )}
    </div>
  );
}
