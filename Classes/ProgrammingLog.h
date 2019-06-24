//
//  ProgrammingLog.h
//  AudioTag
//
//  Created by Chang Wayne on 11/9/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef AudioTag_ProgrammingLog_h
#define AudioTag_ProgrammingLog_h

/**

 a. Favorite_ViewController頁面的項目，撥放列表內的項目要能調整撥放順序。這樣比較實用。(UITableView中移動項目的方法：http://furnacedigital.blogspot.tw/2012/02/uitableview_13.html  )
 c. 目前正在撥放的TableView Cell顯示不同底色
 e. 記得把所有用到別人的程式或圖片等，加上License宣告。
 f. progress bar時間可以列出-xxx，剩餘時間。(一般撥放器好像都會列)
 g. Edit-viewcontroller 美化。
 h. Playing-viewcontroller等非tableview的劃面邊框看能否用程式畫出來，增加美觀。
 i. 動態多國語言。
 j. 版權頁說明的規劃。可參考line tools或揪科。
 */


// [102.07.15]
// 1. 將主要的View_Controller都改成多國語言(目前中英文)。其他TvbCell及3rd Party都還沒改。

// [102.07.14-2]
// 1. 針對升級iOS6及XCode 4.6.3所產生的Project Alarm及Warning進行修正。(有些合理性的錯誤被XCode 4.6.3找出來，另外就是有些函式不支援，例如，TextView元件的背景顏色函式被取消了，必需重拉該元件。)

// [102.07.14-1]
// 1. 將Core Data的Preferences Entity加上language. (主要是記錄多國語言設定值)
// 2. 增加AppDefineWords.h檔案，裏面記錄一些常用的定義字。並且把APP裏所有的define words通通搬到這個檔案裏。
// 3. 在Playlist_ViewController新增一個Button切換中英文，並實做簡單的文字改變測試。測試OK。

// [102.07.13]
// 1. 新增判斷APP啟動時，AudioTag.sqlite資料庫檔是否存在，若不存在，自行產生一個。
// 2. 修正若APP載入自行產生的AudioTag.sqlite資料庫，由於Last_open_Tag不存在而發生的Bug.(利用numNeedToUpdate_EditVC判斷)
// 3. 修正新增Tag時，正在編輯Tag Name然後跳到選AB Time時間再跳回時，Tag Name及Comment會被清掉的問題。
// 4. 將原本測試的saveInitialDataToDB函式名改成saveInitialDataToDB_Test
// 5. 修正querryIndexOfObjectOfArray_Mp3_EntityByString及querryIndexOfObjectOfArray_Tag_EntityByString若找不到對應的資料會回傳-1。原本回傳0會造成誤會是index 0有資料。

// [102.06.26]
// 1. 利用在各個ViewController加上ViewDidAppear及ViewWillDisappear加上呼叫系統撥放工具event的攔截函式，解決原先只能在Playing_ViewController頁面離開App後，能使用系統撥放工具。(以後只要有新增畫面(ViewController)都必需加相對應的Code)
// 2. 修改Playing_ViewController的上一首及下一首圖示，並且設定只有在LST撥放中才會把那二個Button設為Enable。
// 3. 系統撥放工具(Remote Control)的下上一首的Button目前Apple沒有提供API設定Disable。所以，針對RemoteControlEvent設定當LST撥放中點選上下一首的Button才有作用。
// 4. 新增建立Tag時，Check是否含".mp3",".Mp3",".mP3","MP3"等字眼的Tag name。如果有，發出警告，無法儲存，免得TagName跟Mp3 Name發生衝突。

// [102.06.17][102.06.24]
// 1. 將Sandbox, Tag, Favorite_TvbCell裏的星星圖片換掉，換成較平面化有去背的圖片。
// 2. 調整Sandbox, Tag, Favorite_TvbCell裏星星圖片的size到40x40。
// 3. 試圖解決利用系統的撥放工具，下一首或撥放/暫停，只有在本App停留於Playing_ViewControl頁面後縮到背景，才會有用的Bug，但是無效。(嘗試在Sandbox_ViewController的ViewDidAppear及ViewWillDisappear加上呼叫系統撥放工具event的攔截函式，但是沒用... Orz)

// [102.06.16] 
// 1. 新增Edit_BG_ViewController裏PickerView依照AB Time的大小進行判斷。若ATime大於BTime就發Alarm，並且若按下Cancel Button將會自行判斷帶回原default值。
// 2. 調整Playing_ViewController、Edit_BG_ViewController以及Edit_ViewController的某些Button字型為System Bold，較為清楚醒目。
// 3. 調整Edit_ViewController畫面Layout。

// [102.06.15]
// 1. 完成Edit_BG_ViewController裏的PickerView點選後，將數值帶回Edit_ViewController並且順利儲存。(看似簡單，問題一大堆啊，花了我超多時間...)
// 2. 註解掉Edit_ViewController於do_SaveTag後AlarmView的Code。因為下面不會執行到，會產生誤會。
// 3. 在新增AppDelegate.isTheSameNameTag_Update變數，判斷是否發生同名Tag有資料更新。
// 4. 在Edit_BG_ViewController新增一個顯示A Key或B Key的圖形Button。

// [102.06.14]
// 1. 拿掉Favorite_ViewController裏Navigation Left Button。(原本設定單曲或List撥放改在Playing_ViewController裏的Button)
// 2. 調整Playing_ViewController的元件Layout。(所有元件置中，新增單曲或List設定Button，將Loop Button跟List Button還有A B Key放在同一排，並且用程式將Button的外框及顏色調整出來)
// 3. 修改原先如果不是Loop撥放，放到List最後一首若在按"下一首"會將目前撥放這首(Tag or Mp3)又重頭撥放。改為不影響目前撥放。
// 4. 修正若設定不是Loop撥放，當目前撥放是List的第一首時，再按下"上一首"會發生閃退情況。(Bug)

