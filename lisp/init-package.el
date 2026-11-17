;;; init-package.el --- setttings for packages
;;; -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package restart-emacs)
(setq straight-vc-git-default-clone-depth 1)

(use-package drag-stuff
             :bind (("<M-up>" . drag-stuff-up)
                    ("<M-down>" . drag-stuff-down)))

;; 使用 Vertico
(use-package vertico
  :straight t
  :init
  (vertico-mode 1))

;; 使用 Marginalia 显示候选项额外信息（类似 ivy-rich）
(use-package marginalia
  :straight t
  :init
  (marginalia-mode 1))

;; Orderless 提供模糊匹配（比 ivy 更自由）
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)) ; 使用 orderless 做为主要匹配风格
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion)))))) ; 文件路径可用 partial

;; Consult 替代 Swiper 和 Counsel
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)				; 替代 swiper
         ("C-r" . consult-line)				; 向后搜索
         ("C-c f" . consult-recent-file)	; 替代 counsel-recentf
         ("C-c g" . consult-git-grep))		; 替代 counsel-git
  :custom
  ;; ✅ 启用实时预览功能（等效 swiper）
  (consult-preview-key '(:debounce 0.2 any))  ;; 或 '(:debounce 0.3 any)
  ;; ✅ 默认不显示太多 preview 窗口
  (consult-narrow-key "<")
  ;; 可选：让 consult-line 默认从当前点开始往后找
  (consult-line-start-from-top nil))

;; ✅ 这个函数会确保实时预览在 minibuffer 启用
(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)

;; Embark 提供对候选项的上下文操作（光标移动到候选项时按 C-. 可以弹出操作菜单）
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-h B" . embark-bindings)) ;; 查看当前 keymap 的所有绑定
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

