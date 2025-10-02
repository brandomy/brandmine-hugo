---
title: "{{ replace .Name "-" " " | title }}"
translationKey: "{{ .Name }}-insight"
date: {{ .Date }}
draft: true
lang: en

# Insight category (one of: brand-spotlight, founders-journey, location-intelligence, market-momentum)
insightType: ""

# Related entities
relatedBrands: []
relatedFounders: []
markets: []
sectors: []

# Metadata
author: "Brandmine Research Team"
readTime:
heroImage: "/images/insights/{{ .Name }}/hero.jpg"

# SEO
description: ""
summary: ""
---

Insight article content goes here...