// [102.06.12]
// 1. 在Utility裏新增MinuteTimePartWithFormatString以及SecondTimePartWithFormatString二個公用函式，主要用途是將時間格式的字串(xxx:xx)的分及秒分離出來使用。
// 2. 將Edit_ViewController的AB Time的textfield元件改成UIButton元件，並且新增點選該AB Time button連結到時間的PickerView，並且把相關的AB Time帶入PickerView，而且在"分"的欄位依AB Time進行最大值判斷。
// 3. 新增進入Edit_BG_ViewController時，把Navigation的Backbutton隱藏，待回到Edit_ViewController後再顯示。
// 4. 將Playing_ViewController的撥放Button用程式的技巧加上邊框，並且把Single或Loop撥放的button調整一下。
// 5. 將APP Icon改為草帽，並且把進入畫面改為藍底右下角是WLY圖。
// 6. 將Favorite_ViewController左上角的撥放模式Button(Single or List)放到Playing_ViewController裏。並且將原本的位置放Edit Button與Sandbox及Tag頁面一致。另外，把Edit Button用圖片代替文字。

// [102.06.09]
// 1. 新增UIPlcikerView在Edit_BG_ViewController，主要做為AB Time的設定使用。(目前只是把元件擺上，DataSource跟Delegate都設定好，尚未對A,B Time進行對應)
// 2. AB Time的設定，只到分秒之外，不到小時。意思就是說，如果某MP3的Duration是1小時10分，在設定AB Time跟顯示上都會是70分鐘，而非顯示1小時10分。
// 3. 新增當進入Edit_ViewController時，把Navigation的Right Button給Disable，若從Edit_BG_ViewController跳回Edit_ViewController時，再設定回Enable。 

// [102.06.06]
// 1. 新增儲存同名Tag判斷機能，Tag存檔時，若同樣Tag Name，必需有警告的Alarm Box說明是否覆蓋。實作上，要先刪掉舊的，再存新的，就可以維持獨一的Tag Name了。(但是Playing_ViewController的資訊還是之前舊同名Tag資料。以上是功能設定問題。所有刪除Tag或是儲存及覆蓋原Tag都是在下一個選擇操作後有效)

// [102.06.05]
// 1. 新增當撥放時，才能調整上一首及下一首。
// 2. 修改Play_ViewController左上角的歌曲狀態顯示。(讓顯示更清楚且美觀)
// 3. Tag存檔時，若同樣Tag Name，必需有警告的Alarm Box說明是否覆蓋。實作上，要先刪掉舊的，再存新的，就可以維持獨一的Tag Name了。(還沒做，但看來不難做，但驗證要留意) //做完了。
// 4. 暫時放進一個載入畫面的圖片。

// [102.06.03]
// 1. 新增撥放下一首的功能。如果在單曲模式下按下一首，就會回到這首的最前面開始撥放。如果是Favorite列表模式，就會撥放下一首。
// 2. 發現一個Bug。就是利用系統的撥放工具，下一首或撥放/暫停，只有在本App停留於Playing_ViewControl頁面後縮到背景，才會有用。(目前暫訂不改，以APP內的撥放機能為主)
// 3. 新增撥放下一首的功能。
// 4. 記得設定只能讓撥放時，上一首及下一首有效。(還沒做)


// [102.05.29]
// 1. 將Sandbox的TabIcon文字改為Mp3，看起來較直覺。
// 2. 將About畫面的作者加上小黃貓
// 3. 修改loop play切換的圖示。(仍然覺得醜...Orz)
// 4. 把Playing_ViewController的lblAkey_Sign及lblBkey_Sign改成imgvAKey_Sign及imgvBKey_Sign，並加上圖片以美觀。
// 5. 加了暫時版的App Icon。使用WLY的圖。

// [102.05.26]
// 1. 修改Playing_ViewController的畫面layout。把PlayOrPause, Next, Previous, SingleOrLoop這幾個按鍵換成圖型化。
// 2. 將Tabbarcontroller的Sandbox, Tag, Favorite, About加上圖示。

// [102.05.19]
// 1. 把AudioTagAppDelegate裏的playlist_VC setTitle:@"Playlist"設為"About"。

// [101.09.11]
// 1. 將Core Data的Preferences Entity加上elements_order_of_playlist. (主要是記錄Favorite裏面的項目資料及順序)
// 2. 在Favorite_ViewController的ViewDidLoad實作將elements_order_of_playlist的NSString，切成MutableArray。(後續還要再把Favorite Items序列化實作完)

// [101.09.10]
// 1. 將原本Edit_ViewController右上角的do_saveTag Button及函式改為Edit_BG_ViewController。(因為Navigation的PushViewController主體是Edit_BG_ViewController)

// [101.09.05]
// 1. 新增Edit_BG_ViewController，這個ViewController是為了配合XBPageCurl元件所產生的。因為XBPageCurl如果要翻起來的話，必需是翻最上面的UIView。然而，我希望被翻起的是Edit_ViewController而底層是Edit_BG_ViewController，所以，必需把Edit_BG_ViewController當Base，然後AddSubView Edit_ViewController，讓Edit_ViewController成為Edit_BG_ViewController其中的一個View，並且在最上層。除此之外，這種做法Edit_ViewController裏的ViewWillAppear並不會在被顯示時呼叫，必需利用Edit_BG_ViewController:ViewWillAppear被呼叫時，自行呼叫Edit_ViewController:ViewWillAppear。
// 2. 調整Edit_ViewController透過XBPageCurl元件的捲動參數，使之下方有足夠空間可以擺放物件，e.g.控制滑輪..。(控制一個圓柱的參數)
// 3. Edit_ViewController在編輯Comment時，下方的鍵盤擋到編輯區。已將Edit_ViewController裏所有Views通通以Core Animation動畫移動處理。

// [101.09.04]
// 1. 在Playlist_ViewController測試XBPageCurl元件實做。結果發現，被翻起下方的ViewController一定要當Base，上方要被翻的ViewController要當成一個View被AddSubView進下方的ViewController。

// [101.09.03]
// 1. 加入XBPageCurl(3rd Party Open Source)。應用的部分還沒實作。

// [101.08.29]
// 0. 第一次引用3rd Party Open Source，真的很興奮啊！(原來使用ARC還要特別在m檔加上compiler flag，又學到了)
// 1. 完成Playing_ViewController的音量調整會出現HUD。(引用3rd Party open source，SVStatusHUD)
// 2. 解決程式初啟動時，直接點選Playing_ViewController頁面，所造成的畫面顯示資訊不正確或音量調整功能無效等問題。(原因是，appDelegate.avapPlayer這個變數還沒有值，歌曲還沒被載入所致。)
// 3. Playing_ViewController加上音量小圖
// 4. Edit_ViewController在編輯Comment時，下方的鍵盤會檔到編輯區。所以，必需把整個Sub View在進入編輯時，全部往上移，然後退出編輯時，再全部移下來，回到原位。(使用Core Animation動畫處理)

