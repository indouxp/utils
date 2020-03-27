//
// ����1��path�t�H���_�����̃t�@�C���ŁA�ŏI�X�V�N���������b���A����2(FROM)�ȍ~�ł���t�@�C�����A�X�N���v�g�p�X������OUT\FOLDER�t�H���_(FOLDER�́A����3)�ɃR�s�[����
// ����4��COPY�łȂ��ꍇ�́A�W���o�͂ւ̃t�@�C���ꗗ�\���̂�
//
try {
  if (WScript.Arguments.length < 3) {
    WScript.echo("Usage");
    WScript.echo("1: path");
    WScript.echo("2: FROM yyyymmdd_hhMMss");
    WScript.echo("3: FOLDER");
    WScript.echo("4: COPY");
    throw new Error("�����G���[");
  }
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  var dir = WScript.Arguments(0);
  var from = WScript.Arguments(1);
  var folder = WScript.Arguments(2);
  var execute = 0;
  if (WScript.Arguments.length == 4 && WScript.Arguments(3) == "COPY") {
    execute = 1;                                             // ����4��COPY�̎�
  }

  // OUT�ȉ��̈���3���A�Ȃ���΍쐬����
  var dest = fso.BuildPath(fso.getParentFolderName(WScript.ScriptFullName), "OUT");
  dest = fso.BuildPath(dest, folder);
  if (!fso.FolderExists(dest)) {
    fso.CreateFolder(dest);
  }

  //WScript.echo(dir);
  //WScript.echo(from);
  var msg = dir + "�ȉ���" + from + "�ȍ~�̍ŏI�X�V�������t�@�C�����A" + dest + "�ɃR�s�[����B";
  WScript.echo(msg);

  var files = fso.GetFolder(dir).Files;                      // ����1��path�̃t�@�C��
  var e = new Enumerator(files);                             // �񋓌^����
  for (; !e.atEnd(); e.moveNext()) {                         // �t�@�C���ꗗ�̎擾
    var file = e.item();                                     // �t�@�C���I�u�W�F�N�g
    var LastModified = new Date(file.DateLastModified);      // �ŏI�X�V���̎擾
    var strLastModified = getStringFromDate(LastModified);   // ������^�ɕϊ�
    //WScript.Echo(strLastModified + ":" + file.Path);
    if (from <= strLastModified ) {                          // from <= �ŏI�X�V
      //WScript.Echo("*" + strLastModified + " " + file.Path);
      if (execute == 1) {                                    // ���ۂɃR�s�[
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
// date����Astr��
//
function getStringFromDate(date) {
 
  var year_str = date.getFullYear();
  //����+1
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
