Posting with Markdown on GitHub Pages (or Hugo)
================

Features
--------

### Heading Reference

``` md
[Link text](#heading-of-markdown)
```

For example, `[Foot](#footnotes)` links to the Footnotes section ([Foot](#footnotes)).

### Equation Reference (MathJax required)

Add `\label{eq:name}` in the `$$` tags give the equation identifiers. Use `$\eqref{eq:name}$` to reference the labled equation \[^1\].

Note the dependency of this feature on MathJax support. Read [this post](https://liao961120.github.io/2018/01/27/mathjax.html) for details.

### Footnotes:

``` md
texttextext [^1]
[^1]: this will be displayed at bottom
```

Warnings: GitHub Pages
----------------------

### Display Raw Liquid Tags

Becareful of raw (non-functional) liquid tags (or anything that looks like it) in the posts. It might lead to page build error when using Jekyll, even if the tags appeard in the code chunks, like this:

    {% if page.mathjax2 == true %}

If you want to include liquid tags in your posts, put the raw liquid tag between `{% raw %}` and `{% endraw %}`. If you want to display in code chunks, wrap the whole thing (including `{% raw %}` and `{% endraw %}`) in the code fences. So the thing in the code fences looks like:

#### Displaying liquid tag in code chunks

    {% raw %}<raw liquid tags wanted to display>{% endraw %}