;; 更好地与 consult 结合
(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; which-key
(use-package which-key
  :ensure t
  :defer nil
  :config
  (which-key-mode))

;; 可选：美化 minibuffer（建议搭配）
(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package ace-window 
             :bind (("M-o" . 'ace-window)))

(use-package async
  :straight t
  :init
  ;; 自动加载 async byte-compile 的 hook（可选）
  (dired-async-mode 1)
  (async-bytecomp-package-mode 1)) ; 对插件异步 byte-compile，加快 Emacs 启动

(use-package all-the-icons
  :ensure t
  :config
  ;; 注意：安装完成后，请执行命令 M-x all-the-icons-install-fonts，
  ;; 这将会自动下载并安装 all-the-icons 所需字体，如 Font Awesome、Material Design Icons 等，
  ;; 否则图标可能显示为乱码或问号。
  (unless (file-exists-p (expand-file-name "fonts/all-the-icons.ttf" user-emacs-directory))
    (message "请运行 M-x all-the-icons-install-fonts 安装 all-the-icons 字体。")))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package neotree
	:ensure t)

;; --------------------------------------------
;; 配置 Projectile：项目管理工具，用于快速在项目间跳转、搜索文件、查找符号等
;; --------------------------------------------
;; 启用项目管理工具 Projectile
(use-package projectile
  :straight t
  :init
  (projectile-mode +1)  ;; 全局启用 Projectile 模式
  :config
  ;; 根据实际情况设置你的项目目录，可以添加多个目录
  (setq projectile-project-search-path '("~/projects/"))
  ;; 结合 Ivy 使用更加流畅的补全体验
  (setq projectile-completion-system 'default)
  ;; 建议绑定 Projectile 的命令前缀，例如 "C-c p"
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (message "Projectile 已启动"))

;; 使用 Consult 封装的 Projectile 接口，提供更好 UI 和功能
(use-package consult-projectile
  :straight t
  :after (consult projectile))

(use-package iedit
  :ensure t
  :bind (("C-;" . iedit-mode))  ;; 将 C-; 绑定为 iedit-mode 开关
  :config
  ;; 可选配置：如果你不希望 iedit 额外绑定第二个切换键可以设置为 nil
  (setq iedit-toggle-key-default nil)
  ;; 为 iedit 模式添加一个退出按键（按 C-c C-c 退出 iedit 模式）
  (define-key iedit-mode-keymap (kbd "C-c C-c") 'iedit-done))

;; 自定义 iedit-dwim 函数：
(defun iedit-dwim (arg)
  "启动 iedit 模式。
如果传入前缀参数，则在整个缓冲区中匹配，否则仅匹配当前函数内部的内容。"
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        (narrow-to-defun)
        (iedit-mode)))))

;; 使用示例：
;; 1. 在编辑代码或文本时，将光标放在某个单词上。
;; 2. 按下 C-; 进入 iedit 模式，此时所有与该单词相同的部分会高亮显示，
;;    编辑其中一个区域，其他区域会同步更新。
;; 3. 当编辑完成后，按下 C-c C-c 结束 iedit 模式。

;; 为 iedit-dwim 绑定一个快捷键，比如 M-I（Alt + I），你可以根据自己的习惯更改：
(global-set-key (kbd "M-I") 'iedit-dwim)

(use-package multiple-cursors
  :ensure t)

;; multiple cursor
(global-set-key (kbd "C-M->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; --- dirvish ------------
;; 安装 dirvish
(use-package dirvish
  :straight t
  :defer nil  ;; 启动时立即加载
  :config
  ;; 开启 Dirvish 模式
  (dirvish-override-dired-mode)

  ;; ✅ 主题设为图标（你已安装 all-the-icons 和字体）
  (setq dirvish-theme 'icons)

  ;; ✅ 默认不显示隐藏文件（可透过 `h` 切换）
  (setq dirvish-show-hidden-files nil)

  ;; ✅ 避免访问系统文件造成的权限错误
  (setq dirvish-hide-details nil)  ;; 显示详细信息
  (setq dirvish-attributes '(all-the-icons file-size subtree-state vc-state))  ;; 显示图标和其他属性

  ;; ✅ 禁止尝试访问受限系统文件
  (setq dirvish-side-auto-refresh nil)  ;; 避免频繁触发文件扫描
  (setq dirvish-side-follow-current-file nil)  ;; 不要追踪当前 buffer 文件

  ;; ✅ 缓存设置
  (setq dirvish-cache-dir (expand-file-name "dirvish-cache" user-emacs-directory))

  ;; ✅ 快捷键提示
  (define-key dirvish-mode-map (kbd "?") #'dirvish-dispatch) ;; 显示可用命令
  (define-key dirvish-mode-map (kbd "TAB") #'dirvish-subtree-toggle) ;; 子目录展开
  (define-key dirvish-mode-map (kbd "a") #'dirvish-quick-access) ;; 快速访问
  (define-key dirvish-mode-map (kbd "f") #'dirvish-file-info-menu)
  (define-key dirvish-mode-map (kbd "y") #'dirvish-yank-menu)
  (define-key dirvish-mode-map (kbd "N") #'dirvish-narrow)
  (define-key dirvish-mode-map (kbd "h") #'dirvish-history-jump)  ;; 历史目录跳转
  (define-key dirvish-mode-map (kbd "s") #'dirvish-setup-menu)

  ;; ✅ 启用图片和音频预览（跳过 vipsthumbnail）
  (setq dirvish-preview-enabled t)
  (setq dirvish-preview-dispatchers '(image audio))  ;; 避免 text 触发错误

  (message "✅ Dirvish 加载完成"))

;;; --- Completion 基础 ---
(use-package corfu
  :straight t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)              ;; 自动弹出
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (corfu-preselect 'prompt)
  (corfu-popupinfo-mode t))   ;; 显示文档 (类似 company-quickhelp)

(use-package corfu-popupinfo
  :after corfu
  :ensure nil
  :custom (corfu-popupinfo-delay 0.2))

;;; --- CAPE：额外补全功能 ---
(use-package cape
  :straight t
  :init
  ;; 常用补全绑定（可选）
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; 安装并配置 rainbow-delimiters 插件
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  ;; 自定义括号嵌套层级的颜色（可调整）
  (set-face-foreground 'rainbow-delimiters-depth-1-face  "#7fbbb3") ; 淡青
  (set-face-foreground 'rainbow-delimiters-depth-2-face  "#83c092") ; 淡绿
  (set-face-foreground 'rainbow-delimiters-depth-3-face  "#dbbc7f") ; 黄色
  (set-face-foreground 'rainbow-delimiters-depth-4-face  "#e69875") ; 橙红
  (set-face-foreground 'rainbow-delimiters-depth-5-face  "#d699b6") ; 粉紫
  (set-face-foreground 'rainbow-delimiters-depth-6-face  "#a7c080") ; 浅绿
  (set-face-foreground 'rainbow-delimiters-depth-7-face  "#e67e80") ; 红色
  (set-face-foreground 'rainbow-delimiters-depth-8-face  "#a3be8c") ; 浅草绿
  (set-face-foreground 'rainbow-delimiters-depth-9-face  "#d08770") ; 土黄
  ;; 非法括号颜色
  (set-face-foreground 'rainbow-delimiters-unmatched-face "#ff0066"))

(use-package vterm
	:ensure t)

(use-package lv
  :straight t)

;; 快速跳转增强插件：avy（可视化跳转字符/单词/行）
(use-package avy
  :ensure t
  :defer t
  :bind
  (("M-g c" . avy-goto-char)         ;; 跳转到指定字符（当前窗口可见区域）
   ("M-g 2" . avy-goto-char-2)       ;; 跳转到一对字符（更精准）
   ("M-g w" . avy-goto-word-1)       ;; 跳转到以某字符开头的单词
   ("M-g l" . avy-goto-line))        ;; 跳转到指定行
  :config
  ;; 设置跳转提示风格：预览字母提示（默认 'pre）
  (setq avy-style 'pre)

  ;; 如果你觉得按键提示太快消失，可手动设置等待时间（单位为秒）
  (setq avy-timeout-seconds 2)
  (message "🚀 avy 快速跳转已加载"))

;; Separedit (這是編輯註釋的神器，強烈建議保留)
(use-package separedit
  :straight t
  :bind ("C-c '" . separedit))

(use-package neotree
  :ensure t
  :bind ([f8] . neotree-toggle)) ; 设置快捷键 F8 开关

(setq completion-styles '(orderless))
(setq tab-always-indent 'complete)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode)
  :custom
  ;; ✅ 启用持久化历史记录
  (undo-tree-auto-save-history t)
  ;; ✅ 设置统一保存目录
  (undo-tree-history-directory-alist
   `(("." . ,(expand-file-name "Undo-tree/" user-emacs-directory))))
  :config
  ;; 创建目录（如果不存在）
  (let ((dir (expand-file-name "Undo-tree/" user-emacs-directory)))
    (unless (file-directory-p dir)
      (make-directory dir t))))

;; 删除超过 7 天的 undo 文件（可选）
(run-at-time "1 day" (* 24 60 60)  ;; 每天执行
             (lambda ()
               (let ((dir (expand-file-name "Undo-tree/" user-emacs-directory)))
                 (when (file-directory-p dir)
                   (dolist (file (directory-files dir t "\\.~undo-tree~$"))
                     (when (> (float-time (time-subtract (current-time) (nth 5 (file-attributes file))))
                              (* 7 24 60 60))  ; 超过 7 天
                       (delete-file file)))))))

(provide 'init-package)
