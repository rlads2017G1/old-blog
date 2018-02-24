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

#### kramdown syntax

graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
{: .mermaid}

[Documentation for Flowchart](https://mermaidjs.github.io/flowchart.html)
