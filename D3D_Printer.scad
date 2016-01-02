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
module bearing_608_clamp_2d(r = Bearing_608_outer_radius-3){
  difference(){
    square(Nema17_cube_width, center=true);
    circle(r=r);
    translate([-r,0])
      square([2*r, Nema17_cube_width]);
    Nema17_screw_holes_2d();
  }
}

// Square flat piece clamping bearing down
module bearing_608_clamp(){
  color("greenYellow")
  linear_extrude(height=Plastic_thickness)
    bearing_608_clamp_2d();
}
//bearing_608_clamp();

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

// Screw holes along l_plates with matching holes in frame sides
l_holes_2d_positions = [//[ 0,0],
                        //[1*( Nema17_screw_hole_dist)/4,0],
                        //[1*(-Nema17_screw_hole_dist)/4,0],
                        [2*( Nema17_screw_hole_dist)/4,0],
                        [2*(-Nema17_screw_hole_dist)/4,0],
                        //[3*( Nema17_screw_hole_dist)/4,0],
                        //[3*(-Nema17_screw_hole_dist)/4,0],
                        //[4*( Nema17_screw_hole_dist)/4,0],
                        //[4*(-Nema17_screw_hole_dist)/4,0],
                        //[5*( Nema17_screw_hole_dist)/4,0],
                        //[5*(-Nema17_screw_hole_dist)/4,0],
                        [6*( Nema17_screw_hole_dist)/4,0],
                        [6*(-Nema17_screw_hole_dist)/4,0],
                        //[7*( Nema17_screw_hole_dist)/4,0],
                        //[7*(-Nema17_screw_hole_dist)/4,0],
                        //[8*( Nema17_screw_hole_dist)/4,0],
                        //[8*(-Nema17_screw_hole_dist)/4,0],
                        //[9*( Nema17_screw_hole_dist)/4,0],
                        //[9*(-Nema17_screw_hole_dist)/4,0],
                        [10*( Nema17_screw_hole_dist)/4,0],
                        [10*(-Nema17_screw_hole_dist)/4,0],
                        //[11*( Nema17_screw_hole_dist)/4,0],
                        //[11*(-Nema17_screw_hole_dist)/4,0],
                        //[12*( Nema17_screw_hole_dist)/4,0],
                        //[12*(-Nema17_screw_hole_dist)/4,0],
                        //[13*( Nema17_screw_hole_dist)/4,0],
                        //[13*(-Nema17_screw_hole_dist)/4,0],
                        [14*( Nema17_screw_hole_dist)/4,0],
                        [14*(-Nema17_screw_hole_dist)/4,0],
                        ];

module l_plate_2d_hole_translate(){
  for(k=l_holes_2d_positions)
  translate(k)
    children();
}
//l_plate_2d_hole_translate() circle(r=1.5);

module l_plate_holes(){
  big = 100;
  k = l_holes_2d_positions;
  rotate([-90,0,0]){
    // Right M3 hole
    translate([1.5*Nema17_screw_hole_dist,0,
              Nema17_cube_width/2 - Plastic_thickness-0.5])
      scale(1.02)
      M3_screw(big);
    // Left M3 hole
    translate([-1.5*Nema17_screw_hole_dist,0,
              Nema17_cube_width/2 - Plastic_thickness-0.5])
      scale(1.02)
      M3_screw(big);
  }
}
//l_plate_holes();


// On the frame pieces, one hole string is this distance from edge
//   Steel_thickness
// + (Nema17_cube_width - Nema17_screw_hole_dist)/2

// The other one is this distance from the other edge
//    Frame_width
//  - (Steel_thickness
//     + (Nema17_cube_width - Nema17_screw_hole_dist)/2
//     + Nema17_screw_hole_dist)

