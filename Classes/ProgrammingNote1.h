//
//  ProgrammingNote1.h
//  AudioTag
//
//  Created by Chang Wayne on 12/3/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef AudioTag_ProgrammingNote1_h
#define AudioTag_ProgrammingNote1_h

/**
 RGB配色表  http://www.wahart.com.hk/rgb.htm
 */

/**************************************************************************
 */

/* DataFromSqlite相關的設計原理及知識
dataFromSqlite._preferences
dataFromSqlite._favorite_playlist
dataFromSqlite._temp_playlist
dataFromSqlite._mp3
dataFromSqlite._tag
以上這幾個成員變數如果要更新，就使用loadDataFromDBToMemory函式即可。
意思就是說，如果需要變更sqlite裏面的資料，直接利用managedObjectContext的操作去處理資料庫，然後，
利用loadDataFromDBTOMemory來更新即可。

*/
/**************************************************************************
 */
/*  實體儲存的mp3檔案(disk-mp3)與sqlite裏的mp3 Entity(sqlite-mp3)同步機制(1.)
 1. 檢查disk-mp3與sqlite-mp3的差異。以disk-mp3為主，進行同步處理。
 如果sqlite-mp3有ABC.mp3，disk-mp3沒有。===> 刪掉sqlite-mp3裏的ABC.mp3
 如果sqlite-mp3沒有ABC.mp3，disk-mp3有。===> 將sqlite-mp3加入ABC.mp3
 */

/* sqlite-tags連結重建機制(2.)
 2. 檢查sqlite-tags連結的sqlite-mp3是否存在？並重建連結。
 如果sqlite-tags裏的gggABC Tag所連結的mp3檔名是ABC.mp3(Tag裏必需建立linked_mp3filename這個attribute)，但該linked_mp3回傳值是nil。===>搜尋目前sqlite-mp3裏面是否有符合lined_mp3filename的ABC.mp3這個檔名存在？如果有，重新把linked_mp3連結到這個sqlite-mp3裏的ABC.mp3，重新建立連結。如果沒有，就不做任何處理。(但在Tag_ViewController下的TableView就要有小圖示或是底部反黑，告訴使用者，這個Tag所連結的mp3是不存在的。)
 
 ---->step1. 先check各別的tag.linked_mp3是否為nil。
 ---->step2. 如果tag.linked_mp3是nil，就檢查目前disk-mp3是否有相同檔名的mp3存在。
 ---->step3. 如果存在，就重新把tag.linked_mp3指向目前這個mp3 (重建連結)
 */
/**************************************************************************
 */

#endif
