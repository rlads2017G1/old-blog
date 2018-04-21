---
layout: post
mermaid: true
title: google 表單分數即時回饋
description: 透過結合靜態網頁、light、以及 google 試算表，使填寫結果即時回饋成為可能
tags:
- Web Page
- 中文
---

google 表單大幅降低蒐集問卷資料的難度；此外，表單將回應**自動彙整成試算表**更使分析資料變得非常容易。然而，Google 表單缺乏一項重要的功能：**即時將分數回饋給問卷填答者**[^test]<!--more-->。

具有即時分數回饋 (或根據填問卷者填答情況而有不同回饋) 的問卷，背後通常有伺服器在運算分數。換句話說，想要即時回饋就需要錢。以下將結合 **google 試算表** 以及 **[DataCamp Light](https://github.com/datacamp/datacamp-light){:target="_blank"}**，讓使用者能直接在**靜態網頁**上查詢自己填寫問卷的結果，而且不須花錢。


**實際操作**<br>
繼續閱讀下去前，可先至[示範問卷平台](/assets/gsheet_post/gsheet_demo.html){:target="_blank"}填寫問卷、查詢結果，比較容易理解之後的內容。文章中後段的實例說明即使用此表單為例。
{: .success}

概觀: 運作邏輯
===========================================

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
===========================================

## 連結表單至試算表

可參考 [google 說明](https://support.google.com/docs/answer/2917686?hl=zh-Hant){:target="_blank"}。這項功能使用過 google 表單的人都知道，以下附圖簡單說明：

從雲端硬碟或任何方法，進入到表單即會顯示下圖的頁面(具編輯權限)。**注意需於中間白色方塊點選「回覆」**(預設畫面為「問題」)畫面才會完全如下。接著點選白色方塊中，右上方的**綠色 icon**，即會出現選項要你：

- 建立新試算表，並命名(預設名稱為「無標題表單 (回應)」)
- 選取現有的試算表

通常會建立新的試算表，我也不知連結到現有的試算表會不會發生可怕的事。

![](/assets/gsheet_post/linksheet.PNG){: width="85%" height="85%"}
{:.rounded}

點選建立後，即會在與表單相同的資料夾中建立試算表，我將其命名為**表單回應**(即**概觀**中[右圖](#mermaidChart0)的`表單回應`)。此後，每當有人填完問卷，`表單回應`即會自動新增一列(row)資料。

## 試算表間的連結: `IMPORTRANGE`

**千萬不要編輯`表單回應`**，這很可能會破壞收集到的問卷資料。google 試算表有一個很實用的函數`IMPORTRANGE`，能夠選取一試算表中特定的範圍，將其連結至另一獨立的試算表中(獨立檔案)。因此，每當原先的試算表更新，透過`IMPORTRANGE`連結的新試算表也會跟著更新。如此，即可在不更動`表單回應`下，對`表單回應`的內容進行運算。

若文章中關於`IMPORTRANGE`有描述不清的地方，可參考[這篇](http://isvincent.pixnet.net/blog/post/46090834-excel-google%E8%A9%A6%E7%AE%97%E8%A1%A8%E5%A6%82%E4%BD%95%E9%97%9C%E8%81%AF%E5%88%B0%E5%8F%A6%E4%B8%80%E5%80%8B%E8%A9%A6%E7%AE%97%E8%A1%A8%E7%9A%84%E5%85%A7){:target="_blank"}，寫得相當清楚。

```vbscript
IMPORTRANGE("<URL>","<工作表名稱>!<儲存格範圍>")
```
- `<URL>`: 所欲匯入資料之試算表的網址，在此為`表單回應`之URL
- `<工作表名稱>`: `表單回應`只會有一個工作表，將其名稱填入這裡。
- `<儲存格範圍>`: 儲存格範圍視問卷的題數題數而定，其格式為：`A1:F9487`。

以下將使用此[資料夾](https://drive.google.com/open?id=16lRn7UUo_-8OUdfaYrg7CSUNIvOAmAM8){:target="_blank"}中的檔案為例說明。檔案間的關係完全對應至上文**概觀**中的[概念圖](#mermaidChart0)。
{: .info}

**`運算分析`**試算表
-------------------------------------------

### 匯入
在[`運算分析`](https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0){:target="_blank"}中的儲存格`A1`，我輸入了以下公式：

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1-eOAbpOZ1aeuNUHo3b0olLTrheq-T-pe2BsRXK-P-mM/edit#gid=579070166","表單回應 1!A1:E9999")
```

以匯入[`表單回應`](https://docs.google.com/spreadsheets/d/1-eOAbpOZ1aeuNUHo3b0olLTrheq-T-pe2BsRXK-P-mM/edit#gid=579070166){:target="_blank"}的 A 至 E 欄[^num]。

### 運算公式
我在 G 和 H 欄設定公式[^GH]計算 Q1, Q2, Q3 的分數總合，其中 **Q3 是反向計分**。

### 時間戳記

由於之後會透過 DataCamp Light 讀取 google 試算表，但其並不支援**英文以外的文字**，因此需**將試算表的格式改為英文**：

`檔案` > `試算表設定` > `一般`:

- 語言代碼: `美國`
- 時區: `(GMT+08:00) Taipei`[^tz]

更改完試算表語言後，需更改**時間戳記**的格式[^format]：

1. 選擇時間戳記那欄(在此為 A 欄)
2. `格式` > `數值` > `日期時間`

**`運算結果`**試算表
-----------------------------------------------

`運算分析`設置完成之後，需要**選擇希望使用者看的到的項目**:

1. **時間戳記**: A 欄
2. **Token**: E 欄
3. **score(conditioned)**: H 欄

因此，[`運算結果`](https://docs.google.com/spreadsheets/d/1ufuzTL9VCxdvX1QeFQcMGxYbEMq1ZEWVht3CEDpXBmc/edit?usp=sharing){:target="_blank"}中的 A、B、C 欄需分別對應到`運算分析`中的 A、E、H 欄。在`運算結果`的儲存格`A1`、`B1`、`C1`，分別使用`IMPORTRANGE`：

1. 儲存格`A1`

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0","工作表1!A1:A9999")
```

2. 儲存格`B1`

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0","工作表1!E1:E9999")
```

3. 儲存格`C1`

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0","工作表1!H1:H9999")
```

DataCamp Light 設置
==========================================

[DataCamp](https://www.datacamp.com/){:target="_blank"} 是一個學習資料科學程式語言的線上教學網站，有 R 和 Python 的教學。[DataCamp Light](https://github.com/datacamp/datacamp-light){:target="_blank"}是一個互動式的程式語言輔助教學工具。其能夠鑲嵌在網頁上，讓使用者直接透過網頁學習 R 或 Python。

![](/assets/gsheet_post/DataCamp.PNG){: width="70%" height="70%"}
{:.rounded}

這裡即透過 DataCamp 執行預先寫入的 R Script，讀取儲存在雲端的`運算結果`。使用者在 DataCamp Light 輸入的`Token`是用以篩選資料，如此才會回傳使用者填寫的那筆問卷。

### 取得試算表權限

DataCamp Light 讀取的是[`運算結果`](https://docs.google.com/spreadsheets/d/1ufuzTL9VCxdvX1QeFQcMGxYbEMq1ZEWVht3CEDpXBmc/edit?usp=sharing){:target="_blank"}的內容，因此需將`運算結果`發佈(公開)至網路: 

選取 `檔案` > `發佈到網路...`，即會開啟：

![](/assets/gsheet_post/release_csv.PNG){: width="60%" height="60%" #release}
{:.rounded}

確定選取

1. **連結**(而非內嵌)
2. **逗點分隔值(.csv)**
3. **內容有所變更時自動重新發佈**打勾

並將**中間的連結**複製下來。

### 完整程式碼

以下是鑲嵌於[示範問卷平台](/assets/gsheet_post/gsheet_demo.html){:target="_blank"}的 DataCamp Light 程式碼(html)：

````html
<script src="https://cdn.datacamp.com/datacamp-light-latest.min.js"></script>
<div data-datacamp-exercise data-lang="r">
	<code data-type="pre-exercise-code">
		data <- readr::read_csv(url("https://docs.google.com/spreadsheets/d/e/2PACX-1vQz4zjZfhWBYYRuW2Zhhx-sXvnlrS6vpvcgP0cJPdvsQI-6eKggXmpaWbu4dgbMQgcOHv0NQxL8a_K_/pub?output=csv"))
		data <- as.data.frame(data)
		colnames(data) <- c("DateTime", "Token", "Score")
		data <- data[which(data$Score!=100),]
		score <- function(token) {
			i <- which(data$Token==token)
			data[i,]
		}
	</code>
	<code data-type="sample-code">
		# Put Token in "". Ex: score("abcde123")
		score("A_Token_Example")
	</code>
</div>
````

**注意**<br>
DataCamp Light **僅能正常顯示英文**，因此需確定 R Script 以及使用者填入的 Token 皆沒有多位元組字(例如，中文)。
{: .error}


### 預先執行程式碼

`<code data-type="pre-exercise-code">...</code>`之間的程式碼是使用者看不到，但會預先執行的 R Script：

```r
data <- readr::read_csv(url("https://docs.google.com/spreadsheets/d/e/2PACX-1vQz4zjZfhWBYYRuW2Zhhx-sXvnlrS6vpvcgP0cJPdvsQI-6eKggXmpaWbu4dgbMQgcOHv0NQxL8a_K_/pub?output=csv"))
data <- as.data.frame(data)
colnames(data) <- c("DateTime", "Token", "Score")
data <- data[which(data$Score!=100),] #這行只是縮減資料，可省略不寫
score <- function(token) {
	i <- which(data$Token==token)
	data[i,]
}
```

第一行`data <- readr::read_csv(url("https://docs.google.com/spreadsheets..."))`是透過雲端讀取`運算結果`的指令。函數內的連結即是上圖[取得試算表權限](#release)**中間的連結**。


### 示範程式碼

`<code data-type="sample-code">...</code>`之間則是使用者看到的程式碼：

```r
# Put Token in "". Ex: score("abcde123")
score("A_Token_Example")
```
第一行是註解(不會執行)，可用以指示使用者。


靜態網頁
==================================

對於完全沒有概念的人，設置靜態網頁可能會是比較困難的部分，因為多數人對此相當陌生。靜態網頁的目的最主要是為了放 DataCamp Light 的程式碼，因此若讀者使用的部落格平台允許自由變更網頁的 html[^blog]，可以忽略此節內容。

## GitHub Pages

架設靜態網頁[^static]並非難事，難的是做出漂亮的靜態網頁。然而，網頁越漂亮，其結構通常也更加複雜。如何(短時間)打造美觀的靜態網頁以及基礎 HTML, CSS 的概念並非此文的目的。對於有這些需求的讀者，我推薦 [Yihui Xie](https://yihui.name/){:target="_blank"} 的 [blogdown](https://bookdown.org/yihui/blogdown/){:target="_blank"}。

以下提供一個最精簡的例子，由註冊 GitHub 帳號到架設網頁，過程中僅需使用瀏覽器(電腦版為例)。

### 註冊與建立 Repo
1. 至 https://github.com/ ，填寫註冊資訊(一個 email 僅能註冊一次)，並記得去信箱認證。**Username** 即為之後網站的網址，以下圖為例，minimalghpage.github.io。<br>![](/assets/gsheet_post/github_signup.PNG){: width="55%" height="55%"}

2. 信箱認證後，跳回 GitHub 頁面，基本上不需更動出現之畫面的設定，只要按下一步。之後應會出現下圖，按右上角圖示並選取**Your Profile**。<br>![](/assets/gsheet_post/gh_main.PNG){: width="80%" height="80%"}

3. 按下網頁中上方的 **Repositories** 後應會出現下圖，接著再按下右上方的綠色按鈕 **New**。 <br>![](/assets/gsheet_post/gh_repo.PNG){: width="80%" height="80%"}

4. 出現下圖後，在 **Repository name** 輸入`<username>.github.io`，並**勾選**下方 **Initialize this repository with a README**。最後按 **Create repository**。 <br>![](/assets/gsheet_post/create_repo.PNG){: width="70%" height="70%"}

### 上傳網頁

[Minimal GitHub Page](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/liao961120/local_depend/tree/master/minimal_web_DataCampLight){:target="_blank"} 裡面有兩個檔案：`index.html`以及`.nojekyll`。

- `index.html`: 這是網站的首頁，亦即瀏覽器進入`https://username.github.io/`時所讀取的檔案。此為一最簡例子，所以網站僅有首頁一個頁面。此檔案僅包含 DataCamp Light 的程式碼和 HTML 的必要結構。因此，若要修改 DataCamp Light 的 R Script，需用文字編輯器開啟此檔案修改`<body>...</body>`裡面的內容。

- `.nojekyll`: [Jekyll](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/){:target="_blank"} 是 GitHub Pages 靜態網頁產生器，能自動將 Markdown 生成`.html`，對於常寫文章的使用者很方便：不需每次發文都要上傳文章的 html 檔。`.nojekyll`在此的作用是告訴 GitHub Pages **不要使用 Jekyll 產生網頁**，因為使用 Jekyll 產生網頁，repository 需符合特定的檔案架構[^jekyll]。


1. 下載 [Minimal GitHub Page](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/liao961120/local_depend/tree/master/minimal_web_DataCampLight){:target="_blank"}(點擊連結自動下載。下載後需解壓縮。)

2. 至剛剛建立的 Repository (username.github.io)，點擊 **Upload files**(圖中黃色螢光處)。 <br>![](/assets/gsheet_post/gh_upload1.PNG){: width="90%" height="90%"}

3. 進入新畫面後，將`index.html`, `.nojekyll`拖曳上傳，並按下畫面最下方 **Commit changes**.

4. 上傳完成後，即可看到下圖。`.nojekyll`不會顯示出來。<br>![](/assets/gsheet_post/gh_uploaded.PNG){: width="90%" height="90%"}

5. **完成！**過 1, 2 分鐘後，即可至`username.github.io`檢視網頁，其內容應[與此](https://minimalghpage.github.io/){:target="_blank"}相同。


隱私問題
==========================================

在此需特別提醒問卷填答者隱私的問題。由於查詢個人的問卷回饋需透過 DataCamp Light，其**由雲端讀入之試算表(`運算結果`)是公開的**。縱使網頁表面看不見`運算結果`的網址，但只要檢視網頁的原始碼(透過瀏覽器的開發人員工具，或至 GitHub 直接下載`index.html`)，即可取得`運算結果`的網址，並下載整份資料[^secure]。這篇文章的`運算結果`僅含有 3 欄：時間戳記、Token、分數，其中 Token 是問卷填答者直接填寫。

在設計問卷時，需於 Token 那題特別提醒**不能填寫能關聯到個人身份的內容**。
{: .error}

<br><br>
Last updated: Apr 20, 2018 9:59 PM

<!-- FootNotes -->

附註
=======================================

[^test]: 其實 google 表單確實能即時回饋分數，但僅限[測驗模式](https://support.google.com/docs/answer/7032287?hl=zh-Hant){:target="_blank"}，有諸多限制，例如，題目僅能為「對」或「錯」，無法處理反向計分的問題，無法使用線性刻度 (linear scale) 計分等。

[^num]: 若擔心填答人數超過 9999 人，可設個更大的數字，如`E99999`。

[^GH]: G、H 欄計算的東西是一樣的，當初為了其它不相干的目的所以設了兩欄，之後的僅會用到 H 欄: score(conditioned)。

[^tz]: 你也可以設置時區，通常依據的是多數問卷填答者所在位置的時區。這邊設為台北時間。

[^format]: 這邊是為了方便之後 R parse 日期格式。

[^static]: 這裡的靜態網頁是架設在 GitHub 上，代表(1)可以任意修改網頁；(2)網頁的內容(檔案)是完全公開的。因此，相對於其他部落格平台，如 Blogger， 網站管理人的彈性相當大，而且網頁上不會出現廣告。然而，由於檔案是完全公開的，需**注意隱私以及版權問題**。

[^blog]: 我對目前的部落格平台功能相當不熟悉，但就我所知提供此功能的應該不多。DataCamp Light 有提供 WordPress(不是 WordPress.com) 外掛，詳見 [DataCamp Light Wordpress Plugin](https://github.com/datacamp/datacamp-light-wordpress){:target="_blank"}。

[^jekyll]: 這是自行在 GitHub Pages 上架設部落格最困難的地方：使用者需對 Jekyll 有一定程度的理解。這同時也是我推薦 [blogdown](https://github.com/rstudio/blogdown){:target="_blank"} 的原因，其讓使用者略過理解複雜的靜態網頁產生器，而能專心在網頁的內容上。

[^secure]: 然`運算結果`透過`IMPORTRANGE`匯入的試算表只要**未開放共用連結**，仍是安全的。