// [101.08.28]
// 1. 完成Playing_ViewController的ProgressBar加上A B Key的標示機能。MP3及Tag都沒問題了，也解決一個撥放換mp3/tag會造成A B Key標示消失的問題。

// [101.08.27]
// 1. 完成Tag_ViewController及Favorite_ViewController下的TableView Cell顯示部分Tag的Comment資訊。
// 2. 完成Playing_ViewController以及Edit_ViewController顯示Comment的連結對應。(已可顯示正確的Comment資料)
// 3. 把Playing_ViewController的畫面Layout修改一下。
// 4. 在Playing_ViewController的ProgressBar加上A B Key的標示。(目前Mp3模式的正常，但Tag的還不正常要Debug)

// [101.08.26]
// 1. 將Sandbox_ViewController及Tag_ViewController左上角的Edit Button，若其轉換為Done，背景顏色改為淡藍色，以提醒使用者按下該鍵以完成Edit動作。
// 2. 將Sandbox_ViewController, Tag_ViewController以及Favorite_ViewController右上角Playing按鍵顏色換成黑色。(跟iPhone版iTunes一樣style)
// 3. 將Sandbox_ViewController, Tag_ViewController以及Favorite_ViewController裏TablViewCell裏顯示mp3/tag名稱的寬度加大，讓文字可以盡量顯示。
// 4. 將Sandbox_ViewController顯示Duration的位置調整跟Tag_ViewController以及Favorite_ViewController一樣，保有一致性。
// 5. 在Tag_TvbCell增加一個lablel元件及lblSimpleDescription屬性，可顯示部分的Tag的Comment資訊。(但還沒完全實作完)

// [101.08.08]
// 1. 測試了一下。如果Favorite_playlist裏含的mp3，該檔案被透過iTunes移除掉之後，在Favorite_ViewController頁面，就自動不會顯示出來。如果mp3檔案再透過iTunes放回iPhone裏，該mp3就不屬於Favorite_playlist中。(自動從Favorite_Playlist中刪除)
// 2. 如果Tag所連結的mp3檔案被從手機中刪除，並且該Tag也被標入Favorite_playlist中的話。進入Favorite_ViewController時，自動會把該Tag從Favorite_playlist中刪除。(解除星星)
// 3. 測試了一下，如果原本在Favorite_playlist有被標記的mp3或tag，該正在撥放的mp3或tag連結的mp3檔案消失的話，會出現mp3檔案格式錯誤的Alarm message.(正確)
// 4. 修正當Favorite_playlist裏的Tag/mp3正在撥放時，直接刪掉Favorite裏的標記星星，會造成當機問題。
// 5. 如果刪光Favorite裏的項目(tag/mp3)時，左上角的PlayType直接設定為SINGLE並且強制指定為temp_playlist。
// 6. 在Playlist_ViewController加上短暫的版本識別。並且將原先TableView的東西先設定為空白，上方Banner右Button設為Disable。

// [101.08.02]
// 0. 太爽了！！！！頗具難度的列表撥放功能完成了，而且也把長久以來快速拉Progress Slider問題搞定了。蘇拉颱風，...妳讓我high了！
// 1. 將AudioTagAppDelgate裏的numPlayType註解掉，使用appDelegate.dataFromSqlite._preferences.last_opened_playlist來判斷是否為列表撥放(List)
// 2. 用來讀取撥放列表下一首的函式getNextPlayInfo無法正確抓到資料，改由新增strTheNextPlayName以及*numIsTagTheNextPlay二個成員透過Notification記錄，再傳回。(証實有效)
// 3. 更新Favorite_ViewController:ViewDidLoad以及ViewWillAppear函式，讓左上角切換是否列表撥放的Button，可以依appDelegate.dataFromSqlite._preferences.last_opened_playlist動態改變文字狀態。
// 4. 解決當使用者快速在Playing_ViewController的sliderbar拉到最右邊，會造成撥放中斷問題。(使用者一次就把sliderbar拉到最右邊，因為可能會造成audioPlayerDidFinishPlaying不會被呼叫到，而撥放中斷。所以，當使用者拉sliderbar時，如果拉超過最右邊，就自動減1，會先等1秒再結束，確保正常撥放完畢。)
// 5. 完成列表撥放功能。mp3下一首接mp3, mp3下一首接tag, tag下一首接mp3以及tag下一首接tag都沒有問題。而且，LOOP撥放時，撥到最後一首後，會回到第一首重新撥放。如果不是LOOP撥放時，撥到最後一首會停住。
// 6. 在Tag_ViewController頁面，如果該Tag所連結的mp3是無效的，tableView:cell裏的字會顯示灰色，而且無法點擊。

// [101.07.25]
// 1. 試過從Playing_ViewController發Notification給Favorite_ViewController，再由Favorite_ViewController發Notification回來給Playing_ViewController以完成列表順序撥放的功能，但結果是行不通！！！因為已經身處Playing_ViewController就不能再Push一次Playing_ViewController。所以，改由在Favorite_ViewController開介面去查下一個撥放的名稱及是Tag還是Mp3屬性，然後直接在Playing_ViewController撥完之後，去調用Favorite_ViewController開的介面，然後進行下一首撥放。這個方法目前Mp3接著下一首mp3都很正常也OK，不過，如果目前是Tag接下一首mp3、mp3下面接tag或tag下接tag都還沒完成。這也是接下來的目標。
//  下次記得可以利用last_opened_playlist來辨識是否為favorite撥放列表。就可以取代appdelegate.numPlayType，並且可儲存於database裏。
// 2. 在Utility類別下，新增querryIndexOfArrayByString函式。功能是將傳入的字串Array以及某字串，回傳該字串在Array裏的Index。
// 3. 新增在Playing_ViewController下，如果撥放Favorite Playlist的話，會顯示PLT。(撥放mp3會顯示MP3，撥放tag會顯示TAG)


