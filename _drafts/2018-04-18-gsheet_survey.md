---
layout: post
mermaid: true
title: google 表單分數即時回饋
description: 透過結合靜態網頁、DataCamp light、以及 google 試算表，使填寫結果即時回饋成為可能
tags:
- Web Page
- 中文
---

google 表單大幅降低蒐集問卷資料的難度；此外，表單將回應**自動彙整成試算表**更使分析資料變得非常容易。然而，Google 表單缺乏一項重要的功能：**即時將分數回饋給問卷填答者**[^test]。<!--more-->

具有即時分數回饋 (或根據填問卷者填答情況而有不同回饋) 的問卷，背後通常有伺服器在運算分數。換句話說，想要即時回饋就需要錢。以下將結合 **google 試算表** 以及 **[DataCamp Light](https://github.com/datacamp/datacamp-light){:target="_blank"}**，讓使用者能直接在**靜態網頁**上查詢自己填寫問卷的結果，而且不須花錢。


**實際操作**<br>
繼續閱讀下去前，可先[至此](/assets/gsheet_post/gsheet_demo.html){:target="_blank"}自行操作一次，比較容易理解以下的內容。
{: .info}

概觀: 運作邏輯
-----------------------------------

<div class="mermaid">
graph TD;
	user("使用者") ==>|"1. 填寫"| Form("表單");
	Form -.->|"2. 原始資料"|sheet("試算表");
	sheet -.->|"3. 問卷回饋(多筆)"|dc;
	dc("DataCamp") ==>|"4. 問卷回饋(1筆)"| user;

	style Form fill:#8b64ce;
	style dc fill:#08A8D0;
	style user fill:#FFFFFF;
	style sheet fill:#1FA463, stroke:#898989,stroke-width:3.5px,stroke-dasharray: 5, 5;


	Form2("表單") -->|"1. 自動產生"|sheet1("表單回應");
	sheet1 -->|"2. 連結"|sheet2("運算分析");
	sheet2  -->|"3. 連結"|sheet3("運算結果");
	dc2("DataCamp") -.->|"4. 讀取資料"|sheet3;

	style sheet1 fill:#1FA463;
	style sheet2 fill:#1FA463;
	style sheet3 fill:#1FA463;
	style Form2 fill:#8b64ce;
	style dc2 fill:#08A8D0;
</div>

上圖需將**左**、**右**分開來看。

- **左側**以使用者觀點為中心，顯示使用者填寫問卷(送出資料)到獲得回饋之間，資料流動的路程。

- **右側**的流程圖，實際上是左圖**試算表**(表單、DataCamp之間)那格的完整路程，意即資料在 google 試算表間的流動及運算。使用者獲得的回饋即是由這些試算表的運算產生。

上圖省略一個重要的步驟未畫出：**使用者需將填寫於問卷的 Token 輸入 DataCamp Light 後，其才會傳回問卷回饋**。


操作流程
------------------------------------

### 連結表單至試算表

可參考 [google 說明](https://support.google.com/docs/answer/2917686?hl=zh-Hant){:target="_blank"}。這項功能使用過 google 表單的人都知道，以下附圖簡單說明：

從雲端硬碟或任何方法，進入到表單即會顯示下圖的頁面(具編輯權限)。**注意需於中間白色方塊點選「回覆」**(預設畫面為「問題」)畫面才會完全如下。接著點選白色方塊中，右上方的**綠色 icon**，即會出現選項要你：
- 建立新試算表，並命名(預設名稱為「無標題表單 (回應)」)
- 選取現有的試算表
通常會建立新的試算表，我也不知連結到現有的試算表會不會發生可怕的事。

![](/assets/gsheet_post/linksheet.PNG)

點選建立後，即會在與表單相同的資料夾中建立試算表(即**概觀**中[右圖](#mermaidChart0)的`表單回應`)，此後，每當有人填完問卷，`表單回應`即會自動新增一列(row)資料。

### 試算表間的連結

**千萬不要編輯`表單回應`**，這很可能會破壞收集到的問卷資料。google 試算表有一個很實用的函數`IMPORTRANGE`[^fc]，能夠選取一試算表中特定的範圍，將其連結至另一獨立的試算表中(獨立檔案)。因此，每當原先的試算表更新，透過`IMPORTRANGE`連結的新試算表也會跟著更新。如此，即可在不更動`表單回應`下，對`表單回應`的內容進行運算。

可參考[這篇文章](http://isvincent.pixnet.net/blog/post/46090834-excel-google%E8%A9%A6%E7%AE%97%E8%A1%A8%E5%A6%82%E4%BD%95%E9%97%9C%E8%81%AF%E5%88%B0%E5%8F%A6%E4%B8%80%E5%80%8B%E8%A9%A6%E7%AE%97%E8%A1%A8%E7%9A%84%E5%85%A7){:target="_blank"}，寫得相當清楚。以下僅簡述。

```VBScript
IMPORTRANGE("<URL>","<工作表名稱>!<儲存格範圍>")
```
- `<URL>`: 所欲匯入資料之試算表的網址，在此為`表單回應`之URL
- `<工作表名稱>`: `表單回應`只會有一個工作表，將其名稱填入這裡。
- `<儲存格範圍>`: 儲存格範圍視問卷的題數題數而定，其格式為：`A1:F9487`。

歡迎參考**概觀**中右圖的[實例](https://drive.google.com/open?id=16lRn7UUo_-8OUdfaYrg7CSUNIvOAmAM8){:target="_blank"}，以下將直接使用此資料夾中的檔案為例說明。

#### **表單回應**至**運算分析**

##### 匯入
在[`運算分析`](https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0){:target="_blank"}中的儲存格`A1`，我輸入了以下公式：

```VBScript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1-eOAbpOZ1aeuNUHo3b0olLTrheq-T-pe2BsRXK-P-mM/edit#gid=579070166","表單回應 1!A1:E9999")
```

以匯入[`表單回應`](https://docs.google.com/spreadsheets/d/1-eOAbpOZ1aeuNUHo3b0olLTrheq-T-pe2BsRXK-P-mM/edit#gid=579070166){:target="_blank"}的 A 至 E 欄[^num]。

##### 運算公式
我在 G 和 H 欄設定公式[^GH]計算  Q1, Q2, Q3 的分數總合，其中 **Q3 是反向計分**。

##### 時間戳記

`檔案` > `試算表設定` > `一般`:

- 語言代碼: `美國`
- 時區: `(GMT+08:00) Taipei`

#### **運算分析**至**運算結果**

## google 表單及 google 試算表







Last updated: Apr 18, 2018





[^test]: 其實 google 表單確實能即時回饋分數，但僅限[測驗模式](https://support.google.com/docs/answer/7032287?hl=zh-Hant){:target="_blank"}，有諸多限制，例如，題目僅能為「對」或「錯」，無法處理反向計分的問題，無法使用線性刻度 (linear scale) 計分等。

[^fc]: 我是看[這篇文章](http://isvincent.pixnet.net/blog/post/46090834-excel-google%E8%A9%A6%E7%AE%97%E8%A1%A8%E5%A6%82%E4%BD%95%E9%97%9C%E8%81%AF%E5%88%B0%E5%8F%A6%E4%B8%80%E5%80%8B%E8%A9%A6%E7%AE%97%E8%A1%A8%E7%9A%84%E5%85%A7){:target="_blank"}學到`IMPORTRANGE`。

[^num]: 若擔心填答人數超過 9999 人，可設個更大的數字，如`E99999`。

[^GH]: G、H 欄計算的東西是一樣的，當初為了其它不相干的目的所以設了兩欄，之後的僅會用到 H 欄: score(conditioned)。