#!/usr/bin/perl
# 説明   : system 情報。
# 作成者 : 江野高広
# 作成日 : 2015/05/01
# 更新 2015/12/08 : 個別パラメーターシートを使えるように。
# 更新   : 2015/12/24 syslog 確認のJSON を取り込めるように。
# 更新   : 2016/01/28 enable password をログイン情報ファイルから外す。

use strict;
use warnings;

package Common_system;

# 本システムのDB への接続変数。
sub DB_connect_parameter {
 return('TelnetmanWF', 'localhost', 'telnetmanWF', 'tcpport23');
}

# 裏口パスワード
sub master_password {
 return('tcpport23');
}

# Telnetman のアドレス
sub telnetman {
 #return('localhost');
 return('192.168.203.96');
}


# データディレクトリの絶対パス。
sub dir_var {
 return('/var/TelnetmanWF');
}

sub dir_tmp_root {
 my $tmp_id = $_[0];
 return(&Common_system::dir_var() . '/tmp/' . $tmp_id);
}

sub dir_data_root {
 my $flow_id = $_[0];
 return(&Common_system::dir_var() . '/data/' . $flow_id);
}

sub file_default_login_info {
 my $flow_id = $_[0];
 return(&Common_system::dir_data_root($flow_id) . '/Telnetman2_loginInfo_default.json');
}

sub file_all_data {
 my $flow_id = $_[0];
 return(&Common_system::dir_data_root($flow_id) . '/all_data.json');
}

sub file_all_data_tmp {
 my $tmp_id = $_[0];
 return(&Common_system::dir_tmp_root($tmp_id) . '/all_data.json');
}

sub file_all_data_zip {
 my $flow_id = $_[0];
 return(&Common_system::dir_data_root($flow_id) . '/all_data.zip');
}

sub dir_data {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data_root($flow_id) . '/' . $work_id);
}

sub file_flowchart_before {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_flowchart_before.json');
}

sub file_flowchart_middle {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_flowchart_middle.json');
}

sub file_flowchart_after {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_flowchart_after.json');
}

sub file_login_info {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_loginInfo_.json');
}

sub file_syslog_values {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_syslogValues_.json');
}

sub file_diff_values {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_diffValues_.json');
}

sub file_optional_log_values {
 my $flow_id = $_[0];
 my $work_id = $_[1];
 return(&Common_system::dir_data($flow_id, $work_id) . '/Telnetman2_optionalLog_.json');
}

sub dir_log_root {
 my $flow_id = $_[0];
 return(&Common_system::dir_var() . '/log/' . $flow_id);
}

sub dir_task_log {
 my $flow_id = $_[0];
 my $task_id = $_[1];
 return(&Common_system::dir_log_root($flow_id) . '/' . $task_id);
}

sub dir_log {
 my $flow_id = $_[0];
 my $task_id = $_[1];
 my $target_id = $_[2];
 return(&Common_system::dir_task_log($flow_id, $task_id) . '/' . $target_id);
}

sub file_parameter_sheet {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 return(&Common_system::dir_log($flow_id, $task_id, $target_id) . '/Telnetman2_parameter_.json');
}

sub file_parameter_sheet_through {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 return(&Common_system::dir_log($flow_id, $task_id, $target_id) . '/Telnetman2_parameter_through.json');
}

sub file_parameter_sheet_individual {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 return(&Common_system::dir_log($flow_id, $task_id, $target_id) . '/Telnetman2_parameter_individual.json');
}

sub dir_old_log {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 my $time      = $_[3];
 return(&Common_system::dir_log($flow_id, $task_id, $target_id) . '/' . $time);
}

sub file_zip_log {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 my $time      = $_[3];
 my $type      = $_[4];
 
 $type =~ tr/a-z/A-Z/;
 
 return(&Common_system::dir_old_log($flow_id, $task_id, $target_id, $time) . '/' . $type . '_log.zip');
}

sub file_old_parameter_sheet {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 my $time      = $_[3];
 return(&Common_system::dir_old_log($flow_id, $task_id, $target_id, $time) . '/Telnetman2_parameter_.json');
}

sub file_old_parameter_sheet_individual {
 my $flow_id   = $_[0];
 my $task_id   = $_[1];
 my $target_id = $_[2];
 my $time      = $_[3];
 return(&Common_system::dir_old_log($flow_id, $task_id, $target_id, $time) . '/Telnetman2_parameter_individual.json');
}

sub column_name_list {
 my $table_name = $_[0];
 
 if($table_name eq 'T_Flow'){
  return('vcFlowId', 'vcFlowTitle', 'vcFlowDescription', 'vcFlowPassword', 'vcTaskPassword', 'iWorkNumber', 'iCaseNumber', 'iTerminalNumber', 'iX', 'iY', 'vcStartLinkTarget', 'txStartLinkVertices', 'iGoalX', 'iGoalY', 'iPaperHieght', 'vcLoginInfo', 'vcEnablePassword', 'iCreateTime', 'iUpdateTime');
 }
 elsif($table_name eq 'T_Work'){
  return('vcFlowId', 'vcWorkId', 'vcWorkTitle', 'vcWorkDescription', 'iActive', 'iX', 'iY', 'vcOkLinkTarget', 'vcNgLinkTarget', 'vcThroughTarget', 'txOkLinkVertices', 'txNgLinkVertices', 'txThroughVertices', 'iUseParameterSheet', 'iBondParameterSheet', 'vcEnablePassword', 'iCreateTime', 'iUpdateTime');
 }
 elsif($table_name eq 'T_Case'){
  return('vcFlowId', 'vcCaseId', 'vcCaseTitle', 'vcCaseDescription', 'iActive', 'iX', 'iY', 'txLinkTargetList', 'txLinkLabelList', 'txLinkVerticesList', 'txParameterConditions', 'iCreateTime', 'iUpdateTime');
 }
 elsif($table_name eq 'T_Terminal'){
  return('vcFlowId', 'vcTerminalId', 'vcTerminalTitle', 'vcTerminalDescription', 'iActive', 'iX', 'iY', 'iCreateTime', 'iUpdateTime');
 }
 elsif($table_name eq 'T_File'){
  return('vcFlowId', 'vcWorkId', 'vcFlowchartBefore', 'vcFlowchartMiddle', 'vcFlowchartAfter', 'vcLoginInfo', 'vcSyslogValues', 'vcDiffValues', 'vcOptionalLogValues', 'iCreateTime', 'iUpdateTime');
 }
}

1;
