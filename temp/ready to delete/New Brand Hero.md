HTML Structure (layouts/brands/list.html:4-14)
<section class="panel panel--hero-split">
  <div class="split-hero split-hero--orange">
    <div class="split-hero__content">
      <!-- Title and subtitle -->
    </div>
    <div class="split-hero__image">
      <!-- Hero image -->
    </div>
  </div>
</section>



CSS Components
Base panel system (assets/css/base/panels.css:17-28) - Full-width container with overflow handling
Split-hero outer section (assets/css/base/panels.css:323-333) - Orange radial gradient background
Split-hero grid layout (assets/css/base/panels.css:336-350) - 1 column mobile, 2 columns desktop (50vh-60vh min-height)
Left content panel (assets/css/base/panels.css:353-371) - Teal linear gradient with text
Right image panel (assets/css/base/panels.css:391-403) - 3:2 aspect ratio image
Orange variant (assets/css/base/panels.css:411-417) - Overrides outer background with orange gradient
The key architectural pattern: layered backgrounds where the outer section has an orange gradient, but the left text panel maintains teal branding (lines 360-364).


Brands Hero Panel Typography & Colors

Typography

Title (panels.css:373-380)
Font: PT Serif (EN/RU) / Noto Serif SC (ZH)
Size: clamp(2rem, 1.7rem + 1.5vw, 3rem) (32px-48px responsive)
Weight: 700 (Bold)
Color: white
Line height: 1.1

Subtitle (panels.css:382-388)
Font: PT Sans (EN/RU) / Noto Sans SC (ZH)
Size: clamp(1.125rem, 1rem + 0.625vw, 1.375rem) (18px-22px responsive)
Color: white
Opacity: 0.95
Line height: 1.5

Colors

Outer Section Background - Orange radial gradient (panels.css:411-417)
radial-gradient(
  circle at 30% 40%,
  var(--secondary-400) 0%,   /* #FB923C - light orange */
  var(--secondary-700) 100%  /* #C2410C - dark orange */
)

Left Text Panel - Teal linear gradient (panels.css:360-364)
linear-gradient(
  90deg,
  var(--primary-600) 0%,   /* #2C7A7B - medium teal */
  var(--primary-700) 100%  /* #285E61 - dark teal */
)

Impact Statement (panels.css:447-459)
Background: var(--primary-50) (#E6FFFA - very light teal)
Text color: var(--neutral-700) (#374151 - dark gray)
Font size: clamp(1rem, 0.95rem + 0.25vw, 1.125rem) (16px-18px)
All color values defined in variables.css:17-40.


Here's the complete CSS for those classes:
.panel--hero-split (Outer section)
.panel--hero-split {
  padding: 0;
  min-height: auto;
  overflow: hidden;
  /* Dark teal radial gradient background (default) */
  background: radial-gradient(
    circle at 30% 40%,
    var(--primary-400) 0%,    /* #38B2AC */
    var(--primary-700) 100%   /* #285E61 */
  );
}
.split-hero (Container)
.split-hero {
  display: grid;
  grid-template-columns: 1fr;
  min-height: 50vh;
  align-items: center;
  max-width: var(--content-width-max, 1200px);
  margin: 0 auto;
}

@media (min-width: 992px) {
  .split-hero {
    grid-template-columns: 1fr 1fr;
    min-height: 60vh;
  }
}
.split-hero--orange (Color variant)
.panel--hero-split.split-hero--orange {
  background: radial-gradient(
    circle at 30% 40%,
    var(--secondary-400) 0%,    /* #FB923C - light orange */
    var(--secondary-700) 100%   /* #C2410C - dark orange */
  );
}
.split-hero__content (Left text panel)
.split-hero__content {
  padding: var(--space-2xl) var(--space-lg);  /* 3rem 1.5rem */
  display: flex;
  flex-direction: column;
  justify-content: center;
  order: 1;
  /* Teal linear gradient (always teal, regardless of outer color) */
  background: linear-gradient(
    90deg,
    var(--primary-600) 0%,    /* #2C7A7B */
    var(--primary-700) 100%   /* #285E61 */
  );
}

@media (min-width: 992px) {
  .split-hero__content {
    padding: var(--space-3xl) var(--space-2xl);  /* 4rem 3rem */
  }
}
.split-hero__image (Right image panel)
.split-hero__image {
  width: 100%;
  order: 2;
  overflow: hidden;
  padding: 2rem 2rem 2rem 0;
}

.split-hero__image img {
  width: 100%;
  aspect-ratio: 3 / 2;
  object-fit: cover;
  display: block;
}
Key architecture: The outer section has an orange gradient, but the left text panel always maintains teal branding.