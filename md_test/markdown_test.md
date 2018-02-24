---
layout: post
title: Markdown features + Mermaid test
mermaid: true
---
<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/7.1.2/mermaid.min.js"></script>
<!-- <script>mermaid.initialize({startOnLoad:true});</script> -->
<script>
    mermaid.init({noteMargin: 10}, ".language-mermaid");
    // mermaid.init(undefined, '.language-mermaid');
    $(function() {
      mermaid.initialize({ startOnLoad: true });
    });
</script>


## Highlighted Area

Success Text. 成功{:.success}

Info Text.{:.info}

Warning Text.{:.warning}

Error Text.{:.error}

## Rounded Image

![](liao.jpg){:.circle.shadow}




#### markdown:
    ```mermaid
    graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    ```

## Flowchart

<!-- <div class="mermaid"></div> -->
### div language mermaid

<div class="language-mermaid">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>

### code chunk language mermaid

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

