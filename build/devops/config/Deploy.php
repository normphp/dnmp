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
        'url' =>'http://103.210.23.213/normphp/basics/microservice/apps/config/',
        'hostDomain'  =>'dev.heil.red',
        'urlencode' => true,
        'appid'=>'677FF87E-0415-F553-7A12-FDBFC15B3330',//服务appid
        'appSecret'=>'5589ba719128973a008379c09e4c9975',//加密参数
        'encodingAesKey'=>'6ba24ab0440ab70bcd40ab9caa9d4a94d06bb46d7da',//解密参数
        'token'=>'0bd2d658402b00400da77b69bd0942bb',//签名使用
    ];

    const PERMISSIONS = [
    'title' => '系统核心',
    'id'    => 'normative',
    'field' => 'normative'
    ];

    const SERVICE_MODULE = [
    [
        'id'   => '13',
        'name' => 'normative--用来测试的主项目',
        'MODULE_PREFIX' =>'normphp',
        'path' => 'normphp'
        ],
    [
        'id'   => '11',
        'name' => 'layuiAdmin--前端layuiAdmin',
        'MODULE_PREFIX' =>'resource',
        'path' => 'layuiAdmin'
        ],
    [
        'id'   => '14',
        'name' => 'socks--重构的socks服务模块',
        'MODULE_PREFIX' =>'socks',
        'path' => 'socks'
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
    'host'            => '107.172.99.86',
    'port'            => 22,
    'username'        => 'root',
    'password'        => 'w251tnVJnX2Wx9k9CC',
    'ssh2_auth'       => 'password',
    'pubkey'          => '',
    'prikey'          => '',
    'WebSocketServer' => [
        'type'=>'ws://',
        'config'   => [
            'ssl_cert_file' => '',
            'ssl_key_file'  => ''
            ],
        'hostName' => '103.210.23.213',
        'host'     => '0.0.0.0',
        'port'     => '9501'
        ]
    ];

    const GITLAB = [
        'OauthUrl' => 'https://gitlab.heil.red',
        'AppId'    => '119930af3ea7dcd6378ea5ebaa0942716bdd200b6d139f89a0f1ebbaed9be303',
        'Key'      => '42b7f87022a8557576db03333d21ef99930fc7e3191e99baee8384a64d59c9f5',
        'versions' =>'v4',
    ];

    const INITIALIZE = [
    'versions'       => 'v2',
    'configCenter'   => '',
    'appid'          => 'appid76372843924923894',
    'appSecret'      => 'asdkj346fk3434df67455656345l',
    'encodingAesKey' => 'asdkjasdad346fk34dfsfdsf34df67455656345l',
    'token'          => '68uijkmsd454lfgnvcv@'
    ];

    const SUPER_ADMIN_INFO = [
    'phone'   => 18888888888,
    'email'   => '88888888@888.com',
    'pasword' => 88888888,
     'mid'=>'normphp',
    ];



}