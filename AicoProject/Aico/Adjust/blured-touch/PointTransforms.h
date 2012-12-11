//
// Scratch and See 
//
// The project provides en effect when the user swipes the finger over one texture 
// and by swiping reveals the texture underneath it. The effect can be applied for 
// scratch-card action or wiping a misted glass.
//
// Copyright (C) 2012 http://moqod.com Andrew Kopanev <andrew@moqod.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

#ifndef _POINT_TRANSFROMS_
#define _POINT_TRANSFROMS_

inline CGPoint fromUItoQuartz(CGPoint point,CGSize frameSize){
	point.y = frameSize.height - point.y;
	return point;
}

inline CGPoint scalePoint(CGPoint point,CGSize previousSize,CGSize currentSize){
	return CGPointMake(currentSize.width *point.x / previousSize.width, 
					   currentSize.height *point.y / previousSize.height);
}

/**
 * @brief 判断坐标是否在矩形内（由两坐标和宽度计算） 
 * @param [in] p0 需要判断的坐标
 * @param [in] p1 坐标1
 * @param [in] p2 坐标2
 * @param [in] height 矩形宽度/2
 * @param [out]
 * @return
 * @note 
 */
inline BOOL pointInRec(CGPoint p0, CGPoint p1, CGPoint p2, CGFloat height) {
    /*
     假设4个线段的表达式分别为 
     A[0]x+B[0]y+C[0]=0 ，A[2]x+B[2]y+C[2]=0 平行
     A[1]x+B[1]y+C[1]=0 ，A[3]x+B[3]y+C[3]=0 平行
     
     对于点（X0，Y0）， 
     D1   =   (A[0]X0+B[0]Y0+C[0])*(A[2]X0+B[2]Y0+C[2]), 
     D2   =   (A[1]X0+B[1]Y0+C[1])*(A[3]X0+B[3]Y0+C[3]) 
     如果   D1 <0 && D2 <0，那么点(X0,Y0)就落在矩形内。
     如果   (D1==0 && D2 <0) || (D1 <0 && D2==0)，就表示点落在矩形的边线上。
     如果   D1==0  &&   D2==0   ，就表示点为矩形的顶点。 
     */
    float rake1 = (p2.y-p1.y)/(p2.x-p1.x);
    float rake2 = -1/rake1;
    
    float a0,a1,a2,a3;
    float b0,b1,b2,b3;
    float c0,c1,c2,c3;
    
    a0 = a2 = -1 * rake1;
    a1 = a3 = -1 * rake2;
    
    b0 = b1 = b2 = b3 = 1;
    
    float offset = sqrtf(powf((height), 2) + powf((rake1*height), 2));
    
    c0 = rake1 * p1.x - p1.y + offset;
    c2 = rake1 * p1.x - p1.y - offset;
    
    c1 = -1 * a1 * p1.x - b1 * p1.y;
    c3 = -1 * a3 * p2.x - b3 * p2.y;
    
    int d1 = (a0*p0.x + b0*p0.y + c0) * (a2*p0.x + b2*p0.y + c2);
    int d2 = (a1*p0.x + b1*p0.y + c1) * (a3*p0.x + b3*p0.y + c3);

    if (d1<0 && d2<0) 
    {
        return YES;
    }
    else if ((d1==0 && d2<0) || (d1<0 && d2==0))
    {
        return YES; 
    }
    else if (d1==0 && d2==0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

inline BOOL pointInRec(const CGFloat array[3][4],const CGPoint & p0) {
    int d1 = (array[0][0]*p0.x + array[1][0]*p0.y + array[2][0]) * (array[0][2]*p0.x + array[1][2]*p0.y + array[2][2]);
    int d2 = (array[0][1]*p0.x + array[1][1]*p0.y + array[2][1]) * (array[0][3]*p0.x + array[1][3]*p0.y + array[2][3]);
    
    if (d1<0 && d2<0) 
    {
        return YES;
    }
    else if ((d1==0 && d2<0) || (d1<0 && d2==0))
    {
        return YES; 
    }
    else if (d1==0 && d2==0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#endif //_POINT_TRANSFROMS_