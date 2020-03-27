//
// 引数1のpathフォルダ直下のファイルで、最終更新年月日時分秒が、引数2(FROM)以降であるファイルを、スクリプトパス直下のOUT\FOLDERフォルダ(FOLDERは、引数3)にコピーする
// 引数4がCOPYでない場合は、標準出力へのファイル一覧表示のみ
//
try {
  if (WScript.Arguments.length < 3) {
    WScript.echo("Usage");
    WScript.echo("1: path");
    WScript.echo("2: FROM yyyymmdd_hhMMss");
    WScript.echo("3: FOLDER");
    WScript.echo("4: COPY");
    throw new Error("引数エラー");
  }
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  var dir = WScript.Arguments(0);
  var from = WScript.Arguments(1);
  var folder = WScript.Arguments(2);
  var execute = 0;
  if (WScript.Arguments.length == 4 && WScript.Arguments(3) == "COPY") {
    execute = 1;                                             // 引数4がCOPYの時
  }

  // OUT以下の引数3を、なければ作成する
  var dest = fso.BuildPath(fso.getParentFolderName(WScript.ScriptFullName), "OUT");
  dest = fso.BuildPath(dest, folder);
  if (!fso.FolderExists(dest)) {
    fso.CreateFolder(dest);
  }

  //WScript.echo(dir);
  //WScript.echo(from);
  var msg = dir + "以下の" + from + "以降の最終更新日を持つファイルを、" + dest + "にコピーする。";
  WScript.echo(msg);

  var files = fso.GetFolder(dir).Files;                      // 引数1のpathのファイル
  var e = new Enumerator(files);                             // 列挙型生成
  for (; !e.atEnd(); e.moveNext()) {                         // ファイル一覧の取得
    var file = e.item();                                     // ファイルオブジェクト
    var LastModified = new Date(file.DateLastModified);      // 最終更新日の取得
    var strLastModified = getStringFromDate(LastModified);   // 文字列型に変換
    //WScript.Echo(strLastModified + ":" + file.Path);
    if (from <= strLastModified ) {                          // from <= 最終更新
      //WScript.Echo("*" + strLastModified + " " + file.Path);
      if (execute == 1) {                                    // 実際にコピー
        var target = fso.getFile(file.Path);
        var destFile = fso.BuildPath(fso.getfolder(dest), file.Name);
        WScript.Echo(target + "->" + destFile);
        fso.copyFile(target, destFile);
      }
    //} else {
    //  WScript.Echo(" " + strLastModified + " " + file.Path);
    }
  }

  WScript.quit(0);
} catch (e) {
  WScript.echo(e.name + ":" + e.message);
  WScript.quit(9);
}

//
// dateから、strへ
//
function getStringFromDate(date) {
 
  var year_str = date.getFullYear();
  //月は+1
  var month_str = date.getMonth() + 1;
  var day_str = date.getDate();
  var hour_str = date.getHours();
  var minute_str = date.getMinutes();
  var second_str = date.getSeconds();
 
  month_str = ('0' + month_str).slice(-2);
  day_str = ('0' + day_str).slice(-2);
  hour_str = ('0' + hour_str).slice(-2);
  minute_str = ('0' + minute_str).slice(-2);
  second_str = ('0' + second_str).slice(-2);
 
 format_str = 'YYYYMMDD_hhmmss';
 format_str = format_str.replace(/YYYY/g, year_str);
 format_str = format_str.replace(/MM/g, month_str);
 format_str = format_str.replace(/DD/g, day_str);
 format_str = format_str.replace(/hh/g, hour_str);
 format_str = format_str.replace(/mm/g, minute_str);
 format_str = format_str.replace(/ss/g, second_str);
 
 return format_str;
};
