import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./lib/**/*.{ts,tsx}",
  ],
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: "1.25rem",
        sm: "1.5rem",
        lg: "2rem",
        xl: "2.5rem",
      },
      screens: {
        "2xl": "1280px",
      },
    },
    extend: {
      colors: {
        // Santosha brand palette — WCAG AA tuned
        sage: {
          50: "#f2f6f1",
          100: "#e4ede2",
          200: "#c9dbc6",
          300: "#a8c2a4",
          400: "#8aa891",
          500: "#6c8e76",
          600: "#54735e",
          700: "#425c4b",
          800: "#36493e",
          900: "#2b3a31",
        },
        cream: {
          50: "#fdfbf5",
          100: "#faf6ed",
          200: "#f4ecd8",
          300: "#ecdfbd",
          400: "#e0cc98",
          500: "#d0b572",
          600: "#b79756",
        },
        teal: {
          50: "#eef5f5",
          100: "#d8e8e8",
          200: "#b1d1d2",
          300: "#84b4b6",
          400: "#5d9799",
          500: "#477f81",
          600: "#3a6769",
          700: "#305355",
          800: "#294547",
          900: "#22393b",
        },
        terracotta: {
          50: "#fbf1ec",
          100: "#f5ddd1",
          200: "#ebbba4",
          300: "#de9676",
          400: "#d17552",
          500: "#c05a38",
          600: "#a2472a",
          700: "#803823",
          800: "#5f2a1b",
          900: "#431e15",
        },
        ink: {
          DEFAULT: "#1f211e",
          soft: "#3b3f39",
          muted: "#5a5f57",
        },
      },
      fontFamily: {
        sans: ["var(--font-inter)", "system-ui", "sans-serif"],
      },
      fontSize: {
        "display-xl": ["clamp(2.5rem, 6vw, 4.75rem)", { lineHeight: "1.05", letterSpacing: "-0.02em" }],
        "display-lg": ["clamp(2rem, 4.5vw, 3.5rem)", { lineHeight: "1.1", letterSpacing: "-0.015em" }],
        "display-md": ["clamp(1.75rem, 3.5vw, 2.5rem)", { lineHeight: "1.15", letterSpacing: "-0.01em" }],
      },
      boxShadow: {
        soft: "0 1px 2px rgba(31, 33, 30, 0.04), 0 8px 24px rgba(31, 33, 30, 0.06)",
        lift: "0 2px 4px rgba(31, 33, 30, 0.05), 0 18px 40px rgba(31, 33, 30, 0.10)",
      },
      borderRadius: {
        xl: "1rem",
        "2xl": "1.5rem",
        "3xl": "2rem",
      },
      keyframes: {
        "fade-up": {
          "0%": { opacity: "0", transform: "translateY(12px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        "fade-in": {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
      },
      animation: {
        "fade-up": "fade-up 0.6s ease-out both",
        "fade-in": "fade-in 0.8s ease-out both",
      },
    },
  },
  plugins: [],
};

export default config;
