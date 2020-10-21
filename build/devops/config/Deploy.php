<?php
/**
 * creationDate: 2020-05-16 14:46:31
 * creationTime: 1589611591
 * @title: 基础配置
 * @appid: 
 */


class Deploy
{ 
    const __EXPLOIT__ = 0;

    const __DOCUMENT__ = '';

    const ENVIRONMENT = 'production';

    const CENTRE_ID = 13;

    const DEPLOY = FALSE;

    const EXCLUDE_PACKAGE = [
    //'bases'
    ];

    const PROJECT_ID = 13;

    const SERVICE_PATTERN = [
    'api',
    'microservice'
    ];

    const MicroService = [
        'url' =>'http://103.xxx.xxx.xxx/normphp/basics/microservice/apps/config/',
        'hostDomain'  =>'',
        'urlencode' => true,
        'appid'=>'',//服务appid
        'appSecret'=>'',//加密参数
        'encodingAesKey'=>'',//解密参数
        'token'=>'',//签名使用
    ];

    const PERMISSIONS = [
    'title' => '系统核心',
    'id'    => 'normative',
    'field' => 'normative'
    ];

    const SERVICE_MODULE = [
    [
        'id'   => '13',
        'name' => 'normphp',
        'MODULE_PREFIX' =>'normphp',
        'path' => 'normphp'
        ],
    [
        'id'   => '11',
        'name' => 'layuiAdmin--前端layuiAdmin',
        'MODULE_PREFIX' =>'resource',
        'path' => 'layuiAdmin'
        ]
    ];

    const toLoadConfig = 'Local';

    const MODULE_PREFIX = 'normphp';

    const VIEW_RESOURCE_PREFIX = 'resource';

    const CDN_URL = '';

    const CDN_AGENCY = [
    'pattern' => 'direct',
    'ip'      => [
        'all'
        ]
    ];
    #netstat -tunlp|grep 9501  kill -9 3905
    const buildServer = [
    'host'            => '{{hostIp}}',
    'port'            => '{{hostPort}}',
    'username'        => 'root',
    'password'        => '{{hostPassword}}',
    'ssh2_auth'       => 'password',
    'pubkey'          => '',
    'prikey'          => '',
    'WebSocketServer' => [
        'type'=>'ws://',
        'config'   => [
            'ssl_cert_file' => '',
            'ssl_key_file'  => ''
            ],
        'hostName' => '{{hostName}}',
        'host'     => 'devops-php-fpm-7.4',
        'port'     => '9501'
        ]
    ];

    const GITLAB = [
        'OauthUrl' => '',
        'AppId'    => '',
        'Key'      => '',
        'versions' =>'v4',
    ];

    const INITIALIZE = [
    'versions'       => 'v2',
    'configCenter'   => '',
    'appid'          => '',
    'appSecret'      => '',
    'encodingAesKey' => '',
    'token'          => ''
    ];
    const SUPER_ADMIN_INFO = [
    'phone'   => 18888888888,
    'email'   => '88888888@888.com',
    'pasword' => 88888888,
     'mid'=>'normphp',
    ];

}