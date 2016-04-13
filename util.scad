include <Measured_numbers.scad>

// Threadless M3 screw with hex head
// h: height (length) of the screw
// head_height: for custom head heights. Doesn't affect overall height
// updown: put head at other end
// center: translate cylinder so that mass centrum is in origo
module M3_screw(h, head_height=M3_head_height,
                updown=false, center=false){
  color("grey"){
  if(center){
    translate([0,0,-h/2])
      cylinder(r=M3_diameter/2, h=h);
      if(updown){
        translate([0,0,h/2-head_height])
          cylinder(r=M3_head_diameter/2, h=head_height, $fn=6);
      }else{
        translate([0,0,-h/2])
        cylinder(r=M3_head_diameter/2, h=head_height, $fn=6);
      }
  }else{
      cylinder(r=M3_diameter/2, h=h);
      if(updown){
        translate([0,0,h-head_height])
          cylinder(r=M3_head_diameter/2, h=head_height, $fn=6);
      }else{
        cylinder(r=M3_head_diameter/2, h=head_height, $fn=6);
      }
    }
  }// end of color
}
//M3_screw(10, center=true, updown=true);

module Nema17_screw_translate(){
  for (i=[0:90:359]){
    rotate([0,0,i+45]) translate([Nema17_screw_hole_width/2,0,0]) children();
  }
}

module Nema17_screw_holes(r, h){
  Nema17_screw_translate() cylinder(r=r, h=h);
}
//Nema17_screw_holes(M3_diameter/2, 15);

module Nema17_screw_holes_2d(r=1.5){
  Nema17_screw_translate() circle(r=r);
}
//Nema17_screw_holes(M3_diameter, 15);

module Nema17(){
  cw = Nema17_cube_width;
  ch = Nema17_cube_height;
  sh = Nema17_shaft_height;
  union(){
    color("black")
    difference(){
      translate([-(cw-0.1)/2,-(cw-0.1)/2,1]) cube([cw-0.1,cw-0.1,ch-2]);
      for (i=[0:90:359]){ // Corner cuts black cube
        rotate([0,0,i+45]) translate([50.36/2,-cw/2,-1]) cube([cw,cw,ch+2]);
      }
    }
    color("silver")
    difference(){
      translate([-cw/2,-cw/2,0]) cube([cw,cw,ch]);
      for (i=[0:90:359]){ // Corner cuts silver cube
        rotate([0,0,i+45]) translate([53.36/2,-cw/2,-1]) cube([cw,cw,ch+2]);
      }
      translate([0,0,ch-5]) Nema17_screw_holes(M3_diameter/2, h=10);
      translate([0,0,-5]) Nema17_screw_holes(M3_diameter/2, h=10);
      translate([-cw,-cw,9]) cube([2*cw,2*cw,ch-18]);
    }
    color("silver")
    difference(){
      cylinder(r=Nema17_ring_radius, h=ch+Nema17_ring_height);
      translate([0,0,1]) cylinder(r=8.76/2, h=ch+Nema17_ring_height);
    }
    color("silver")
      cylinder(r=5/2, h=sh);
  }
}
//Nema17();

module Bearing(outer_r, inner_r, h, center=false){
  color("blue")
  difference(){
    cylinder(r=outer_r, h=h, center=center);
    translate([0,0,-3])
      cylinder(r=inner_r, h=h+6, center=center);
  }
}

module Bearing_608(center=false){
  Bearing(Bearing_608_outer_radius, Bearing_608_bore_radius, Bearing_608_width, center=center);
}
//Bearing_608();

module Bearing_623(center=false){
  Bearing(Bearing_623_outer_radius, Bearing_623_bore_radius, Bearing_623_width, center=center);
}
//Bearing_623();

// Used for rendering a shadow of printers outer dimensions
module Meas_cube(){
  translate([-Cube_X_length/2,0,0])
  %cube([Cube_X_length, Cube_Y_length, Cube_Z_length]);
}
//Meas_cube();

// Works with both vector[2] and scalar type of s
module Rounded_square(s, r){
  if(len(s) == undef){
    // The circles
    for(k = [[r,r],[s-r,r],[s-r,s-r],[r,s-r]])
      translate(k)
      circle(r);
    // The squares
    translate([r,0])
      square([s-2*r, s]);
    translate([0,r])
      square([s, s-2*r]);
  }else if(len(s) ==2){
    // The circles
    for(k = [[r,r],[s[0]-r,r],[s[0]-r,s[1]-r],[r,s[1]-r]])
      translate(k)
      circle(r);
    // The squares
    translate([r,0])
      square([s[0]-2*r, s[1]]);
    translate([0,r])
      square([s[0], s[1]-2*r]);
  }
}

module LM8UU(){
  color("grey")
  difference(){
    cylinder(r = LM8UU_big_r, h = LM8UU_length);
    translate([0,0,-1])
      cylinder(r = LM8UU_small_r, h = LM8UU_length+2);
  }
}
//LM8UU();

module Hose_clamp1(h, r){
  big = 100;
  difference(){
    union(){
      cylinder(r = r, h = h);
      translate([0,-2,0])
        cube([r+3, 4, h]);
    }
    translate([0,0,-1])
      cylinder(r = r-0.8, h = h+2);
    translate([0,-1,-1])
      cube([big, 2, h+2]);
  }
}
//Hose_clamp1();

module Hose_clamp(h, r, th=0.8, jacks=true){
  big = 100;
  flerp = 10;
  color("lightgrey")
  difference(){
    union(){
      cylinder(r = r, h = h);
      translate([0,-2,0])
        cube([r+5, 4, h]);
      rotate([0,0,-15])
      translate([r-th,-flerp,0])
        cube([th, flerp, h]);
    }
    translate([0,0,-1])
      cylinder(r = r-th, h = h+2);
    if(jacks){
      for(i=[0:100/r:360]){
        rotate([0,0,i])
        translate([0,0,h/4])
          cube([r+3,0.5,h/2]);
      }
    }
    translate([r+1, 5, h/2])
    rotate([90,0,0])
      M3_screw(16, updown=true);
  }
}
//Hose_clamp(h=8, r=LM8UU_big_r+2);

// 2d profile of a four threaded leadscrew (square threads)
// r: Radius of threads along X and Y axes
module leadscrew_2d(r, number_of_starts){
  circle(r=r-1);
  for(i=[0:360/number_of_starts:359])
    rotate([0,0,i])
      translate([-1,0,0])
      square([2,r]);
}
//leadscrew_2d(4, 4);

// Four threaded leadscrew (square threads) without nut
// r: Radius of threads along X and Y axes
// lead_of_thread: length of linear travel per revolution
// h: height of leadscrew
module leadscrew(r                = Leadscrew_r,
                 lead_of_thread   = Leadscrew_lead_of_thread,
                 h                = Nema17_with_leadscrew_height,
                 number_of_starts = Leadscrew_number_of_starts){
  revs = h/lead_of_thread;
  color("LightSlateGrey")
  linear_extrude(height=h, twist=-revs*360)
    leadscrew_2d(r, number_of_starts);
}
//leadscrew();

