<?php
/**
 * creationDate: 2020-05-16 12:00:58
 * creationTime: 1589601658
 * @title: 基础配置
 * @appid: 
 */


 namespace config\app;


class SetConfig
{ 
    const UNIVERSAL = [
    'cache' => [
        'driveType'    => 'redis',
        'targetDir'    => '../runtime/',
        'CacheTypeDir' => ''
        ],
    'init'  => [
        'appname'               => 'app',
        'pattern'               => 'exploit',
        'return'                => 'json',
        'json_encode'           => 320,
        'index-view'            => './layuiAdmin.pro-v1.2.1/start/index.html',
        'header'                => [
            'X-Powered-By' => 'ASP.NET',
            'Server'       => 'Apache/2.4.23 (Win32) OpenSSL/1.0.2j mod_fcgid/2.3.9'
            ],
        'requestParam'          => true,
        'requestParamTier'      => 50,
        'clientInfo'            => false,
        'SYSTEMSTATUS'          => [
            'controller',
            'function_method',
            'request_method',
            'request_url',
            'route',
            'sql',
            'clientInfo',
            'system',
            'memory',//内存状态
        ],
        'uuid_identifier'       => 'test-1',
        'SuccessReturnJsonCode' => [
            'name'  => 'code',
            'value' => 200
            ],
        'ErrorReturnJsonCode'   => [
            'name'  => 'code',
            'value' => 100
            ],
        'SuccessReturnJsonMsg'  => [
            'name'  => 'msg',
            'value' => 'success'
            ],
        'ErrorReturnJsonMsg'    => [
            'name'  => 'msg',
            'value' => 'error'
            ],
        'ReturnJsonData'        => 'data',
        'ReturnJsonCount'       => 'count',
        'jurisdictionCode'      => 40003,
        'notLoggedCode'         => 10001
        ],
    'route' => [
        'type'          => 'note',
        'postfix'       => [
            '.json',
            '.jsp',
            '.data'
            ],
        'ReturnSubjoin' => [
            ],
        'index'         => 'index.html'
        ]
    ];

    const ACCOUNT = [
    'password_regular'            => [
        '/^.*(?=.{6,})(?=.*\\d)(?=.*[A-Z])(?=.*[a-z]).*$/',
        '密码至少并且6位且必须包含大小写字母!'
        ],
    'number_count'                => 20,
    'algo'                        => '2y',
    'options'                     => [
        'cost' => 11
        ],
    'user_logon_token_salt_count' => 22,
    'logon_token_salt'            => 'si8934jfk08343*%wew#jj12@99sidjxjc#$lksjd^&*',
    'GET_ACCESS_TOKEN_NAME'       => 'access-token',
    'HEADERS_ACCESS_TOKEN_NAME'   => 'HTTP_ACCESS_TOKEN'
    ];

    const API_CONFIG = [
    'BaiduIp' => [
        'url' => '',
        'Key' => ''
        ]
    ];

    const PRODUCT_INFO = [
    'title'    => 'Lifestyle',
    'name'     => 'Lifestyle',
    'describe' => '一个非常适合团队协作的微型框架',
    'meta'     => 'Lifestyle',
    'extend'   => [
        'homeLoginLay' => ''
        ]
    ];
    const MICROSERVICE = [
        'M_SMS'   => [
            'api'      => '/contact-verification/micro-service/sms/test/',
            'url'      => '',
            'configId' => ''
        ],
        'CONFIG'  => [
            'appid'          => 'E4675305-0D20-9545-049B-0E0786AE4518',
            'token'          => '',
            'appsecret'      => '',
            'encodingAesKey' => ''
        ],
        'E_MAIL'  => [
            'api'      => '/contact-verification/micro-service/mail/send/',
            'url'      => '',
            'configId' => ''
        ],
        'ACCOUNT' => [
            'api'      => '/normphp/account/auth-jwt-service/',
            'url'      => '',
            'configId' => ''
        ]
    ];
    const JSON_WEB_TOKEN_SECRET = [
        'base'    => [
            'alg'   => 'md5',
            'name'  => '管理员',
            'role'  => '',
            'value' => ''
        ],
        'common'  => [
            'alg'        => 'md5',
            'name'       => '普通权限',
            'role'       => 'common',
            'Header'     => [
                'alg'    => 'aes',
                'sig'    => 'md5',
                'typ'    => 'JWT',
                'appid'  => 'ashaaasd1232jjdskhkkx',
                'number' => ''
            ],
            'secret'     => 'abcd123343',
            'Payload'    => [
                'aud' => 'socketServer',
                'exp' => 7200,
                'iss' => 'server',
                'sub' => 'phpServer--socketServer'
            ],
            'secret_key' => 'sakjshkjkljm889289023dscponbxba3242903902ijkds',
            'token_name' => 'access_token'
        ],
        'visitor' => [
            'alg'   => 'md5',
            'name'  => '游客',
            'role'  => '',
            'value' => ''
        ]
    ];