// [101.05.23]
// 1. 在AudioTagAppDelegate下新增numEnablePlayFavoriteList，做為Favorite List順序撥放的開關。目前，只有當從Favorite_ViewController點選TableView，才會設定YES，否則，若從Sandbox_ViewControoler或是Tag_ViewController點選TableView都會設NO。
// 2. 在Sandbox_ViewController進行ViewDidLoad時，原本先呼叫Tag_ViewController:ViewDidLoad再切換回Sandbox_ViewController。目前改為當切換到Tag_ViewController:ViewDidLoad時，再切到Favorite_ViewController:ViewDidLoad，最後再切回Sandbox_ViewController。主要目的是為順序撥放Favorite List做準備。
// 3. 在Favorite_ViewController:ViewDidLoad呼叫refreshTableView，以更新self.listData以及self.listData_MP3OrTAG_Status。主要目的也是為了順序撥放Favorite List做準備。

// [101.05.09]
// 1. 在Playing_ViewController:ViewWillDisappear加入endReceivingRemoteControlEvents。以結束背景撥放的event接收。
// 2. 在Favorite_ViewController左上方增加一個PlayType Button。(但內容還沒寫完)
// 3. 發現利用instructment檢查程式記憶體狀況，會有Memory Leak發生。網路上查了一下，是iOS 5的Bug.(麻煩~)

// [101.05.01]
// 0. 基本上這個版本目前測起來，mp3單曲撥放、tag單曲撥放、選取mp3或tag為favorite等主要機能，通通OK。
// 1. 在Sandbox_ViewController以及Tag_ViewController新增do_goPlaying_byBtn函式取代do_goPlaing，進行單純切換到Playing_ViewController畫面的動作。
// 2. 處理Favorite_ViewController進行TableView點選撥放Tag的動作。(把Tag_ViewController在TableView點選的函式所做的事，大部分移到do_goPlaying函式裏。方便將來PLAY-TAG的Notification來，可以執行)
// 3. 修正Favorite_ViewControl判斷點選Item為MP3或TAG錯誤的問題。(主要是進到 refreshTableView函式時，必需先將listData_MP3OrTAG_Status裏的東西都清掉，然後再addObject。否則正確值會在裏面一直累積，最後面的幾個元素值才是對的，但是程式卻是抓最前面的，就會造成mp3 or tag的錯誤判斷。)

// [101.04.23]
// 1. 在ProgrammingNote1.h增加了配色表的連結。可以隨時查。
// 2. 為了解決因為程式剛開始若沒有點選Tag_ViewController的TabItem，Tag_ViewController就不會呼叫ViewDidLoad而無法訂閱PLAY-TAG的Notification問題。因此，當程式一進來到Sandbox_ViewController的ViewDidLoad時，就呼叫SetSelectedIndex:1切到Tag_ViewController，然後在Tag_ViewController的ViewDidLoad呼叫SetSelectedIndex:0切回Sandbox_ViewController。
// 3. 利用PLAY-MP3以及PLAY-TAG這二個Notification判斷在Favorite_ViewController所點選的是MP3還是TAG。(下一步就是利用這二個Notification來撥放點選的Item) 
// 4. 在Favorite_ViewController新增一個listData_MP3OrTAG_Status的MutableArray成員，存目前TableView的MP3或TAG狀態。
// 5. 解決因為如果progressBar_slider滑太快，直接滑到結束，sender.value就會直接把值給currentTime，然後就不撥了。而且更重要的是本MP3不算撥放"完畢"。這會造成audioPlayerDidFinishPlaying無法被呼叫，而無法再重撥的問題。

// [101.04.18]
// 1. 在Favorite_TbvCell增加一個顯示目前是MP3或TAG的Label，並依MP3或TAG而有不同的底色顯示。
// 2. 在Favorite_ViewController點選TableViewCell裏的Star Button可以刪除該項mp3或tag在Favorite Playlist裏的內容。
// 3. 新增定義RGBA(r, g, b, a)取代UIColor一長串的rgb及alpha之顏色指定。
// 4. Favorite_TbvCell的Duration及Tag所連結的mp3檔是否存在的警告圖示都能正確顯示。
// 5. 修正當正在撥放mp3 or tag時，若拉動progressBar會有雜音的問題。
// 6. 在一開始第一次要撥放mp3時，在play函式呼叫前，先呼叫prepareToPlay，讓mp3先載入memory，以增加撥放的順暢度。

// [101.04.17]
// 1. 調整Favorite_TbvCell.xib裏面的label文字大小為Fixed。
// 2. 完成Favorite_ViewController的星星按扭可以正常顯示。
// 3. 完成Favorite_ViewController點選TableViewCell裏的Star Button可以刪除該項mp3在Favorite Playlist裏的內容。(在Favorite_TbvCell刪除之後，利用Notification通知Favorite_ViewController更新TableView)
// 4. 完成於Tag_ViewController也能點選星星按扭將Tag加入Favorite Playlist。
// 5. 完成Favorite_ViewController可以顯示Favorite Playlist裏的內容，包含mp3及tag。(並以字母排序過)

// [101.04.16]
// 1. 完成於Sandbox_ViewController點選Star Button可以新增及刪除Favorite Playlist內容。

// [101.04.11]
// 1. 針對Audio撥放，在Remote Control可以進行Play&Pause Toggle。
// 2. 在Sandbox_ViewController的Favorite星星按扭，可以顯示正確有被Favorite_playlist連結到的狀態。
// 3. 修正DataFromSqlite._favorite_playlist及._temp_Playlist指定錯誤問題。

// [101.04.10]
// 1. 將Favorite_ViewController的UITableViewCell改成Custom UITableViewCell。新增了Favorite_TbvCell.h及.m檔，還有Favorite_TbvCell.xib。
// 2. 處理一個撥放Tag的Bug。就是如果二個Tag連結到同一個mp3(只是AB Key或其他屬性不同)，不會重撥tag。
// 3. 在Favorite_ViewController建立測試的函式do_Edit，裏面建立favorite_playlist與任意一個mp3進行連結，並試著顯示出來。結果初步是OK的。接下來就是把點選星星Button的作用給連結進來顯示。
// 4. 將所有xxxx_ViewController的TableViewCell裏的subView做一個size及位置的統一。

// [101.04.09]
// 1. 修改Tag_TbvCell，新增一個UIImageView顯示Tag所連結的Mp3檔案是否存在的狀態。
// 2. Tag_ViewController顯示b_time - a_time的Tag duration.
// 3. Tag_ViewController若點選的Tag所連結的Mp3檔案不存在，就發出Alert Windows警示。
// 4. 調整Tag_ViewController、Playlist_ViewController以及Favorite_ViewController的TableView位置大小以符合全版面。

