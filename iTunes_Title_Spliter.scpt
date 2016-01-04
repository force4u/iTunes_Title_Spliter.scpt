(*
iTunes Title Spliter
初回作成　20151229


iTuneの選択中のタイトルから
区切り文字として『-』を利用して『アーティスト名』『ソングタイトル』にわけ
再設定します。


*)

----ログを表示
tell application "AppleScript Editor"
	activate
	try
		tell application "System Events" to keystroke "3" using {command down}
	end try
	try
		tell application "System Events" to keystroke "l" using {option down, command down}
	end try
end tell
---iTune呼び出し
tell application "iTunes"
	try
		----選択されているファイルの実体先をリストで取得
		set listSelection to selection as list
	on error
		---選択していないとエラーになる
	end try
	---iTunesの終わり
end tell

---取得したリストのファイル数
set numSelectionFile to (count of listSelection) as number
---処理回数カウンターリセット
set numCntRep to 0 as number
---リピートのはじまり
repeat numSelectionFile times
	---初期化
	set theNewName to "" as text
	set theNewArtist to "" as text
	---カウントアップ
	set numCntRep to numCntRep + 1 as number
	---
	try
		---１つづ処理する
		set theOrgSelection to (item numCntRep of listSelection)
	on error
		---選択していないとエラーになる
		exit repeat
	end try
	---ここからiTuneの処理
	tell application "iTunes"
		---タイトル（name）を取得する
		set theOrgName to name of theOrgSelection as text
		---不要な文字列をあらかじめ削除しておく（ここはお好みで）☆
		set theExName to my doReplace(theOrgName, "", "") as text
		---区切り文字を設定
		set AppleScript's text item delimiters to {" - "}
		---区切り文字でリストにして格納
		set theNameList to every text item of theExName as list
		---現在のタイトルの区切り文字数を調べる
		set numNameListCnt to (count of theNameList) as number
		---区切り文字が複数あった場合はエラーにする
		if numNameListCnt > 2 then
			log "区切り文字が既定値外"
			---エラーにしてリピートを抜ける
			exit repeat
		end if
		---前半がアーティスト名
		set theNewArtist to (item 1 of theNameList) as text
		---後半がタイトル名
		try
			---タイトル部分を取得出来ない場合（区切り文字が無かった場合もこちら）
			set theNewName to (item 2 of theNameList) as text
		on error
			---エラーにしてリピートを抜ける
			exit repeat
		end try
		---タイトル名（name）を変更する
		set name of (item numCntRep of listSelection) to theNewName
		---アーティスト名（artist)を変更する
		set artist of (item numCntRep of listSelection) to theNewArtist
		---区切り文字を戻す
		set AppleScript's text item delimiters to {""}
	end tell
	---リピートの終わり
end repeat




---文字の置き換えのサブルーチン
to doReplace(theText, orgStr, newStr)
	set oldDelim to AppleScript's text item delimiters
	set AppleScript's text item delimiters to orgStr
	set tmpList to every text item of theText
	set AppleScript's text item delimiters to newStr
	set tmpStr to tmpList as text
	set AppleScript's text item delimiters to oldDelim
	return tmpStr
end doReplace


