
void MonoPost(inout vec4 color)
{
    vec4 red = color.rrrr;
    vec4 green = color.gggg;
    vec4 blue = color.bbbb;
    vec4 sum = red + green + blue;
    vec4 avg = sum / 3.0;
    color = avg;
}
vec4 FilterRed(in vec4 color)
{
    float hueDiap = 1.0;
    float gbDiff = color.g - color.b;
    bool gbEq = gbDiff < 0.0001;
    
    if (color.r > color.g && color.r > color.b)
    {
        return color;
    }
}
void PostPass(inout vec4 fragColor)
{
    vec4 color = fragColor;
    vec4 red = FilterRed(color);
    MonoPost(color);
    color = color + red;
    fragColor = color;
    
}

vec4 Fill1(in vec4 color, in vec2 uv)
{
    float rBeg = 0.0;
    float rEnd = 0.3;
    float gB = 0.3;
    float gE = 0.6;
    float bB = 0.6;
    float bE = 1.0;
    
    if ( uv.y > rBeg && uv.y < rEnd) return vec4(1.0,0.0,0.0,0.0);
    if ( uv.y > gB && uv.y < gE) return vec4(0.0,1.0,0.0,0.0);
    if ( uv.y > bB && uv.y < bE) return vec4(0.0,0.0,1.0,0.0);
    discard;
}
vec4 Fill2(in vec4 color, in vec2 uv)
{

    float pixelPos = uv.x+uv.y;

    if (pixelPos > 1.0)
    {
        return vec4(0.0,pixelPos - uv.y,0.0,0.0);
    }
    return vec4(pixelPos - uv.y, 0.0,0.0,0.0);

}
vec4 Fill3(in vec4 color, in vec2 uv)
{
    return vec4(sin(uv.x), cos(uv.y), 0.0, 0.0);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    //fragColor.x = uv.x;
    //fragColor.y = uv.y;
    fragColor = Fill2(fragColor, uv);
    
    //PostPass(fragColor);
}