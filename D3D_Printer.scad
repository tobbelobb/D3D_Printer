include <Measured_numbers.scad>
include <Design_numbers.scad>
include <Rendering_control.scad>
use <util.scad>

// Default argument values are meant as default values
// Explicitly giving modules arguments are only for experimentation

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

// Square flat piece clamping bearing down
module bearing_608_clamp_2d(){
  difference(){
    square(Nema17_cube_width, center=true);
    circle(r=Bearing_608_outer_radius-3);
    Nema17_screw_holes_2d();
  }
}

// Square flat piece clamping bearing down
module bearing_608_clamp(){
  linear_extrude(height=Plastic_thickness)
    bearing_608_clamp_2d();
}

// 2D drawing of plates attached to stepper motors
// s: XY size of plate (vector or scalar)
// smooth_rod_separation: Between smooth rod centers
module l_plate_2d(s = [L_module_width,Nema17_cube_width],
                 smooth_rod_separation=L_module_smooth_rod_separation){
  difference(){
    //square(s, center=true);
    polygon([[-smooth_rod_separation/2,-s[1]/2],
             [-s[0]/2,s[1]/2],
             [s[0]/2,s[1]/2],
             [smooth_rod_separation/2,-s[1]/2]]);
    // Screw holes
    Nema17_screw_holes_2d();
    // Holes for smooth rods
    smooth_rods_2d(smooth_rod_separation, Smooth_rod_r);
    // Hole for Nema17 ring and Bearing_608 (they both have r=11)
    circle(r=Bearing_608_outer_radius);
  }
}
//l_plate_2d();


