# 原神快捷鍵小幫手【國服版專用】（轉自[ganlvtech](https://github.com/ganlvtech/genshin-impact-ahk)）[俢改版]
首先明確，這是輔助按鍵腳本，而不是外挂，不含有作弊功能。


## 功能 （`Alt+N` 暫停/啟用所有的熱鍵）
* 按住 `F` 等於狂按 F（配合滚輪用於快速撿東西/跳過對話）
* 按住空格等於狂按空格（用於跑跳和解除冰凍狀態，有約 1 秒延遲，用於從浪船起飛）
* 連續按兩次 `W` 等於按住 `W`（用於跑圖），然后按 `W` 或 `S` 可以取消按住狀態
* 按鼠標側鍵 `1` 等於按 `W`（用於跑圖任務），連續按側鍵 `1` 等於按住 `W`
* 按鼠標側鍵 `2` 等於按 `F`（用於任務對話）
* 按住鼠標側鍵 `2` 等於按住 `ALT`（顯示鼠標）
* 按住鼠標中鍵等於狂點鼠標左鍵（用於靠普通攻擊輸出的角色/跳過對話）
* 連續按兩次 `H` 鍵自動 4 秒元素視野/長按則手動元素視野（映射為鼠標中鍵）【可自行調整秒數】
* 右 `Ctrl` 鍵為切换跑步、行走（映射為左 `Ctrl` 鍵）【預設關閉】
* `` ` `` 鍵改為呼出快捷輪盤 （映射為 `TAB` 鍵）
* `TAB` 鍵為按右下角的確定按鈕/領取紀行/10抽/傳送/...(總之右下角的按鈕都行)
* 按住 `TAB` 鍵為左鍵砍樹（0.6 秒攻擊一次）
* `P` 鍵為替換聖遺物 （需先點選聖遺物再按p鍵）
* `F1` 是隊伍選擇頁面（映射為 L 鍵）【預設關閉】
* `F2` 是好友頁面（映射為 o 鍵）【預設關閉】
* `F8` 用於强化聖遺物，點開聖遺物强化頁面，鼠標放在一個素材上，會自動選擇接下来的 6 個然后强化。【適用於手動選擇/5*狗糧】
* `F9` 用於强化聖遺物，點開聖遺物强化頁面，使用自動置入。【請自行選擇消耗等級】
* `F10` 是 5 個探索派遣。【可自由更改，如不知如何定位請無視】
* 在隊伍選擇頁面，`A` 和 `D` 可以左右切換隊伍，按 1~4 可以選中角色，按空格可以讓角色加入或退出隊伍，按 `TAB` 鍵選擇當前隊伍。
* 對話時按 1~7 選擇對應的選項。

## 原作者的話
我觉得很好用的就是，单靠鼠标就可以按 W 前进，可以右键冲刺，可以左右移动视角转弯，可以按 F 对话，可以按 F 捡东西，可以靠滚轮调整捡东西选项，可以按 Alt 调出界面，可以进行简单的攻击，可以按 Alt 点技能。

跑图任务基本上可以靠鼠标解决，右手拿着鼠标，甚至躺着就能做任务。解放左手，你甚至可以用左手做任何事情。

Tab 键用来点右下角的按钮，这样就不用鼠标去找位置点了。

## 使用需知
1. 與鼠標位置相關的功能都是在 1920x1080 **全屏幕**下制作的，其他分辨率需要自己手動修改坐標。
2. 如有需要, 可以使用`ALT+N`停止插件運行, 再次`ALT+N`即可繼續使用

## 更改/開啟/關閉熱鍵的方法
開啟方法：把 `;這是熱鍵設定` 的`;`刪除即可 \
關閉方法：在 `這是熱鍵設定` 最前面加入`;`即可 （例: `;這是熱鍵設定`） 

| 可更改內容 | 更改方法 | 備註 |
| :-------: | :-----: | :---: |
| 元素視野秒數 | 設定秒數(1000為1秒) | |
|  派遣位置  | 更改x1,y1,x2,y2,x3,y3座標 | 如你有任一定位工具, 可自行更改 |

## 使用方法
[到這裡選版本](https://github.com/thc282/genshin-impact-ahk-tools/releases)，下載ZIP檔並解壓。 \
然后雙擊運行 `原神ahk.exe` 。
<details>
  <summary>如何關閉插件</summary>
  
  1. 打開工作列的選單, 並在插件上`右鍵`.
  2. 選擇Exit \
  ![ExitAppGuide](GuideExit.jpeg)
</details>

## 來自作者的免責聲明
我自己從開服到現在一直在正常使用，沒有被封號，但這不代表以后不會被封號。

你可以隨意免費地使用、修改、傳播本工具，但是如果造成封號或其他問題，本工具作者不承擔任何責任。

歡迎對本工具進行適度宣傳。

## TODO
- [ ] 有空可能會更新各比例的版本~
- [X] 自動檢測當在聊天時停用插件 (等待發佈)
- [X] 自動檢測當在登入介面時停用插件 (等待發佈)
