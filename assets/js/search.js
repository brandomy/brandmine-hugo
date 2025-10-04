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
  }

  async init(inputSelector, resultsSelector) {
    this.searchInput = document.querySelector(inputSelector);
    this.resultsContainer = document.querySelector(resultsSelector);

    if (!this.searchInput || !this.resultsContainer) {
      console.warn('Search elements not found');
      return;
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
      console.log(`Search index loaded (${htmlLang}): ${this.index.length} brands`);
    } catch (error) {
      console.error('Failed to load search index:', error);
    }
  }

  handleSearch(query) {
    if (!query || query.length < 2) {
      this.hideResults();
      return;
    }

    const results = this.search(query);
    this.displayResults(results, query);
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
          No brands found for "${this.escapeHtml(query)}"
        </div>
      `;
      this.showResults();
      return;
    }

    const html = results.map(result => {
      const tags = [];

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
    window.brandSearch.init('#search-input', '#search-results');
  });
}
