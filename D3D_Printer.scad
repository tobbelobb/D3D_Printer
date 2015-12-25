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
    circle(r=Nema17_ring_radius+3);
  }
}
//l_plate_2d([Nema17_cube_width+4*(Smooth_rod_r+3),Nema17_cube_width],
//            Nema17_cube_width+2*(Smooth_rod_r+3));

// Plates attached to stepper motors
// s: XY size of plate (vector or scalar)
// smooth_rod_separation: Between smooth rod centers
// h: Height of clamping cylinders
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
          cylinder(r=Smooth_rod_r+1.5, h=h-1);
        translate([0,0,-1]){
          // Inner clamp cylinder
          cylinder(r=Smooth_rod_r, h=h+3);
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

// smooth_rod_separation: Between smooth rod centers
// show_motor: if true, render motor
// show_rods: if true, render rods
module l_module(smooth_rod_separation,show_motor=true,show_rods=true){
  if(show_rods){
    smooth_rods(smooth_rod_separation,Smooth_rod_length,Smooth_rod_r);
  }
  // Place l_plates over and below
  if(show_motor){
    translate([0,0,Plastic_thickness])
      Nema17();
  }
  for(k=[0,Nema17_cube_height+Plastic_thickness])
    translate([0,0,k])
      l_plate([Nema17_cube_width+4*(Smooth_rod_r+3),Nema17_cube_width],
              smooth_rod_separation,
              Clamp_height);
}
l_module(Nema17_cube_width+2*(Smooth_rod_r+3));
