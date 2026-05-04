# ChangeLog

## 2026-05-05

- Added ColorV preview support for 8-digit hex colors like `#FFFFFFAA`.
- Kept preview rendering based on the RGB portion (`#FFFFFF`) while preserving alpha in parsing metadata.
- Updated Vimscript and Python fallback parsers, plus preview samples.
- Added ColorV preview support for `Color(r, g, b, a)` float colors.
- Rendered `Color(...)` preview from RGB float channels while preserving alpha as metadata.
- Escaped `Color(...)` preview matches so decimal dots and parentheses are treated literally.
