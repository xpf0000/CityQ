//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#define kSinaWeiBo_Share_AppKey @"2650093593"
#define kSinaWeiBo_Share_AppSecret @"d525c4a7ff828f7df3a93ba9608494d8"
#define kSinaWeiBo_RedirectUri @"http://open.weibo.com"
#define kQQ_Share_AppKey @"1105030226"
#define kQQ_Share_AppSecret @"wLJuoJdb3CmeueoU"
#define kWX_Share_AppKey @"wxfb0938713787e49a"
#define kWX_Share_AppSecret @"186e064461a62c8c323146d3981c40be"

#import "XOC.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import <CloudPushSDK/CCPSysMessage.h>
#import <CommonCrypto/CommonDigest.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>
#import "ZipArchive.h"
//#import "//UMessage.h"

#import "SkyRadiusView.h"
#import "XOC.h"
#import "FXBlurView.h"
#import "DDCollectionViewFlowLayout.h"
#import "UICollectionViewLeftAlignedLayout.h"


#import "AGImagePickerController.h"
#import "AGImagePickerControllerDefines.h"
#import "AGIPCToolbarItem.h"
#import "UIButton+AGIPC.h"
#import "AGIPCGridItem.h"

//#import "UIImageView+WebCache.h"
//#import "SDWebImageDecoder.h"

#import "UIImage+WebP.h"
#import "SystemInfo.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

//微信SDK头文件
//初始化的import参数注意要链接原生微信SDK。
//case SSDKPlatformTypeWechat:
//[ShareSDKConnector connectWeChat:[WXApi class]];
//break;

