Posting with Markdown on GitHub Pages (or Hugo)
================

Features
--------

### Open Link in new tab (kramdown only)

``` md
[Link](url){:target="_blank"}
```

opens link in new tab.

### Heading Reference

``` md
[Link text](#heading-of-markdown)
```

For example, `[Foot](#footnotes)` links to the **Footnotes** section ([Foot](#footnotes)).

For Multibite Characters, add `{#identifier}` next to the heading, and use `[Link text](#identifier)` to reference the section.

### Equation Reference (MathJax required)

Add `\label{eq:name}` in the `$$` tags give the equation identifiers. Use `$\eqref{eq:name}$` to reference the labled equation.

Note the dependency of this feature on MathJax support. Read [this post](https://liao961120.github.io/2018/01/27/mathjax.html) for details.

### Footnotes (kramdown and Blackfriday)

``` md
texttextext [^1]
[^1]: this will be displayed at bottom
```

Click <sup>**1**</sup> at the ending of this line of text to read foot notes[1].

Warnings: GitHub Pages
----------------------

### Display Raw Liquid Tags


#### Displaying liquid tag in code chunks


[1] This is footnote
