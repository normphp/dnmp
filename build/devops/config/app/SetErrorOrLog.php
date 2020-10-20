<?php
/**
 * creationDate: 2020-05-16 09:28:58
 * creationTime: 1589592538
 * @title: 基础配置
 * @appid: 
 */


 namespace config\app;


class SetErrorOrLog
{ 
    const JURISDICTION_CODE = 40003;

    const NOT_LOGGOD_IN_CODE = 10001;

    const HINT_MSG = [
    '1',
    '请稍后再试！',
    '请联系客服！',
    '去联系管理员！',
    '请截图联系客服！',
    '系统异常，请稍后再试！',
    '网络繁忙，请稍后再试！',
    '活动火爆，请稍后再试！',
    '异常操作，请稍后再试！'
    ];

    const CODE_DISTRICT = [
    ];

    const SYSTEM_CODE = [
    10000 => [
        5,
        '错误说明',
        '功能模块',
        '联系方式[开发负责人]'
        ],
    10001 => [
        5,
        '项目部署时获取远处配置中心配置时构建加密时出现错误',
        '项目部署获取配置',
        '联系方式[pizepei]'
        ],
    10002 => [
        5,
        '项目部署时获取远处配置中心配置时构建签名时出现错误',
        '项目部署获取配置',
        '联系方式[pizepei]'
        ],
    10003 => [
        5,
        'SAAS配置路径必须',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10004 => [
        5,
        'SAAS配置路径必须',
        '请求配置中心成功就行body失败',
        '联系方式[pizepei]'
        ],
    10005 => [
        5,
        '初始化配置失败：请求配置中心失败',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10006 => [
        5,
        '初始化配置失败：非法请求,服务不存在不存在',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10007 => [
        5,
        '初始化配置失败：非法的请求源',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10008 => [
        5,
        '初始化配置失败：签名验证失败',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10009 => [
        5,
        '初始化配置失败：解密错误',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10010 => [
        5,
        '初始化配置失败：appid or domain 不匹配',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10011 => [
        5,
        '初始化配置失败：构造配置时 signature',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10012 => [
        5,
        '初始化配置失败：数据过期',
        'SAAS配置',
        '联系方式[pizepei]'
        ],
    10013 => [
        5,
        '初始化配置失败：得到构造配置时 signature',
        'SAAS配置',
        '联系方式[pizepei]'
        ]
    ];

    const USE_CODE = [
    50000 => [
        5,
        '开发错误说明',
        '功能模块',
        '联系方式[开发负责人]'
        ],
    50001 => [
        5,
        '开发错误说明',
        '功能模块',
        '联系方式[开发负责人]'
        ]
    ];

    const CODE_SECTION = [
    'SYSTEM_CODE' => [
        10000,
        49999
        ],
    'USE_CODE'    => [
        50000,
        99999
        ]
    ];



}