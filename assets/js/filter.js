/**
 * Brandmine Multi-Taxonomy Filter
 * Client-side filtering across 4 dimensions
 */

class BrandFilter {
  constructor() {
    this.activeFilters = {
      markets: new Set(),
      sectors: new Set(),
      attributes: new Set(),
      signals: new Set()
    };
    this.allBrands = [];
    this.filterContainer = null;
    this.resultsContainer = null;
  }

  init(filterSelector, resultsSelector) {
    this.filterContainer = document.querySelector(filterSelector);
    this.resultsContainer = document.querySelector(resultsSelector);

    if (!this.filterContainer || !this.resultsContainer) {
      // Silently return if filter elements don't exist on this page
      return;
    }

    this.collectBrands();
    this.attachEventListeners();
  }

  collectBrands() {
    // Collect all brand cards from the page
    const brandCards = document.querySelectorAll('[data-brand-id]');

    brandCards.forEach(card => {
      const brand = {
        element: card,
        id: card.dataset.brandId,
        markets: (card.dataset.markets || '').split(',').filter(Boolean),
        sectors: (card.dataset.sectors || '').split(',').filter(Boolean),
        attributes: (card.dataset.attributes || '').split(',').filter(Boolean),
        signals: (card.dataset.signals || '').split(',').filter(Boolean)
      };
      this.allBrands.push(brand);
    });

    console.log(`Filter initialized with ${this.allBrands.length} brands`);
  }

  attachEventListeners() {
    // Listen for filter checkbox changes
    const checkboxes = this.filterContainer.querySelectorAll('input[type="checkbox"]');

    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', (e) => {
        this.handleFilterChange(e.target);
      });
    });

    // Clear all filters button
    const clearButton = this.filterContainer.querySelector('[data-clear-filters]');
    if (clearButton) {
      clearButton.addEventListener('click', () => {
        this.clearAllFilters();
      });
    }
  }

  handleFilterChange(checkbox) {
    const taxonomy = checkbox.dataset.taxonomy; // markets, sectors, etc.
    const value = checkbox.value;

    if (checkbox.checked) {
      this.activeFilters[taxonomy].add(value);
    } else {
      this.activeFilters[taxonomy].delete(value);
    }

    this.applyFilters();
    this.updateFilterCount();
  }

  applyFilters() {
    // Check if any filters are active
    const hasActiveFilters = Object.values(this.activeFilters).some(set => set.size > 0);

    if (!hasActiveFilters) {
      // Show all brands
      this.allBrands.forEach(brand => {
        brand.element.style.display = '';
      });
      this.updateResultCount(this.allBrands.length);
      return;
    }

    // Apply intersection filtering (AND logic across taxonomies)
    let visibleCount = 0;

    this.allBrands.forEach(brand => {
      const matches = this.brandMatchesFilters(brand);
      brand.element.style.display = matches ? '' : 'none';
      if (matches) visibleCount++;
    });

    this.updateResultCount(visibleCount);
  }

  brandMatchesFilters(brand) {
    // For each taxonomy with active filters, brand must match at least one value
    for (const [taxonomy, filterSet] of Object.entries(this.activeFilters)) {
      if (filterSet.size === 0) continue; // Skip if no filters active for this taxonomy

      const brandValues = brand[taxonomy];
      const hasMatch = brandValues.some(value => filterSet.has(value));

      if (!hasMatch) return false; // Must match in all taxonomies with active filters
    }

    return true;
  }

  clearAllFilters() {
    // Clear all active filters
    Object.keys(this.activeFilters).forEach(key => {
      this.activeFilters[key].clear();
    });

    // Uncheck all checkboxes
    const checkboxes = this.filterContainer.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(checkbox => {
      checkbox.checked = false;
    });

    this.applyFilters();
    this.updateFilterCount();
  }

  updateFilterCount() {
    const totalActive = Object.values(this.activeFilters).reduce(
      (sum, set) => sum + set.size,
      0
    );

    const countElement = document.querySelector('[data-filter-count]');
    if (countElement) {
      countElement.textContent = totalActive;
      countElement.hidden = totalActive === 0;
    }
  }

  updateResultCount(count) {
    const countElement = document.querySelector('[data-result-count]');
    if (countElement) {
      countElement.textContent = `${count} ${count === 1 ? 'brand' : 'brands'}`;
    }
  }
}

// Initialize brand filter on page load
if (typeof window !== 'undefined') {
  window.brandFilter = new BrandFilter();

  document.addEventListener('DOMContentLoaded', () => {
    window.brandFilter.init('#filter-panel', '#brand-grid');
  });
}

/**
 * Insights Category Filter
 * Client-side filtering for insights by category type
 */
class InsightsFilter {
  constructor() {
    this.filterButtons = null;
    this.insightCards = null;
  }

  init() {
    this.filterButtons = document.querySelectorAll('.filter-btn');
    this.insightCards = document.querySelectorAll('.insight-card-wrapper');

    if (!this.filterButtons.length || !this.insightCards.length) {
      // Silently return if filter elements don't exist on this page
      return;
    }

    this.attachEventListeners();
  }

  attachEventListeners() {
    this.filterButtons.forEach(button => {
      button.addEventListener('click', (e) => {
        this.handleFilterClick(e.target);
      });
    });
  }

  handleFilterClick(button) {
    const category = button.getAttribute('data-category');

    // Update active button
    this.filterButtons.forEach(btn => btn.classList.remove('filter-btn--active'));
    button.classList.add('filter-btn--active');

    // Filter cards
    this.insightCards.forEach(card => {
      const cardCategory = card.getAttribute('data-category');

      if (category === 'all' || cardCategory === category) {
        card.classList.remove('hidden');
      } else {
        card.classList.add('hidden');
      }
    });
  }
}

// Initialize insights filter on page load
if (typeof window !== 'undefined') {
  window.insightsFilter = new InsightsFilter();

  document.addEventListener('DOMContentLoaded', () => {
    window.insightsFilter.init();
  });
}
