<?php
/**
 * @Author: pizepei
 * @Date:   2020-07-30 10:01:30
 * @Last Modified by:   pizepei
 * @Last Modified time: 2020-07-31 09:49:52
 */
echo '号机名：'.$_SERVER['HOSTNAME'];
echo '<br>';
echo '<br>';
echo 'HTTP_HOST：'.$_SERVER['HTTP_HOST'];
echo '<br>';
echo '<br>';
echo 'HTTP_X_FORWARDED_FOR：'.$_SERVER['HTTP_X_FORWARDED_FOR'];
echo '<br>';
echo '<br>';
echo 'HTTP_X_REAL_IP：'.$_SERVER['HTTP_X_REAL_IP'];
echo '<br>';
echo '<br>';
echo 'REMOTE_ADDR：'.$_SERVER['REMOTE_ADDR'];
echo '<br>';
echo '<br>';
echo 'PATH_INFO：'.$_SERVER['PATH_INFO'];
echo '<br>';
echo '<br>';
echo 'SERVER_PORT：'.$_SERVER['SERVER_PORT'];
