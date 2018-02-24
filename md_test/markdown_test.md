---
layout: post
title: Markdown features + Mermaid test
mermaid: true
---



## Highlighted Area

Success Text. 成功
{: .success}

Info Text.
{: .info}

Warning Text.
{: .warning}

Error Text.
{: .error}

## Rounded Image

![](liao.jpg)
{:.circle}

## Mermaid

<div class="mermaid">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>

### Using kramdown syntax
```
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
{: .mermaid}

#### Code
```html
<div class="mermaid">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>
```

[Documentation for Flowchart](https://mermaidjs.github.io/flowchart.html)
