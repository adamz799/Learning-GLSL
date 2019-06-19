#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float plot(vec2 st, float y){
  float delta = 0.012;
  float dy = step(y-delta,st.y)-step(y+delta,st.y);
  // float dx = step(y,st.x)-step(y+0.08,st.x);
  // return  smoothstep( y-0.06, y, st.y) -
  //         smoothstep( y, y+0.06, st.y);
  return dy;
}

float circle(float l, float r){
  float ratio = 0.05;
  float dy = step((1.-ratio)*r,l)-step((1.+ratio)*r,l);
  // float dx = step(y,st.x)-step(y+0.08,st.x);
  // return  smoothstep( y-0.06, y, st.y) -
  //         smoothstep( y, y+0.06, st.y);
  return dy;
}

float plot_point(vec2 dis, float x, float r)
{
  float delta = 0.05;
  float sin_val=sin(x),cos_val = cos(x);
  float v_sin = dis.y/r, v_cos = dis.x/r;
  float pcl = step(sin_val-delta,v_sin)-step(sin_val+delta,v_sin);
  pcl*= 1.-step(cos_val+delta,v_cos);
  pcl += step(cos_val-delta,v_cos)-step(cos_val+delta,v_cos);
  pcl*= step(sin_val-delta,v_sin);
  
  return pcl;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    //circle
    float radius = 0.25;
    vec2 center = vec2(0.75,0.25);
    vec2 dis = st-center;
    float l = dot(dis,dis);
    float pcl_circle = circle(l, radius*radius);
    
    //point
    float x = 1.2*u_time*PI;
    float pcl_p = plot_point(dis, x, radius);
    vec2 region = step(vec2(0.5, st.y),vec2(st.x,0.5));
    pcl_p*=region.x*region.y;
    
    //sin
    float y = 0.25*(sin(6.*PI*(st.x-0.5)+x)+1.);
    float pcl = plot(st,y)*step(st.x, 0.5);

    //cos
    float y2 = 0.25*(cos(6.*PI*(st.x-0.5)+x)+1.)+0.5;
    pcl += plot(st,y2)*step(st.x, 0.5);

    vec2 center2 = vec2(0.5);
    vec2 dis2 = st-center2;
    float l2 = dot(dis2,dis2);
    float r2 = 0.25*(cos(x)+1.);
    float pcl_circle2 = circle(l2,r2*r2);
    vec2 region2 = step(vec2(0.5),st);
    pcl_circle2*=region2.x*region2.y;
    pcl+=pcl_circle2;
    
    vec3 color = pcl*vec3(1.)+pcl_circle*vec3(0.5,0.5,1.)+pcl_p;//+pcl_circle2*vec3(1.,0.5,0.5);
    gl_FragColor = vec4(color,1);

}