// Plates attached to stepper motors
// s: XY size of plate (vector or scalar)
// h: Height of clamping cylinders above plastic plate
// smooth_rod_separation: Between smooth rod centers
module l_plate(s = [L_module_width,Nema17_cube_width],
               h = Clamp_height,
               smooth_rod_separation=L_module_smooth_rod_separation){
  color("red"){
  big = 200;
  // These values are strongly coupled to Side_plates
  l_holes_height0 = Steel_thickness
                    + (Nema17_cube_width - Nema17_screw_hole_dist)/2;
  l_holes_height1 = Frame_width
                    - (Steel_thickness
                      + (Nema17_cube_width - Nema17_screw_hole_dist)/2
                      + Nema17_screw_hole_dist);

  // XY plate
  linear_extrude(height=Plastic_thickness)
    l_plate_2d(s, smooth_rod_separation);
  difference(){
    linear_extrude(height=Plastic_thickness + Clamp_height)
      difference(){
        l_plate_2d(s, smooth_rod_separation);
        translate([-big/2,-big+Nema17_cube_width/2-Plastic_thickness])
          square(big);
      }
    translate([0,0,l_holes_height0])
      l_plate_holes();
    translate([0,0,l_holes_height1])
      l_plate_holes();
    translate([-Nema17_cube_width/2-12,0,-0.02])
      cube([Nema17_cube_width+24,big,big]);
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
}
//l_plate();

// A linear actuator based on a leadscrew, a nut and a stepper motor
// s: XY size of plate (vector or scalar)
// h: full length of the module. Note! leadscrew_length < h
// smooth_rod_separation: Between smooth rod centers
// show_motor: if true, render motor
// show_rods: if true, render rods
module l_module(s = [L_module_width,Nema17_cube_width],
                h = L_module_length,
                smooth_rod_separation=L_module_smooth_rod_separation){
  // Plates under motor
  l_plate();
  // Plate over motor
  translate([0,0,Nema17_cube_height+2*Plastic_thickness])
    rotate([0,180,0])
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

// Screw holes for fastening motors and corners
module Frame_holes_2d(){
  translate([Side_length/2, Side_length/2])
  for(r = [0 : 90 : 359])
  rotate([0,0,r]){
    translate([0, Side_length/2-Steel_thickness
                 - (Nema17_cube_width - Nema17_screw_hole_dist)/2])
      l_plate_2d_hole_translate() circle(r=1.5);
    translate([0, Side_length/2-Steel_thickness
                 - (Nema17_cube_width - Nema17_screw_hole_dist)/2
                 - Nema17_screw_hole_dist])
      l_plate_2d_hole_translate() circle(r=1.5);
  }

}
//Frame_holes_2d();

module Frame_plate_2d(){
  difference(){
    square(Side_length);
    translate([Frame_width, Frame_width])
      rounded_square(Side_length-2*Frame_width, 10);
    // Screw holes for fastening motors and corners
    Frame_holes_2d(Side_length, Side_length,
                        Steel_thickness, Steel_thickness);
  }
}
//Frame_plate_2d();

module Frame_plate(){
  color("lightSteelBlue")
  linear_extrude(height=Steel_thickness)
    Frame_plate_2d();
}
//Frame_plate();

module assembled_printer(){
  // The frame
  if(Show_frame){
    if(Show_Y_side){
      translate([-Cube_X_length/2,Steel_thickness,0])
        rotate([90,0,0])
        Frame_plate(); // Closest to origo
      translate([-Cube_X_length/2,Cube_Y_length,0])
        rotate([90,0,0])
        Frame_plate();
    }
    if(Show_X_side){
      for(k=[1,-1])
        translate([k*(Cube_X_length/2-Steel_thickness/2),
            Steel_thickness,0])
          rotate([90,0,90])
          translate([0,0,-Steel_thickness/2])
          Frame_plate();
    }
  }

  // The Y axis modules
    translate([Cube_X_length/2-Nema17_cube_width/2-Steel_thickness,
        Steel_thickness,
        Side_length/2 + 2*Nema17_screw_hole_dist])
      rotate([-90,-90,0])
      l_module();
    translate([-(Cube_X_length/2-Nema17_cube_width/2-Steel_thickness),
        Steel_thickness,
        Side_length/2 + 2*Nema17_screw_hole_dist])
        //Cube_Z_length - 2*Nema17_screw_hole_dist])
      rotate([-90,90,0])
      l_module();

  // Z module
  translate([0,Nema17_cube_width/2+Steel_thickness,
             L_module_length])
  rotate([180,0,0])
    l_module();
}
assembled_printer();
