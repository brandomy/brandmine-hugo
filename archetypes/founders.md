---
title: "{{ replace .Name "-" " " | title }}"
translationKey: "{{ .Name }}-founder"
date: {{ .Date }}
draft: true
lang: en

# Professional
role: ""
industry: ""
expertise: []

# Personal
location: ""
languages: []
education: ""

# Social
linkedin: ""
email: ""

# Assets
photo: "/images/founders/{{ .Name }}/portrait.jpg"
heroImage: "/images/founders/{{ .Name }}/hero.jpg"

# SEO
description: ""
---

Founder biography and background goes here...
