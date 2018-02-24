---
layout: post
title: Markdown features + Mermaid test
mermaid: true
---
## Highlighted Area

Success Text. 成功{:.success}

Info Text.{:.info}

Warning Text.{:.warning}

Error Text.{:.error}

## Rounded Image

![](liao.jpg){:.circle.shadow}

## Mermaid


#### markdown:
    ```mermaid
    graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    ```

## Flowchart

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

[Documentation for Flowchart](https://mermaidjs.github.io/flowchart.html)

**markdown:**

    ```mermaid
    graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    ```

