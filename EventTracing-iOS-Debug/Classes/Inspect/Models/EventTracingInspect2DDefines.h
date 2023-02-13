//
//  EventTracingInspect2DDefines.h
//  Pods
//
//  Created by dl on 2021/6/10.
//

#ifndef EventTracingInspect2DDefines_h
#define EventTracingInspect2DDefines_h

// https://www.uisdc.com/ui-color-design-guideline
#define ETinspect2DLayerColorDepthList @[\
    @"#FF5B5B",\
    @"#FF9E38",\
    @"#00B894",\
    @"#5D7CFF",\
    @"#A382FF",\
    @"#EC78FF",\
    @"#C55994",\
]

#define ETinspect2DLayerColorAt(depth) ETinspect2DLayerColorDepthList.count > depth ? ETinspect2DLayerColorDepthList[depth] : ETinspect2DLayerColorDepthList.lastObject

#define ETinspect2DOnPixel (1.0 / UIScreen.mainScreen.scale)

#endif /* EventTracingInspect2DDefines_h */
