# 🏛️ SBCL

## 使用 Quicklisp 自動生成

## 1. 建立專案

打開 SBCL，載入 `quickproject` 並指定你想要的專案名稱（以 `my-project` 為例）：

```lisp
(ql:quickload :quickproject)
;; 建立專案到 Quicklisp 能自動尋找到的 local-projects 目錄中
(quickproject:make-project #p"~/quicklisp/local-projects/my-project/")
```

## 2. 生成的目錄結構

這個指令會自動在該目錄下建立以下標準檔案：
- `my-project.asd` —— 專案定義與依賴管理檔。
- `package.lisp` —— 宣告套件空間與命名空間。
- `my-project.lisp` —— 主要的程式碼撰寫處。

## 3. 載入並測試專案

因為建立在 `local-projects` 下，Quicklisp 與 ASDF 會自動掃描到它。你可以在 REPL 中直接載入：

```lisp
(ql:quickload :my-project)
```

# 手動建立專案

## 1. 建立專案資料夾與檔案

在你的電腦中建立一個名為 `my-project` 的資料夾，並在裡面手動建立兩個檔案：

📂 **`my-project.asd`** (專案定義檔)

```lisp
(asdf:defsystem #:my-project
  :description "這是一個手動建立的 Common Lisp 專案"
  :author "Your Name <your.email@example.com>"
  :license "MIT"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "main")))
```

_(註：`:serial t` 代表檔案會按照順序由上往下編譯與載入，意即 `main.lisp` 可以安全地使用 `package.lisp` 裡定義的內容)_

📂 **`package.lisp`** (定義命名空間)

```lisp
(defpackage #:my-project
  (:use #:cl)
  (:export #:hello-world))
```

📂 **`main.lisp`** (主要的程式邏輯)

```lisp
(in-package #:my-project)

(defun hello-world ()
  (format t "Hello, SBCL World!~%"))
```

# 🏢 Clojure

## 下载 lein 脚本
``` bash
curl -L -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
```

## 创建项目
使用 lein new app 命令创建一个应用项目：

``` bash
lein new app test-api
```

输出内容
``` txt
Generating a project called test-api based on the 'app' template.
```

生成的目录结构
``` txt
test-api/
├── CHANGELOG.md
├── LICENSE
├── README.md
├── doc/
│   └── intro.md
├── project.clj
├── resources/
├── src/
│   └── test-api/
│       └── core.clj
└── test/
    └── test-api/
        └── core_test.clj
```
[详细项目配置参考网址](http://blog.lujun9972.win/blog/2026/04/14/leiningen-%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0%EF%BC%9Aclojure-%E9%A1%B9%E7%9B%AE%E6%9E%84%E5%BB%BA%E4%B8%8E%E7%AE%A1%E7%90%86%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E5%AE%9E%E6%88%98%E9%85%8D%E7%BD%AE/index.html)
