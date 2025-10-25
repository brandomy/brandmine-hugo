/**
 * Brandmine Search Module
 * Client-side search with type-ahead support
 */

class BrandSearch {
  constructor() {
    this.index = [];
    this.searchInput = null;
    this.resultsContainer = null;
    this.isLoaded = false;
    this.cardGrid = null;
    this.allCards = [];
    this.resultCounter = null;
  }

  async init(inputSelector, resultsSelector, cardGridSelector = null, counterSelector = null) {
    this.searchInput = document.querySelector(inputSelector);
    this.resultsContainer = document.querySelector(resultsSelector);
    this.cardGrid = cardGridSelector ? document.querySelector(cardGridSelector) : null;
    this.resultCounter = counterSelector ? document.querySelector(counterSelector) : null;

    if (!this.searchInput || !this.resultsContainer) {
      // Silently return if search elements don't exist on this page
      return;
    }

    // Collect cards for on-page filtering if grid exists
    if (this.cardGrid) {
      this.collectCards();
    }

    // Lazy load index on first focus
    this.searchInput.addEventListener('focus', () => {
      if (!this.isLoaded) {
        this.loadIndex();
      }
    }, { once: true });

    // Set up search input handler
    this.searchInput.addEventListener('input', (e) => {
      this.handleSearch(e.target.value);
    });

    // Close results on outside click
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.search-container')) {
        this.hideResults();
      }
    });
  }

  async loadIndex() {
    try {
      // Detect current language from HTML lang attribute or URL
      const htmlLang = document.documentElement.lang || 'en';
      const indexPath = htmlLang === 'en' ? '/index.json' : `/${htmlLang}/index.json`;

      const response = await fetch(indexPath);
      this.index = await response.json();
      this.isLoaded = true;
      const brandCount = this.index.filter(i => i.type === 'brand').length;
      const founderCount = this.index.filter(i => i.type === 'founder').length;
      console.log(`Search index loaded (${htmlLang}): ${brandCount} brands, ${founderCount} founders`);
    } catch (error) {
      console.error('Failed to load search index:', error);
    }
  }

  collectCards() {
    // Collect all brand or founder cards from the page
    const brandCards = this.cardGrid.querySelectorAll('[data-brand-id]');
    const founderCards = this.cardGrid.querySelectorAll('[data-founder-id]');

    const cards = brandCards.length > 0 ? brandCards : founderCards;

    this.allCards = Array.from(cards).map(card => ({
      element: card,
      searchable: (card.dataset.searchable || '').toLowerCase()
    }));

    console.log(`On-page filter initialized with ${this.allCards.length} cards`);
  }

  handleSearch(query) {
    if (!query || query.length < 2) {
      this.hideResults();
      this.showAllCards();
      return;
    }

    const results = this.search(query);
    this.displayResults(results, query);
    this.filterVisibleCards(query);
  }

  filterVisibleCards(query) {
    if (!this.cardGrid || this.allCards.length === 0) return;

    const lowerQuery = query.toLowerCase();
    let visibleCount = 0;

    this.allCards.forEach(card => {
      const matches = card.searchable.includes(lowerQuery);
      card.element.style.display = matches ? '' : 'none';
      if (matches) visibleCount++;
    });

    this.updateResultCounter(visibleCount);
  }

  showAllCards() {
    if (!this.cardGrid || this.allCards.length === 0) return;

    this.allCards.forEach(card => {
      card.element.style.display = '';
    });

    this.updateResultCounter(this.allCards.length);
  }

  updateResultCounter(count) {
    if (!this.resultCounter) return;

    const total = this.allCards.length;
    const isBrandPage = this.allCards[0]?.element.dataset.brandId !== undefined;
    const itemType = isBrandPage ? 'brand' : 'founder';
    const itemTypePlural = isBrandPage ? 'brands' : 'founders';

    if (count === total) {
      this.resultCounter.textContent = `${total} ${count === 1 ? itemType : itemTypePlural}`;
    } else {
      this.resultCounter.textContent = `${count} of ${total} ${itemTypePlural}`;
    }
  }

  search(query) {
    const lowerQuery = query.toLowerCase();
    const results = [];

    for (const item of this.index) {
      let score = 0;

      // Title match (highest weight)
      if (item.title.toLowerCase().includes(lowerQuery)) {
        score += 10;
      }

      // Description match
      if (item.description && item.description.toLowerCase().includes(lowerQuery)) {
        score += 5;
      }

      // Location match
      if (item.city && item.city.toLowerCase().includes(lowerQuery)) {
        score += 7;
      }
      if (item.region && item.region.toLowerCase().includes(lowerQuery)) {
        score += 6;
      }

      // Brand-specific fields
      if (item.type === 'brand') {
        // Taxonomy matches
        const taxonomies = ['markets', 'sectors', 'attributes', 'signals'];
        for (const taxonomy of taxonomies) {
          if (item[taxonomy]) {
            for (const term of item[taxonomy]) {
              if (term.toLowerCase().includes(lowerQuery)) {
                score += 4;
              }
            }
          }
        }
      }

      // Founder-specific fields
      if (item.type === 'founder') {
        // Company match
        if (item.company && item.company.toLowerCase().includes(lowerQuery)) {
          score += 8;
        }
        // Role match
        if (item.role && item.role.toLowerCase().includes(lowerQuery)) {
          score += 6;
        }
        // Expertise match
        if (item.expertise) {
          for (const exp of item.expertise) {
            if (exp.toLowerCase().includes(lowerQuery)) {
              score += 5;
            }
          }
        }
      }

      if (score > 0) {
        results.push({ ...item, score });
      }
    }

    // Sort by score, then title
    results.sort((a, b) => {
      if (b.score !== a.score) return b.score - a.score;
      return a.title.localeCompare(b.title);
    });

    return results.slice(0, 10); // Return top 10 results
  }

  displayResults(results, query) {
    if (results.length === 0) {
      this.resultsContainer.innerHTML = `
        <div class="search-no-results">
          No results found for "${this.escapeHtml(query)}"
        </div>
      `;
      this.showResults();
      return;
    }

    const html = results.map(result => {
      const tags = [];

      if (result.type === 'brand') {
        // Add markets (up to 2)
        if (result.markets && result.markets.length > 0) {
          result.markets.slice(0, 2).forEach(market => {
            tags.push(`<span class="result-tag result-tag--market">${market}</span>`);
          });
        }

        // Add sectors (up to 2)
        if (result.sectors && result.sectors.length > 0) {
          result.sectors.slice(0, 2).forEach(sector => {
            tags.push(`<span class="result-tag result-tag--sector">${sector}</span>`);
          });
        }
      } else if (result.type === 'founder') {
        // Add company tag
        if (result.company) {
          tags.push(`<span class="result-tag result-tag--company">${this.escapeHtml(result.company)}</span>`);
        }
      }

      return `
        <a href="${result.url}" class="search-result-item">
          <div class="result-main">
            <h4 class="result-title">${this.highlightMatch(result.title, query)}</h4>
            ${result.city ? `<p class="result-location">${result.city}</p>` : ''}
          </div>
          ${tags.length > 0 ? `
            <div class="result-tags">
              ${tags.join('')}
            </div>
          ` : ''}
        </a>
      `;
    }).join('');

    this.resultsContainer.innerHTML = html;
    this.showResults();
  }

  highlightMatch(text, query) {
    const lowerText = text.toLowerCase();
    const lowerQuery = query.toLowerCase();
    const index = lowerText.indexOf(lowerQuery);

    if (index === -1) return this.escapeHtml(text);

    const before = text.substring(0, index);
    const match = text.substring(index, index + query.length);
    const after = text.substring(index + query.length);

    return `${this.escapeHtml(before)}<mark>${this.escapeHtml(match)}</mark>${this.escapeHtml(after)}`;
  }

  showResults() {
    this.resultsContainer.hidden = false;
  }

  hideResults() {
    this.resultsContainer.hidden = true;
  }

  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
}

// Initialize on page load
if (typeof window !== 'undefined') {
  window.brandSearch = new BrandSearch();

  document.addEventListener('DOMContentLoaded', () => {
    // Initialize with optional on-page filtering
    // Detects if we're on brands or founders list page
    const cardGrid = document.querySelector('#brand-grid') || document.querySelector('#founder-grid');
    const counterSelector = cardGrid ? '#search-result-counter' : null;
    const gridSelector = cardGrid ? (cardGrid.id === 'brand-grid' ? '#brand-grid' : '#founder-grid') : null;

    window.brandSearch.init('#search-input', '#search-results', gridSelector, counterSelector);
  });
}