// [101.04.05]
// 1. 修改ap剛載入時，切換到playing頁面時，tag duration及current time沒有更新的Bug.
// 2. Edit_ViewController與Playing_ViewController AB Key Button值的結合處理。
// 3. Tag儲存完後，跳回Playing_ViewController。
// 4. Tag儲存前，先檢查是否Tag Name有重覆或者為空字串，如果有就發警告。(Tag Name是唯一索引)

// [101.03.31]
// 1. 在AudioTagAppDelegate:didFinishLaunchingWithOptions加入顯示Unhandled Exception之Call stack資訊。這是很重要的Debug訊息。(之前就是沒有這個，我才對3/21 No.1問題查得半死。這要感謝這位大大 http://rayer.blogspot.com/2011/12/ioscode-trace-stack.html )
// 2. 新增Utitlty:timeIntervalWithFormatString，將"aa:bb"這個時間文字格式輸入轉為NSTimeInterval回傳。
// 3. 依照appDelegate.isTagSaved更新Tag_ViewController的TableView。(因為Tag儲存)
// 4. 新增appDelegate.aTimeOfLastOpenedTag以及appDelegate.bTimeOfLastOpenedTag暫存最後一次撥放Tag的ab Time.
// 5. 完成Edit_ViewController:do_SaveTag實作。目前已能任意儲存Tag
// 6. 修正Edit_ViewController於初始化時，無法帶出ab Time問題。

// [101.03.30]
// 1. 雖然解決3/21 No.1的問題，但目前在PlayingViewController:progressBar_SliderMoved會因為讀不到a_time而在滑動slider時，會無法正確顯示及撥放a_time時間。(目前是想到，應該是在Tag_ViewController下，當點選TableView Item之後，把這個Tag相關資訊記錄在appdelegate裏，讓所有PlayingViewController下所有需要該Tag的函式，不會因為目前Core Data的Tag Item被刪，而找不到資訊發生程式當掉或值錯誤的問題。)
// 2. 解決1的Slider問題。目前在AudioTagAppDelegate下新增二個成員aTimeOfLastOpenedTag以及bTimeOfLastOpenedTag，在Tag_ViewController下的TableView點選Item之後，就把該Tag的aTime及bTime都存在上面二個成員中。如此一來，就算該Tag被Core Data刪掉，也不會影響Playing_ViewController頁面相關的程式進行。

// [101.03.29]
// 1. 總算解決3/21 No.1的問題。原因是出在類似以下的程式
//    tag *aTag = [tagArray_MCObj objectAtIndex:indexOfLastOpenedTag];
//  當tagArray_MCObj被刪掉最後一個之後，其count可能會由8變成7，但是indexOfLastOpenedTag還是原本點進去的7。如此就會造成indexOfLastOpenedTag超出tagArray_MCObj的NSArray範圍而發出程式當掉問題。gdb訊息如下：
//  *** Terminating app due to uncaught exception 'NSRangeException',
//  reason: '*** -[__NSArrayI objectAtIndex:]: index 3 beyond bounds [0 .. 2]'
//  在Tag_ViewController下，若點選TableView，會跳進Playing_ViewController，就算切回Tag_ViewController，背後其實還在run Playing_ViewController的東西。也就是，這次我一直把焦點都放在Tag_ViewController仍找不出問題的主因。
//  總之，問題解決了。但要怪就要怪XCode的Debugger，實在太鳥了。除了沒顯示哪個檔案哪一行出錯外，連Call Stack也是只顯示到main.c，實在是鳥極了。(怒)
//  不過，也讓我學到二件事，第一，有時候一塊記憶體在使用的使用，指標別亂指為他用，最好另外用類似arrayWithArray或StringWithString，重新copy一塊記憶體，不然，如果刪掉原來的記憶體，後面指標因為共用關係，而得不到實體，就會掛掉。第二，就是刪除Core Data裏的資料(ContextManagedObject)要特別注意，因為對應的._Mp3或._Tag，有可能因為刪掉了，造成跟當初點進Table View的index範圍不符而發生程式當掉問題。(NSRangeException)
//  不管怎麼說，卡了二三個星期.....算總解決了！！！！！！！(淚)

// [101.03.28]
// 1. 針對3/21 No.1的問題。我試了把所有._mp3以及._tag通通改成直接操作CoreData的ManagedObjectContext，但仍然會當，當的現象跟利用._mp3或._tag一模一樣。除此之外，也將Tag_ViewControl的tvbTagDispaly不使用Xib file連接，改跟sandbox_ViewController一樣在TableView Count函式下指定，但當法仍然一樣。這幾個二個星期來，被這個搞死了...最後，還是找不到問題所在。決定先跳過這個問題了。
// 2. 將CoreData的model，把Tag的linked_mp3這個relationship的delete rule由cascade改為nullity。(因為cascade模式下，如果把Tag刪掉，連結的mp3物件也會被刪掉，這是不合理的)
// 3. 針對3/21 No.1的問題。目前試出來，如果在Tag_ViewControlller不點選最後一個Item進行撥放的話，刪除最後一個Item是沒問題的。剛又試了一下，先把點選Item(didSelectRowAtIndexPath)裏面的東西通通拿掉再試看看，結果也不會當耶...天啊。那代表應該是點了之後進到didSelectRowAtIndexPath函式，函式裏面某個東西影響當機，明天晚上再來一個一個拿掉，看哪個程式出問題。


// [101.03.22]
// 1. 今天再試一下3/21的第1個問題。最後發現，如果直接操作ManagedObjectContext是OK的，但利用DataFromSqlite的成員儲存資料這種方式會造成不知名的問題，而無法trace。所以....決定了，花個二三天時間，把原本利用_Tag, _Mp3這些DataFromSqlite成員，通通改成直接操作CoreData的ManagedObjectContext！！！(怒)