    const JSON_WEB_TOKEN_ROLE = [
    'common'  => [
        ],
    'base'    => [
        ],
    'visitor' => [
        ]
    ];

    const SMS = [
        'Aliyun'  => [
            'pattern'         => [
                'register' => [
                    'SignName'     => '',
                    'parameter'    => [
                        'code' => '验证码'
                    ],
                    'TemplateCode' => ''
                ]
            ],
            'RegionId'        => 'cn-hangzhou',
            'aisleName'       => 'Aliyun',
            'accessKeyId'     => '',
            'accessKeySecret' => ''
        ],
        'default' => 'Aliyun'
    ];

    const TERMINAL_INFO_PATTERN = 'high';

    const TERMINAL_IP_PATTERN = 'cdn';

    const TERMINAL_INFO_API_CONFIG = [
    'BaiduIp' => [
        'url' => '',
        'Key' => ''
        ]
    ];

    const OPEN_WECHAT_CONFIG = [
    'pattern'        => 'third',
    'appid'          => '',
    'appsecret'      => '',
    'encodingAesKey' => '',
    'token'          => '',
    'prefix'         => 'wechat_third'
    ];

    const WECHAT_CONFIG = [
    'pattern'            => 'tradition',
    'appid'              => '',
    'appsecret'          => '',
    'token'              => '',
    'encodingAesKey'     => '',
    'cache_type'         => 'redis',
    'cache_keyword_type' => 'mysql',
    'prefix'             => 'wechat_tradition'
    ];

    const REDIS = [
    'host'         => 'devops-redis',
    'port'         => 6379,
    'password'     => '',
    'select'       => 0,
    'expire'       => 3600,
    'timeout'      => 0,
    'persistent'   => true,
    'session_name' => '',
    'prefix'       => 'redis_1'
    ];

    const FILES_UPLOAD_APP = [
    'asdkjlk3434df674545l' => [
        'appid'          => 'asdkjlk3434df674545l',
        'AppSecret'      => 'asdkjlsssfk3434df67455656345l',
        'token'          => '68uijkmsd454lfgjuwynvcv@',
        'period'         => 20,
        'request_domain' => [
            '/^http:\\/\\/[A-Za-z0-9_-]+.oauth.heil.top/S',
            '/^http:\\/\\/oauth.heil.top/S'
            ],
        'show_domain'    => [
            'http://oauth.heil.top',
            'https://oauth.heil.top'
            ],
        'catalogue'      => '../public/files_upload/'
        ]
    ];

    const FILES_UPLOAD_APP_SCHEMA = [
    'files-upload' => [
        'type' => [
            'image/png'
            ],
        'size' => 1048576
        ]
    ];

    const GEETEST = [
        'CAPTCHA_ID'=>'',
        'PRIVATE_KEY'=>'',
        'MD5'=>'',
    ];
    const WEC_CHAT_CODE = [
        'appid'            => '',
        'token'            => '9168148371',
        'app_secret'       => '',
        'target_url'       => 'http://oauth.heil.top/account/wecht-qr-target',
        'encoding_aes_key' => '',
        'apiUrl'               =>'http://oauth.heil.top/normative/wechat/common/code-app/qr/',
    ];

}