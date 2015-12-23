include <Measured_numbers.scad>
use <util.scad>

// 2d drawing to be extruded
// Holes will be placed according to motor shape and size
module XZ_Plate(w=250, // Total width of frame
                h=250, // Total height of frame
                render_motors = true){
  leg_w=Nema17_cube_width; // leg width
  leg_h=Nema17_cube_height; // bar connecting legs
  difference(){
    square([w,h]);
    translate([leg_w,-1])
      square([w-2*leg_w, h-leg_h+1]);
  }
  if(render_motors){
    for(k=[0,w-Nema17_cube_width])
      translate([k,h])
        rotate([90,0])
        translate([Nema17_cube_width/2,Nema17_cube_width/2])
        Nema17();
  }
}
XZ_Plate();