// [101.03.21]
// 1. 如果刪除在Tag_ViewController裏TableView最後一個item，然後在commitEditingStyle裏如果有呼叫[appDelegate.dataFromSqlite loadDataFromDBToMemory]就會當掉。...這問題很嚴重，還要查一下。
// 2. 刪除ManagedContext裏面的Tag時，如果該Tag連結到某個mp3，就會連那個mp3的實體一塊刪掉。但如果有其他Tag也連結同一個mp3就會出問題了。這裏利用在刪除Tag之前，先將linked_mp3先設為nil再刪除，mp3實體就會留著了。
// 3. 在Sandbox_ViewController裏的ViewDidUnload加上self.tvbSandboxDisplay = nil，以把member記憶體釋放。

// [101.03.16]
// 1. 修正saveSandboxMp3sToDB裏呼叫loadDataFromDBToMemory的時機。
// 2. 新增querryIndexOfObjectOfArray_Tag_EntityByString函式，透過該函式找到某字串在_Tag下的index
// 3. 把sortMArrayInStringOrder之排序函式，放在Utility類別中
// 4. 將Tag_ViewController在列上Tag時，進行排序後再列上TableView，並且在刪除某個Tag時，也能正確刪除完成。
// 5. 發現一個可能是iOS5的Bug....於ProgrammingLog.h最上面說明。

// [101.03.14]
// 1. 配合XCode升級4.3.1，將AudioTag專案進行轉換以符合新版XCode。
// 2. 將3.13的修改測了一下，Tag的刪除以及連結重建已經OK了。但有些Log為啥顯示不出來，這要再追一下code。

// [101.03.13]
// 1. 把dataFromSqlite、Sandbox_ViewController以及Tag_ViewController這三個類別的Code完完全全仔細看過而了解其中的運作。並且，把之前101.03.11的問題進行解決。目前Code已經改好，但因為要等XCode 4.3.1下載完且安裝好才能測試實機，所以，明天再試吧。最好能把Sandbox及Tag完全測過。
// 2. 加入ProgrammingNote1.h。裏面加一些開發說明文件。(為了不要讓ProgrammingLog.h越來越長...)

// [101.03.11]
// 1. 主要建立Tag刪除機制。(但裏面問題不少，雖然功能做出來，但還是不太穩。找時間重新再檢視過。理論上，不該這麼複雜的。)

// [101.03.10]
// 1. 修改Documents目錄下的副檔案如果為MP3或mP3或Mp3就不處理，只處理mp3的bug。(理論上mp3的大小寫組合都要處理)
// 2. 新增Utility類別，主要放置一些各類別會用到的公用函式。(目前新增showNSStringArrayInConsole以及checkDifferenceBetweenDocDirToArray)
// 3. 將Utility.h及Utility.m用Doxygen格式註解，並於ProgrammingLog.h加入二個範例Header，也加入XCode 4的snippets
// 4. 針對3/6第一項的做法做更新，因為原本同步資料庫及重建Tag連結是放在ViewDidLoad裏，但後來為了解決當AudioTag程式沒關閉，而iTunes經人為加入或刪除mp3檔案時，會造成Sandbox TableView沒更新。因此，也在ViewWillApper再呼叫ViewDidLoad。不過，這個會造成同步資料庫及重建Tag的事做二次，很沒有效率。因此，把相關的Code移到ViewWillAppear，也就只做一次，效率加倍。
// 5. 當使用者還開著AudioTag程式時，手動透過iTunes把一些mp3檔案刪掉。這時候，如果還沒切換畫面進行ViewWillAppear把listData更新，UITableView就會認為listData裏有東西，就會透過這個getDurationFromMp3Filename函式取得撥放時間，而實際上找不到該檔，就會進到該函式的開檔錯誤處理而跑出錯誤的Alert視窗。(解決方式：把Alert視窗那部分的Code Mark掉，讓duration回傳0，反正不會影響程式進行)
// 6. 承5的情況，若此時畫面停留在SandBox_ViewController，使用者透過iTunes刪除mp3檔案。若切到別的畫面再切回來時，這時會進到ViewWillAppear函式裏，而更新listData的資料，但TableView的資料還是舊的，就會造成程式當掉。(解決方式：更新完listData後，再重新把TableView LoadData就行了。)
// 7. 總算徹底把使用者會透過iTunes在可能的時間點或程式狀態加入或刪除mp3檔案的情況通通想清楚，並且做了相關的防護措施。果然要寫出功能不難，要讓任何人都用不掛，這才是真功夫啊。淚~~

// [101.03.06]
// 1. 發現如果目前AudioTag AP還開著時，用iTunes將mp3拉進Documents裏或刪除，AudioTag的Sandbox頁面不會更新。除非，讓AP整個Terminate掉再重開才會更新(因為才會進入ViewDidLoad)。目前新增在ViewWillAppear裏面再呼叫一次ViewDidLoad重新更新一次。如果iTunes新增或刪除mp3後，只要切離sandbox再切回來，就會更新了。
// 2. 但依照1的做法會發生，當切離sandbox再切回來，由於連結TableView的listData已經被改變了(刪除或新增)，變得跟TableView上的元素不同，就會造成顯示錯誤。目前希望可以從saveSandboxMp3sToDB，當Check過有新增或刪除mp3時，該函式回傳一個Array告知是新增listData第幾個或刪除listData第幾個元素，然後再進入TableView的delegate之前，先把TableView該元素先刪掉，如此就不會有問題了。(但還沒實作，明天再弄好了)
 
// [101.03.03]
// 1. 將Tag_ViewController裏的TableView設計為Custom TabViewCell。目前設計跟SandBox_TbvCell一樣。
// 2. 將一些檔案實際存取的路徑改為一致。統一*.h及*.m放在classes下，而*.xib放在外面。(如果要搬不要直接搬，最好由XCode裏面檢視Xib的屬性去設定路徑，或是COPY一份檔案到要的路徑再拉到XCode管理，然後把原先的在XCode裏刪掉，不然會XCode會出現Warning。...超麻煩的)

// [101.03.02]
// 1. 新增DataFromSqlite:showEntryMp3InConsoleFromMemory函式，顯示mp3 Entity裏所有物件於console
// 2. 新增DataFromSqlite:showNSStringArrayInConsole函式，將一個字串Array的所有物件顯示於console
// 3. 新增DataFromSqlite:sortMArrayInStringOrder函式，將Array進行排序
// 4. 新增DataFromeSqlite:querryIndexOfObjectOfArray_Mp3_EntityByString函式，取得特定字串在mp3 Entity Array的位置。
// 5. 在Sandbox_ViewController裏，當在tableview按下刪除檔案時，除了刪除檔案、tableview對應的array、tableview本身之外，還加上要刪除Mp3 Entity裏的資料。(Mp3 Entity Array裏面是亂的，並沒有排序，所以必需靠querryIndexOfObjectOfArray_Mp3_EntityByString找到Array位置，而不能利用tableView所對應的array(有排序的)來找，不然會有錯。(就是這個錯，搞了一晚上...)

