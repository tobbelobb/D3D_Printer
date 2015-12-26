include <Measured_numbers.scad>
include <Design_numbers.scad>
use <util.scad>

// 2D drawing of smooth rods in the XY plane, centered
// s: Distance between centers
// r: radius of rods
module smooth_rods_2d(s, r){
  for(k=[0,1])
    mirror([k,0])
      translate([s/2,0])
      circle(r=r);
}
//smooth_rods_2d(20,3);

// Pair of smooth rods, centered
// smooth_rod_separation: Between smooth rod centers
// r: radius of rods
// h: length of rods
module smooth_rods(smooth_rod_separation, h, r){
  color("silver")
    linear_extrude(height=h, slices=1)
    smooth_rods_2d(smooth_rod_separation, r);
}
//smooth_rods(20, 30, 3);

// 2D drawing of plates attached to stepper motors
// s: XY size of plate (vector or scalar)
// smooth_rod_separation: Between smooth rod centers
module l_plate_2d(s, smooth_rod_separation){
  difference(){
    square(s, center=true);
    Nema17_screw_holes_2d();
    // Holes for smooth rods
    smooth_rods_2d(smooth_rod_separation, Smooth_rod_r);
    // Hole for Nema17 ring and Bearing_608 (they both have r=11)
    circle(r=Bearing_608_outer_radius);
  }
}
//l_plate_2d([Nema17_cube_width+4*(Smooth_rod_r+3),Nema17_cube_width],
//            Nema17_cube_width+2*(Smooth_rod_r+3));

// Plates attached to stepper motors
// s: XY size of plate (vector or scalar)
// smooth_rod_separation: Between smooth rod centers
// h: Height of clamping cylinders above plastic plate
module l_plate(s, smooth_rod_separation, h){
  big = 100;
  // Show rods (use for rendering only)
  // XY plate
  linear_extrude(height=Plastic_thickness)
    l_plate_2d(s, smooth_rod_separation);
  // Clamps for smooth rods
  for(k=[0,1])
    mirror([k,0])
      translate([smooth_rod_separation/2,0,0])
      difference(){
        translate([0,0,1])
          // Outer clamp cylinder
          cylinder(r=Smooth_rod_r+1.5, h=Plastic_thickness+h-1);
        translate([0,0,-1]){
          // Inner clamp cylinder
          cylinder(r=Smooth_rod_r, h=Plastic_thickness+h+3);
          // Grooves to let clamp flex
          cube([2,big,big],center=true);
          rotate([0,0,90])
            cube([2,big,big],center=true);
        }
      }
}
//l_plate([Nema17_cube_width+4*(Smooth_rod_r+3),Nema17_cube_width],
//         Nema17_cube_width+2*(Smooth_rod_r+3),
//         Clamp_heigth);

// 2d profile of a four threaded leadscrew (square threads)
// r: Radius of threads along X and Y axes
module leadscrew_2d(r){
  circle(r=r-1);
  square([2,2*r],center=true);
  rotate(90)
    square([2,2*r],center=true);
}
//leadscrew_2d(4);

// Four threaded leadscrew (square threads) without nut
// r: Radius of threads along X and Y axes
// lead_of_thread: length of linear travel per revolution
// h: height of leadscrew
module leadscrew(r, lead_of_thread, h){
  revs = h/lead_of_thread;
  color("LightSlateGrey")
  linear_extrude(height=h, twist=-revs*360)
    leadscrew_2d(r=r);
}
//leadscrew(Leadscrew_r, 8, 300);

module bearing_608_clamp(){
  linear_extrude(height=Plastic_thickness)
  difference(){
    square(Nema17_cube_width, center=true);
    circle(r=Bearing_608_outer_radius-3);
    Nema17_screw_holes_2d();
  }
}

// A linear actuator based on a leadscrew, a nut and a stepper motor
// h: full length of the module. Note! leadscrew_length < h
// smooth_rod_separation: Between smooth rod centers
// show_motor: if true, render motor
// show_rods: if true, render rods
module l_module(h,smooth_rod_separation,
                show_motor=true,show_rods=true,show_screws=true){
  if(show_rods){
    // Smooth rods
    smooth_rods(smooth_rod_separation,h,Smooth_rod_r);
  }
  if(show_motor){
    translate([0,0,Plastic_thickness]){
      // Stepper motor
      Nema17();
      // Leadscrew
      leadscrew(Leadscrew_r,
                Leadscrew_lead_of_thread,
                h-Plastic_thickness);
    }
  }
  for(k=[0,Nema17_cube_height+Plastic_thickness])
    translate([0,0,k])
      // Plates over and under motor
      l_plate([Nema17_cube_width+4*(Smooth_rod_r+3),Nema17_cube_width],
              smooth_rod_separation,
              Clamp_height);
  translate([0,0,h-Bearing_608_width])
    // Bearing supporting leadscrew
    Bearing_608();
  translate([0,0,h])
    mirror([0,0,1])
    // Plate supporting 608 bearing
    l_plate([Nema17_cube_width+4*(Smooth_rod_r+3),Nema17_cube_width],
            smooth_rod_separation,
            Clamp_height);
  translate([0,0,h-Bearing_608_width-Plastic_thickness])
    // Plate for keeping 608 bearing in place
    bearing_608_clamp();
  if(show_screws){
    Nema17_screw_translate(){
      translate([0,0,-10])
      // Motor screws from below
      M3_screw(25);
      translate([0,0,Nema17_cube_height+1])
      // Motor screws from above
      M3_screw(12,true);
      translate([0,0,h-16])
      // Screws clamping 608 bearing
      M3_screw(25);
    }
  }
}
//l_module(Nema17_with_leadscrew_height,
//         Nema17_cube_width+2*(Smooth_rod_r+3));

// The X shaped steel plate that is paralell with the Y-direction
// of the printer. Note that corner is in origo here.
module X_side_2d(){
  s = Cube_Y_length-2*Steel_thickness;
  // Angle between the cross and the XY plane
  ang = atan(Cube_Z_length/Cube_Y_length);
  x_offs = Cross_width/(2*sin(ang));
  y_offs = Cross_width/(2*cos(ang));
  // The steel cross. Points declared in counterclockwise order
  polygon([[0,0], // Origo
           [x_offs, 0], // 
           [s/2, Cube_Z_length/2-y_offs],
           [s-x_offs, 0],
           [s, 0], // Bottom right corner
           [s, y_offs],
           [s/2+x_offs, Cube_Z_length/2],
           [s, Cube_Z_length-y_offs],
           [s, Cube_Z_length], // Top right corner
           [s-x_offs, Cube_Z_length],
           [s/2, Cube_Z_length/2+y_offs],
           [x_offs, Cube_Z_length],
           [0,Cube_Z_length], // Top left corner
           [0,Cube_Z_length-y_offs],
           [s/2-x_offs, Cube_Z_length/2],
           [0, y_offs]]);
  // TODO: place Nema17 screw holes in all corners
  //Nema17_screw_holes();
}
X_side_2d();