// Plates attached to stepper motors
// s: XY size of plate (vector or scalar)
// h: Height of clamping cylinders above plastic plate
// smooth_rod_separation: Between smooth rod centers
module l_plate(s = [L_module_width,Nema17_cube_width],
               h = Clamp_height,
               smooth_rod_separation=L_module_smooth_rod_separation){
  big = 100;
  // Show rods (use for rendering only)
  // XY plate
  difference(){
    linear_extrude(height=Plastic_thickness)
      l_plate_2d(s, smooth_rod_separation);
    translate([0,0,Plastic_thickness/2])
      rotate([-90,0,0]){
        translate([0,0,-Nema17_cube_width/2-0.1])
          scale(1.02)
          M3_screw(big); // Center M3 hole, outer edge
        translate([0,0,Bearing_608_outer_radius-0.7])
          scale(1.02)
          M3_screw(big); // Center M3 hole, bearing edge
        translate([Nema17_screw_hole_width/2,0,
                  -Nema17_cube_width/2-0.1])
          scale(1.02)
          M3_screw(big); // Right center M3 hole
        translate([-Nema17_screw_hole_width/2,0,
                  -Nema17_cube_width/2-0.1])
          scale(1.02)
          M3_screw(big); // Left center M3 hole
        translate([Nema17_screw_hole_width,0,
                  -9])
          scale(1.02)
          M3_screw(big, head_height=10); // Right M3 hole
        translate([-Nema17_screw_hole_width,0,
                  -9])
          scale(1.02)
          M3_screw(big, head_height=10); // Left M3 hole
      }
  }
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
//l_plate();

// A linear actuator based on a leadscrew, a nut and a stepper motor
// s: XY size of plate (vector or scalar)
// h: full length of the module. Note! leadscrew_length < h
// smooth_rod_separation: Between smooth rod centers
// show_motor: if true, render motor
// show_rods: if true, render rods
module l_module(s = [L_module_width,Nema17_cube_width],
                h = Nema17_with_leadscrew_height,
                smooth_rod_separation=L_module_smooth_rod_separation){
  for(k=[0,Nema17_cube_height+Plastic_thickness])
    translate([0,0,k])
      // Plates over and under motor
      l_plate();
  translate([0,0,h-Bearing_608_width])
    // Bearing supporting leadscrew
    Bearing_608();
  translate([0,0,h])
    mirror([0,0,1])
    // Plate supporting 608 bearing
    l_plate();
  translate([0,0,h-Bearing_608_width-Plastic_thickness])
    // Plate for keeping 608 bearing in place
    bearing_608_clamp();
//****** Below here is render-only parts *******//
  if(Show_rods){
    // Smooth rods
    smooth_rods(smooth_rod_separation,h,Smooth_rod_r);
  }
  if(Show_motor){
    translate([0,0,Plastic_thickness]){
      // Stepper motor
      Nema17();
      // Leadscrew
      if(Show_leadscrew){
        leadscrew(Leadscrew_r,
                  Leadscrew_lead_of_thread,
                  h-Plastic_thickness);
      }
    }
  }
  if(Show_screws){
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
//l_module();

// Holes for corner pieces in X- and Y-plates
// sx: The X-size of plate in question
// sy: The Y-size of plate in question
// x_clr: Clearance from edge of plate in X-direction
// y_clr: Clearance from edge of plate in Y-direction
module Sideplate_holes_2d(sx, sy, x_clr, y_clr){
    // Bottom left
translate([   Nema17_cube_width/2+x_clr,    Nema17_cube_width/2+y_clr])
      Nema17_screw_holes_2d();
    // Bottom right
translate([sx-Nema17_cube_width/2-x_clr,    Nema17_cube_width/2+y_clr])
      Nema17_screw_holes_2d();
    // Top right
translate([sx-Nema17_cube_width/2-x_clr, sy-Nema17_cube_width/2-y_clr])
      Nema17_screw_holes_2d();
    // Top left
translate([   Nema17_cube_width/2+x_clr, sy-Nema17_cube_width/2-y_clr])
      Nema17_screw_holes_2d();
}
//Sideplate_holes_2d(Cube_X_length, Cube_Z_length,
//                   Steel_thickness, Steel_thickness);

// The X-shaped steel plate paralell with Y-direction.
// Note that corner is in origo in this module.
// In finished printer it will be translated.
// All parameters found in Design_numbers.scad
module X_side_2d(){
  s = Cube_Y_length-2*Steel_thickness;
  ang = atan(Cube_Z_length/Cube_Y_length);// Between cross and XY plane
  x_offs = Cross_width/(2*sin(ang));
  y_offs = Cross_width/(2*cos(ang));
  difference(){
    // The steel cross. Points declared in counterclockwise order
    polygon([[0,0], // Origo
             [x_offs, 0],
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
    // Corner screw holes
    // Note that all holes are translated Steel_thickness away from
    // outermost edges to allow symmetrical corner fastener pieces
    Sideplate_holes_2d(s, Cube_Z_length, 0, Steel_thickness);
  }
}
//X_side_2d();

module X_side(){
  color("lightGrey")
  linear_extrude(height=Steel_thickness)
    X_side_2d();
}
//X_side();

module Y_side_2d(){
  difference(){
    square([Cube_X_length, Cube_Z_length]);
    // Corner screw holes
    // Note that all holes are translated Steel_thickness away from
    // outermost edges to allow symmetrical corner fastener pieces
    Sideplate_holes_2d(Cube_X_length, Cube_Z_length,
                       Steel_thickness, Steel_thickness);
  }
}
//Y_side_2d();

module Y_side(){
  color("lightGrey")
  linear_extrude(height=Steel_thickness)
    Y_side_2d();
}
//Y_side();

// Holes for corner pieces in X- and Y-plates
// sx: The X-size of plate in question
// sy: The Y-size of plate in question
// x_clr: Clearance from edge of plate in X-direction
// y_clr: Clearance from edge of plate in Y-direction
module Sideplate_holes2_2d(sx, sy, x_clr, y_clr){
}
//Sideplate_holes2_2d(Cube_X_length, Cube_Z_length,
//                   Steel_thickness, Steel_thickness);


module X_side2_2d(){
  w = 2*Plastic_thickness + Nema17_cube_height;
  s = Cube_Y_length-2*Steel_thickness;
  difference(){
    square([s, Cube_Z_length]);
    translate([w, w])
     rounded_square([s-2*w, Cube_Z_length-2*w], 10);
    // Corner screw holes
    // Note that all holes are translated Steel_thickness away from
    // outermost edges to allow symmetrical corner fastener pieces
    Sideplate_holes2_2d(s, Cube_Z_length,
                        0, Steel_thickness);
  }
}
//X_side2_2d();

module X_side2(){
  color("lightGrey")
  linear_extrude(height=Steel_thickness)
    X_side2_2d();
}
//X_side2();


module Y_side2_2d(){
  w = 2*Plastic_thickness + Nema17_cube_height; // Width of steel band
  difference(){
    square([Cube_X_length, Cube_Z_length]);
    translate([w, w])
     rounded_square([Cube_X_length-2*w, Cube_Z_length-2*w], 10);
    // Corner screw holes
    // Note that all holes are translated Steel_thickness away from
    // outermost edges to allow symmetrical corner fastener pieces
    Sideplate_holes2_2d(Cube_X_length, Cube_Z_length,
                        Steel_thickness, Steel_thickness);
  }
}
//Y_side2_2d();


module Y_side2(){
  color("DarkGrey")
  linear_extrude(height=Steel_thickness)
    Y_side2_2d();
}
//Y_side2();

module assembled_printer(){
  // The frame
  if(Show_frame){
    if(Show_Y_side){
      translate([-Cube_X_length/2,Steel_thickness,0])
        rotate([90,0,0])
        Y_side2(); // Closest to origo
      translate([-Cube_X_length/2,Cube_Y_length,0])
        rotate([90,0,0])
        Y_side2();
    }
    if(Show_X_side){
      for(k=[1,-1])
        translate([k*(Cube_X_length/2-Steel_thickness/2),
            Steel_thickness,0])
          rotate([90,0,90])
          translate([0,0,-Steel_thickness/2])
          X_side2();
    }
  }

  // The Y axis modules
    translate([Cube_X_length/2-Nema17_cube_width/2-Steel_thickness,
        Steel_thickness,
        Cube_Z_length - L_module_width/2])
      rotate([-90,-90,0])
      l_module();
    translate([-(Cube_X_length/2-Nema17_cube_width/2-Steel_thickness),
        Steel_thickness,
        Cube_Z_length - L_module_width/2])
      rotate([-90,90,0])
      l_module();

  // Z module
  translate([0,Nema17_cube_width/2+Steel_thickness,
             Smooth_rod_length])
  rotate([180,0,0])
    l_module();
}
assembled_printer();