// [101.02.29]
// 1. 新增DataFromSqlite:rebulidMp3LinkForTags函式，處理Tag與linked_mp3連結重建的事。
// 2. 完成Tag與linked_mp3連結重建機能。(目前做幾個case的測試都ok，也許有空再多做一些測試。不過，做完disk-mp3與sqlite-mp3同步以及sqlite-tags連結重建機制，真的很有成就感。哈)
// ==>接下來Tag_ViewController底下的相關機能，就會比較容易處理了。喔耶~~

// [101.02.27]
// 0. 每次只要處理跟CoreData或Sqlite資料庫有關的東西都超級花時間的...而且也很複雜。(今天連續花了六小時弄這個。淚~)
// 1. 規畫出disk-mp3與sqlite-mp3同步以及sqlite-tags連結重建機制。(如上, ProgrammingLog.h)
// 2. 在CoreDate裏的tag Entity加入linked_mp3filename之attribute。(為了處理sqlite-tags連結重建機制使用)
// 3. 修改DataFromSqlite裏saveSandboxMp3sToDB函式。完成處理實體儲存的mp3檔案(disk-mp3)與sqlite裏的mp3 Entity(sqlite-mp3)同步機制。

// [101.02.23]
// 1. 完成Sandbox_ViewController刪除檔案機能。

// [101.02.22]
// 0. 發現一件很奇怪的事。在Sandbox_ViewController下，用一個member設IBOutlet想連結XIB File裏的UITableView物件，居然一直無法連結。同樣的做法在Tag_ViewController居然可以的。所以，只好把取得UITableView指標寫在numberOfRowsInSection這個tableView的delegate裏。(真的很神奇...難道是XCode的Bug~~>.<)
// 1. 將Sandbox_ViewController的刪除TableView Item的機能做好了。其中包含刪除self.listData以及tableView的該項item。(但真正去刪除檔案的動作還沒做。這部分弄完，刪除的機能才算完成)

// [101.02.20]
// 0. 天啊。一晃眼就過了將近一個半月。時間過真快啊.. 慘~~~ Schedule排出來了，就要盡力去達成。不能像以前一樣慢慢摸了。
// 1. 處理iOS背景撥放，在.plist裏加了一項Required background modes = app plays audio。並且在Playing_ViewController:playMP3WithFilename加入相關的code。
// 2. 處理Sandbox_ViewController、Playing_ViewController以及Edit_ViewController幾個顯示mp3名稱的欄位，把那些欄位改成不自動fit寬度，改以使用...來表示後面還有文字。
// 3. 改掉調整音量時，會自動撥放mp3的bug。(調整音量，不用自動去撥放)

// [101.01.04]
// 1. 在Playing_ViewController轉到Edit_ViewController時，把一些資料帶到Edit_ViewController裏。但這部分我覺得可能還是要用類似timePicker這種元件比較好操作。

// [100.12.21]
// 1. 增加單曲撥放(Single)以及循環撥放(Loop)選擇機能。(並且把Core Data的資料庫model裏的preference加上一個single_or_loop的attribute.並更新sqlite檔。)
// 2. 將Tag的撥放，從A key到B key，以及單曲還有循環撥放機能做完整。除此之外，連同duration及current也都能正確顯示。

// [100.12.19]
// 1. 在Sandbox_TbvCell裏，將原有的imageView換成UIButton，因為UIButton可以接收按下的事件。(Favorite選取的星星要能被接下後處理事件)
// 2. 在Model\增加AVPlayerExtension類別，並在裏面新增一個getDurationFromMp3Filename函式。傳入Mp3檔名，然後回傳該Mp3的duration.

// [100.12.15]
// 1. 把Sandbox_ViewController加上一個Custom TableView Cell.
// 2. 把一些畫面的layout修一下。

// [100.12.12]
// 1. 在Playlist_ViewController加上一個Custom TableView Cell. (做個簡單範例)

// [100.12.08]
// 1. 修改在Sandbox_ViewController點選mp3檔名時，是否該重撥mp3的判斷。
// 2. 刪掉一些在Playing_ViewController->ViewDidLoad裏面不會run到的程式

// [100.11.21]
// 1. 專案透過XCode 4.2.1轉成ARC專案。(一些Retain, Release都自動被拿掉了，並且宣告屬性時retain被改成strong了)

// [100.10.31]
// 1. 在Playling_ViewController加了一個btnPlayType，顯示目前撥放的型態是什麼。如果是撥MP3就顯示MP3(backgroundColor是黃色)，如果是撥Tag就顯示TAG(backgroundColor是綠色)，如果是撥放Playlist就顯示PLT。(playlist的部分還沒加)

// [100.10.30]
// 1. 今天測試一下在UITableView的Delegate函式，餵進CoreData產生的NSArray，結果跟預期的一樣，發生水土不服的現象。所以，看來我目前的做法是對的。
// 2. CodingStyle.h 加了一些東西。e.g. NSArray, NSMutableArray,...
// 3. 在AudioTagAppDelegate加了isPlay1stTimeFromStartApp判斷是否為進App時，第一次進行撥放動作。加了indexOfLastOpenedTag記錄目前Tag的index。
// 4. 將一開始進Sandbox就把Sandbox目錄的檔案名稱全部存進DB的mp3裏改掉，DB的mp3裏面只存Tag連結到的mp3。否則，如果Tag連結的mp3存檔後，再把mp3刪掉重存，Tag的連結也會不見。
// 5. 加入撥放Tag的機制。(能把A Key值帶入，但整體還不完整)


// [100.10.29]
// 1. CoreData: error: Failed to call designated initializer on NSManagedObject class 'playlist'這個錯誤要先查出來。(已查出來。就是playlist是CoreData所產生的類別介面，不可以直接拿來做alloc及init的動作。)
// 2. 將原本mstrPlayingFilename改為mstrPlayingMP3Filename
// 3. 註解掉pllstTemp以及pllstFavorite
// 4. loadDataFriomSquliteDBToMemory從AudioTagDelegate搬到Sandbox_ViewController。(在Sandbox_ViewController會去找目前Sandbox裏的檔案並且將檔案名稱寫到資料庫裏，然而，AudioTagDelegate的順序比較前面，所以必需把loadDataFriomSquliteDBToMemory移到等檔案都寫到資料庫後，再進行更新到Memory。)
// 5. 將uploadDataToSqliteDB改名為saveInitialDataToDB_Test
// 6. 將showSqliteDBInConsole改名為showDataInConsoleFromMemory
// 7. 將loadDataFromSqliteDBToMemory改名為loadDataFromDBToMemory
// 8. 增加saveSandboxMp3sToDB、deleteAllObjects, deleteAllObjectsForAllEntitiesFromDB函式，主要做一些與資料庫之前的處理。(e.g. 刪某個Entity的所有物件、...)
// 9. 在資料庫加入playlist及tag初始化資料 
// 10. 在Favorite_ViewController及Tag_ViewController加入一個空白的UITableView元件，該元件已連結datasource，並且把delegate必要的二個函式做了。
// 11.Tag_ViewController加了一個Add按鍵，增加Tag。同時處理資料庫及Memory同步。


// [100.10.20]
// 1. 升級XCode從4.1升至4.2。升級iOS SDK從4.3.2升級至5.0
// 2. 增加temp_playlist到sqlite DB，但只有name給資料，其他相關的owned_mp3s及owned_tags都還沒 (DataFramSqlite)
// 3. 要先查CoreData: error: Failed to call designated initializer on NSManagedObject class 'playlist'錯誤
//    (尚未完成)

// [100.10.11]
// 1. 在AudioTagAppDelegate類別新增二個成員pllstTemp以及pllstFavorite。主要是以下用途。
//  基本上，開兩個系統用的playlist.一個是temp，一個是favorite。這二個playlists在使用者介面是不會列出來的。
//  Favorite playlist是當使用者切到Favorite列表頁面時，將Favorite playlist裏的所有Tags都列表出來。
//  Temp playlist是當使用者如果切到sandbox開mp3檔或是切到Tag開一個tag檔撥放時，這時Temp playlist就只存放那單一的mp3或是tag。

// [100.10.05]
// 1. 加上CodingStyle.h說明程式撰寫時的相關變數或函式的命名法
// 2. 將Playing_ViewController的成員變數及函式都以CodingStyle.h裏敘述的命名方式重新整理命名。(注意：若成員經過重新命名，XIB File裏的連結(IBOutlet及IBAction)也要重新拉過，不然會XIB File會找不到當初的命名變數而當機。)
// 3. 依照CodingStyle.h裏面的說明，把AudioTagAppDelegate.h裏的成員更名以符合規則。
// 4. 將原本沒有用到的GlobalData.h還有GlobalData.m都刪掉了。
// 5. 修改了一下CodingStyle.h檔，新增了一點東西。
// 6. 將Edit_ViewController弄成是AudioTagAppDelegate下的成員，讓記憶體一直都留著，等程式結束再釋放。

// [100.10.04]
// 1. 將Playing_ViewController裏的AB Key加上對應的IBOutlet及IBAction。使得當按下AB Key時，avapPlayer.currentTime的值會帶入AB Key下方的Label。
// 2. AB Key都會一直Enable，當按下A或B Key時，判斷是否A<B，否則，就把A及B Key的value通通設一樣。如此操作比較方便。
// 3. 於Playing_ViewController以及Edit_ViewController各加入一個TextView
// 4. 將Edit_ViewController畫面的TextField及TextView都加上resignFirstResponder，讓touch畫面，鍵盤就消失。

// [100.10.03]
// 1. 針對Playing_ViewController以及Edit_ViewController的人機排版了一下，加放一些人機的元件。(Edit_ViewController右上角加了一個Save的Button)

// [100.09.26]
//1. 新增CurrentTime的Slider顯示及Label顯示，並且可以動態"顯示"更新
//2. 發現一個重要的BUG。當AVPlayer撥放mp3完成時，會呼叫delegate的audioPlayerDidFinishPlaying函式。
//但是，如果該delegate的類別實體已經先被release的話，那AVPlayer就會無法針對delegate的類別實體進行函試呼叫，
//也就會發生以下錯誤。(因為之前，mp3都沒撥放完，所以沒發現這個問題)
//-[Playing_ViewController respondsToSelector:]: message sent to deallocated instance 0x18f290
//解決方法：原本都是在撥放的時候去alloc及init Playing_ViewController，並且當Navigation Control進行
//pop View的時候，把Playing_ViewController給release掉。現在改成在AudioTagAppDelegate下宣告一個viewCon_Playing
//的成員，並且由AudioTagAppDelegate來alloc及init，並且在dealloc時把記憶體給release掉。如此一來，就不會發生
//AVPlayer的delegate實體消失的問題了。
//3. 在[avapPlayer player]使用GCD。在撥放時，原本會先卡一下然後再切到Player_ViewController頁面。使用GCD之後，
//卡的情況不見了。順啊~~~~

// [100.09.20]
//1. 在Playing_ViewController加上1個UISlider以控制音量。

// [100.09.19]
//1. 有12疑似memory leak的warning要處理。(Analysis後)
//Ans: 函式成員在呼叫alloc init時，以及在dealloc函式中，千萬不可以用self.member，只要用member即可。
//e.g. member = [[MEMBER alloc] init] (OK), self.member = [[MEMBER alloc] init] (NOT OK)
//dealloc(){
//    [member release] (OK)
//    [self.member release] (NOT OK)
//    ...
//}
//但是，在ViewDidUnload函式裏，一定要self.member。
//e.g. ViewDidUnload(){
//    self.member = nil (OK)
//    member = nil (NOT OK)
//}


// [100.09.18] 
//1. GlobalVariables類別其實可以取消，只要把裏面二個members拉到AudioTagAppDelegate類別裏面就可以了。(原本是在AudioTagAppDelegate裏面加入一個member是GlobalVariables的物件。但是，基本上AudioTagAppDelegate的屬性會設定Retain，所以AudioTagAppDelegate物件屬性內的成員幾乎是最後才被release的。也就有全域變數的意思在裏面了。)


#endif
