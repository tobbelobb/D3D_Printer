include <Measured_numbers.scad>
include <Design_numbers.scad>
include <Rendering_control.scad>
use <util.scad>

// Default argument values are meant as default values
// Explicitly giving modules arguments are only for experimentation

// This translating module defines the interface between printed parts and smooth rods
// (in a plane perpendicular to smooth rods themselves)
// Note that symmetry is enforced by mirroring the translated children
module smooth_rod_split(separation = Smooth_rod_separation){
  for(k=[0,1])
    mirror([k,0])
    translate([separation/2,0,0])
    children();
}

// 2D drawing of smooth rods in the XY plane, centered
// s: Distance between centers
// r: radius of rods
module smooth_rods_2d(s, r){
  smooth_rod_split(s)
    circle(r=r);
}
//smooth_rods_2d(20,3);

// Pair of smooth rods, centered
// smooth_rod_separation: Between smooth rod centers
// r: radius of rods
// h: length of rods
module smooth_rods(smooth_rod_separation = Smooth_rod_separation,
                   h = L_module_length,
                   r = Smooth_rod_r){
  color("silver")
    linear_extrude(height=h, slices=1)
    smooth_rods_2d(smooth_rod_separation, r);
}
//smooth_rods(20, 30, 3);

// Helper translating module to easier match screw holes in flange and moving bit
// Defines flange planar interface
module flange_hole_translate(){
  for(i=[0:360/4:359])
    rotate([0,0,i])
      translate([Leadscrew_flanged_nut_screw_hole_width/2,0,-1])
      children();
}

// The nut running up and down leadscrew
// Parameters are found in Measured_numbers.scad
module leadscrew_flange_nut(total_height = Flanged_nut_height){
  color("goldenrod")
  difference(){
    union(){
      // Center cylinder
      cylinder(r = Flanged_nut_small_r, h = total_height);
      // Flange
      translate([0,0,Flange_offset])
        cylinder(r = Flanged_nut_big_r, h = Flange_thickness);
    }
    // screw holes
    flange_hole_translate()
      cylinder(r = 3.75/2, h = total_height+2);
    // Only dig out tracks if leadscrew itself is not shown
    if(!Show_leadscrew){
      translate([0,0,-1])
        leadscrew();
    }
  }
}
//leadscrew_flange_nut();

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
                 smooth_rod_separation=Smooth_rod_separation){
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
// Defines the interface to frame sides
l_holes_2d_positions = [[2*( Nema17_screw_hole_dist)/4,0],
                        [2*(-Nema17_screw_hole_dist)/4,0],
                        [6*( Nema17_screw_hole_dist)/4,0],
                        [6*(-Nema17_screw_hole_dist)/4,0],
                        [10*( Nema17_screw_hole_dist)/4,0],
                        [10*(-Nema17_screw_hole_dist)/4,0],
                        [14*( Nema17_screw_hole_dist)/4,0],
                        [14*(-Nema17_screw_hole_dist)/4,0],
                        [18*( Nema17_screw_hole_dist)/4,0],
                        [18*(-Nema17_screw_hole_dist)/4,0]];

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
    translate(concat(k[2], // concat() requires OpenSCAD version 2015.03 or later
              Nema17_cube_width/2 - Plastic_thickness-0.5))
      scale(1.02)
      M3_screw(big);
    // Left M3 hole
    translate(concat(k[3],
              Nema17_cube_width/2 - Plastic_thickness-0.5))
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
               smooth_rod_separation=Smooth_rod_separation){
  color("red"){
  big = 200;
  // These values are specialized to make l_modules match the interface of side plates
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
  // TODO: A slit in XY plate and a clamping screw could fill same function is it better?
  //       Can we do it without bending the whole l_plate?
  smooth_rod_split(smooth_rod_separation){
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
    } // end of difference
  } // end of smooth_rod_split
  }// end of color
}
//l_plate();

// A custom linear bearing build out of three 623 rotational bearings
module linear_bearing(w = Linear_bearing_width){
  //color("red")
  difference(){
    // Walls cube
    cube(w, center=true);
    // Antimateria cube
    translate([0,Plastic_thickness,0])
      cube([w - 2*Plastic_thickness, w, w +2],
           center=true);
    // Dig out place for bearings
    for(i=[0,120,240])
      rotate([0,0,i])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        scale(1.02)
        Bearing_623(center=true);
      }
    // Screw across opening
    translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0])
      scale(1.03){
        M3_screw(h=w+1, head_height=4, center=true);
        M3_screw(h=w+1, head_height=4, updown=true, center=true);
      }
    // Screws across corners
    for(i=[120,240])
      rotate([0,0,i])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        scale(1.02){
          M3_screw(h=w+1, head_height=7, updown=i!=120, center=true);
          M3_screw(h=w+1, head_height=10, updown=i==120, center=true);
        }
      }
  }
  //**** Rendering ****//
  if(Show_screws){
    for(i=[0,120,240])
      rotate([0,0,i+0])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        M3_screw(h=w+1, center=true);
      }
  }
  if(Show_bearings){
    for(i=[0,120,240])
      rotate([0,0,i])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        Bearing_623(center=true);
      }
  }
}
//linear_bearing();

module linear_bearing2_2d(w = Linear_bearing_width - 1.5*Plastic_thickness){
  // A triangle with a commented out chop off corner...
  module shape(ws){
    difference(){
      rotate([0,0,-30])
        circle(r=ws, $fn=3);
      //rotate([0,0,150])
      //  translate([-ws-Bearing_623_outer_radius-1,0,0])
      //  square(ws, center=true);
    }
  }
  difference(){
    // Outer walls
    shape(w + 1.5*Plastic_thickness);
    // Antimateria triangle
    shape(w); // Render incorrectly in preview
    // Opening
    translate([0,50,0])
      square([2*Smooth_rod_r, 100], center=true);
  }
}

// A custom linear bearing build out of three 623 rotational bearings
module linear_bearing2(w = Linear_bearing_width){
  //color("red")
  difference(){
    translate([0,0,-w/2])
      linear_extrude(height=w, convexity=4)
      linear_bearing2_2d();
    // Space for screw across opening
    translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0])
      scale(1.02){
        M3_screw(h=w+1, head_height=4, center=true);
        M3_screw(h=w+1, head_height=4, updown=true, center=true);
      }
    // Space for screws across corners
    for(i=[120,240])
      rotate([0,0,i])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        scale(1.02){
          M3_screw(h=w+1, head_height=7, updown=i!=120, center=true);
          M3_screw(h=w+1, head_height=10, updown=i==120, center=true);
        }
      }
  }
  //**** Rendering ****//
  if(Show_screws){
    for(i=[0,120,240])
      rotate([0,0,i+0])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        M3_screw(h=w+1, center=true);
      }
  }
  if(Show_bearings){
    for(i=[0,120,240])
      rotate([0,0,i])
      translate([0,Bearing_623_outer_radius + Smooth_rod_r,0])
      rotate([0,90,0]){
        Bearing_623(center=true);
      }
  }
}
//linear_bearing2();


// This is the moving part of the linear module
// It interfaces with the leadscrew, flanged nut and smooth rods through interfaces:
//   smooth_rod_split()
//   flange_hole_translate()
// And through variables:
//   Flanged_nut_small_r
//   Flanged_nut_big_r
//   Flange_offset
//   Flange_thickness
// TODO: Finish this
module m_module(){
  big = 100;
  w = Linear_bearing_width;
  r_with_nut_clearance = Flanged_nut_small_r+0.5;
  difference(){
    //color("red")
    // Bridge between linear bearings
    translate([-(Smooth_rod_separation - w + 1)/2,-w/2,w/2-Plastic_thickness])
      cube([Smooth_rod_separation - w + 2,w,Plastic_thickness]);
    cylinder(r = r_with_nut_clearance, h = big);
    flange_hole_translate()
      M3_screw(h=big);
    // Slit for removal of leadscrew nut
    translate([-r_with_nut_clearance,0,0])
      cube([2*r_with_nut_clearance, w, big]);
  }
  smooth_rod_split()
    linear_bearing(w);
  //**** Below here are render only parts ****//
  if(Show_flanged_nut){
    translate([0,0,w/2 + Flange_offset + Flange_thickness])
      mirror([0,0,1])
      leadscrew_flange_nut();
  }
  if(Show_screws){
    difference(){
    translate([0,0,w/2 + Flange_offset + Flange_thickness + 0.5]) // 0.5 avoid z-fight
      mirror([0,0,1])
      flange_hole_translate()
      M3_screw(h=20);
    translate([-r_with_nut_clearance,3,-1])
      cube([2*r_with_nut_clearance, w, big]);
    }
  }
}
//m_module();

// This is the moving part of the linear module
// It interfaces with the leadscrew, flanged nut and smooth rods through interfaces:
//   smooth_rod_split()
//   flange_hole_translate()
// And through variables:
//   Flanged_nut_small_r
//   Flanged_nut_big_r
//   Flange_offset
//   Flange_thickness
module m_module2(){
  big = 100;
  w = Linear_bearing_width;
  r_with_nut_clearance = Flanged_nut_small_r+0.5;
  center_triangle_r = Smooth_rod_separation/2-1.8;
  difference(){
    //color("red")
    // Bridge between linear bearings
    translate([0,3.7,w/2-Plastic_thickness])
      rotate([0,0,30])
      cylinder(r=center_triangle_r, h=Plastic_thickness, $fn=3);
    // Cutting tip of center triangle
    translate([0,-big/2 - Linear_bearing_width/2,0])
      cube(big, center=true);
    // Hole for flanged nut and leadscrew to come through
    cylinder(r = r_with_nut_clearance, h = big);
    flange_hole_translate()
      M3_screw(h=big);
    // Slit for removal of leadscrew nut
    translate([-r_with_nut_clearance,0,0])
      cube([2*r_with_nut_clearance, w, big]);
  }
  smooth_rod_split()
    linear_bearing2(w);
  //**** Below here are render only parts ****//
  if(Show_flanged_nut){
    translate([0,0,w/2 + Flange_offset + Flange_thickness])
      mirror([0,0,1])
      leadscrew_flange_nut();
  }
  if(Show_screws){
    difference(){
    translate([0,0,w/2 + Flange_offset + Flange_thickness + 0.5]) // 0.5 avoid z-fight
      mirror([0,0,1])
      flange_hole_translate()
      M3_screw(h=20);
    translate([-r_with_nut_clearance,3,-1])
      cube([2*r_with_nut_clearance, w, big]);
    }
  }
}
//m_module2();

module m_module3(h = 4*LM8UU_length){
  flange_nut_offset = Flanged_nut_small_r+1;
  LM8UU_to_edge = 4;
  translate([0,0,-h/2])
  for(i=[0,1]){
    translate([0,0,i*h])
    mirror([0,0,i]){
      difference(){
        translate([-Smooth_rod_separation/2 - 2*LM8UU_big_r,0,0])
          cube([Smooth_rod_separation + 4*LM8UU_big_r, Plastic_thickness, h/2+1]);
        smooth_rod_split(){
          // Lower LM8UU groove
          translate([0,0,LM8UU_to_edge]){
            cylinder(r = LM8UU_big_r, h = LM8UU_length); // Cylinder stand-in for LM8UU
            translate([0,0,-4+LM8UU_length/2])
              rotate([0,0,-90])
              Hose_clamp(h=8, r=LM8UU_big_r+2.5, th=1, jacks=false);
          }
          translate([0,0,-1])
            cylinder(r=Smooth_rod_r+0.2, h=100);
        }
        // Cutout for flange nut in Z-direction
        translate([-Flanged_nut_big_r-1, -1, -1])
          cube([2*Flanged_nut_big_r+2, Plastic_thickness+2, Flanged_nut_height+2]);
        // Screw holes
        translate([0,Plastic_thickness+1,h/2])
          rotate([90,0,0])
          Nema17_screw_holes(r = 1.5, h = 10);
      }
      difference(){
        // Push area for flanged nut
        translate([-Flanged_nut_big_r-1,-flange_nut_offset-Flanged_nut_big_r, Flanged_nut_height+1])
          cube([2*Flanged_nut_big_r+2, flange_nut_offset + Flanged_nut_big_r, Plastic_thickness]);
        translate([0,-flange_nut_offset,0]){
          // Cylindrical cutout in XY-plane for flanged nut
          cylinder(r=Flanged_nut_small_r+1, h=100);
          translate([0,0,10])
            flange_hole_translate()
            M3_screw(20); // Holes for fastening flanged nut in push area
        }
      }
      if(Show_flanged_nut){
        translate([0,-flange_nut_offset,Flange_offset + Flange_thickness/2 + LM8UU_length/2])
          mirror([0,0,1])
          leadscrew_flange_nut();
      }
      if(Show_LM8UU){
        translate([0,0,LM8UU_to_edge])
        smooth_rod_split(){
          LM8UU();
          translate([0,0,-4+LM8UU_length/2])
            rotate([0,0,-90])
            Hose_clamp(h=8, r=LM8UU_big_r+2.5);
        }
      }
    }
  }
}
//m_module3();

// A linear actuator based on a leadscrew, a nut and a stepper motor
// s: XY size of plate (vector or scalar)
// h: full length of the module. Note! leadscrew_length < h
// smooth_rod_separation: Between smooth rod centers
module l_module(h = L_module_length,
                smooth_rod_separation=Smooth_rod_separation){
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
        leadscrew();
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
  if(Show_m_module){
    translate([0,0,Flanged_nut_pos])
    mirror([0,1,0])
      m_module3();
  }
}
//translate([0,80,0])
//l_module();

module l_plate2(h=Plastic_thickness){
  big = 100;
  color("red")
  difference(){
    union(){
      translate([Space_besides_Nema17_interface/2,0,0])
        // Main block
        cube([Interfacing_block_height,
            Interfacing_block_width,
            h],
            center=true);
      translate([Smooth_rod_off_center,0,0])
        difference(){
          // Clamp
          cylinder(r=Smooth_rod_r+Clamp_thickness, h = Clamp_height);
          cube([Clamp_opening,big,big],center=true);
        }
    }
    // Opening for bearing
    cylinder(r = Bearing_608_outer_diameter/2 + 0.2,
        h = h+1, center=true);
    Nema17_screw_translate()
      // Screw holes
      cylinder(r=1.8,h=h+10, center=true);
    translate([Smooth_rod_off_center,0,0])
      // Opening for smooth rod
      cylinder(r=Smooth_rod_r+0.35, h = big, center=true);
  }
}
//l_plate2();

module LM8UU_bands(h, th){
    for(l = [3, LM8UU_length-3-h])
      translate([0,0,l])
        //rotate([0,0,-12])
          //scale([1,1.15,1])
            difference(){
              cylinder(r=LM8UU_big_r+1.2+th, h=h);
              translate([0,0,-1])
              cylinder(r=LM8UU_big_r+1.2, h=h+2);
            }
}

module move_plate2(){
  move_plate_off_center = Smooth_rod_r + Plastic_thickness/2 + 0.7;
  color("red"){
    difference(){
      translate([Space_besides_Nema17_interface/2,0,0])
        // Main block
        cube([Interfacing_block_height ,
            Interfacing_block_width,
            Plastic_thickness],
            center=true);
      Nema17_screw_translate()
        // Screw holes
        cylinder(r=1.8,h=Plastic_thickness+10, center=true);
      // Grooves for LM8UU linear bearings
      translate([Smooth_rod_off_center,0,-move_plate_off_center]){
        translate([0,-1,0])
          rotate([90,0,0]){
            LM8UU();
            LM8UU_bands(h=6, th=1.2);
          }
        translate([0,LM8UU_length + 1,0])
          rotate([90,0,0]){
            LM8UU();
            LM8UU_bands(h=6, th=1.2);
          }
      }
      // Hole for flanged nut
      rotate([-90,0,0])
        scale(1.02){
          translate([0,0,-Flanged_nut_height/2])
            hull(){
              translate([0,0,2])
                leadscrew_flange_nut();
              translate([0,0,-2])
                leadscrew_flange_nut();
            }
        }
      translate([-Flanged_nut_small_r,
                 -Flanged_nut_height,
                 -(Plastic_thickness/2+1)])
        // Extra space for backwards mounted flanged nut
        cube([2*Flanged_nut_small_r,10,Plastic_thickness+2]);
    }
    for(k=[0,1])
      mirror([k,0,0])
        difference(){
          translate([Flanged_nut_small_r,0,
              -1.7*Flanged_nut_big_r+Plastic_thickness/2])
            // Blocks that flanged nut pushes
            cube([Flanged_nut_big_r-Flanged_nut_small_r+1,
                Plastic_thickness,
                1.7*Flanged_nut_big_r]);
          // Elongenated holes for fastening flanged nut
            hull(){
              translate([0,0,-7])
                rotate([-90,0,0])
                translate([Leadscrew_flanged_nut_screw_hole_width/2,0,-1])
                cylinder(r=1.7,h=25,center=true);
              translate([0,0,-11])
                rotate([-90,0,0])
                translate([Leadscrew_flanged_nut_screw_hole_width/2,0,-1])
                cylinder(r=1.7,h=25,center=true);
            }
        }
  } // end color red
}
//rotate([180,0,0])
//move_plate2();

module l_module2(){
  Nema17();
  leadscrew();
  move_plate_off_center = Smooth_rod_r + Plastic_thickness/2 + 0.7;
  translate([0,0,Plastic_thickness/2+Nema17_cube_height])
    // Bottom plate (near Nema17)
    l_plate2();
  translate([0,0,-Plastic_thickness/2+Nema17_with_leadscrew_height]){
    rotate([180,0,0])
      // Top plate
      l_plate2();
  }
  translate([0,0,Nema17_with_leadscrew_height-Bearing_608_width-0.1])
    // Bearing
    Bearing_608();
    translate([0,0,Nema17_cube_height])
    translate([Smooth_rod_off_center,0,0]){
      // Smooth rod
      smooth_rod();
      // Place LM8UUs relative to center of flanged nut
      if(Show_LM8UU){
        translate([0,0,Flanged_nut_pos-Nema17_cube_height+Flanged_nut_height/2]){
          translate([0,0,1])
            LM8UU();
          translate([0,0,-LM8UU_length-1])
            LM8UU();
        }
      }
    }
  translate([0,-move_plate_off_center,
               Flanged_nut_pos+Flanged_nut_height/2])
  //translate([0,0,Flanged_nut_pos+Flanged_nut_height/2])
    rotate([90,0,0])
      move_plate2();
  translate([0,0,Flanged_nut_pos])
    leadscrew_flange_nut();
}
//l_module2();

module XY_actuators(){
  for(y=[0,1])
    translate([y*(0.6+2*Plastic_thickness + 2*Smooth_rod_r + Nema17_with_leadscrew_height),0,0])
      mirror([y,0,0])
      rotate([-90,0,0])
      rotate([0,0,90])
      l_module2();
  translate([Leadscrew_r+0.6+Plastic_thickness,
             Flanged_nut_pos + Flanged_nut_height/2,0])
  rotate([0,90,0])
  l_module2();
}
XY_actuators();

module top_frame(){
  translate([-Interfacing_block_width/2,
             Nema17_cube_height,
             -Steel_thickness-Nema17_cube_width/2-Space_besides_Nema17_interface])
    difference(){
      cube([Top_frame_width,Top_frame_height,Steel_thickness]);
      translate([Top_frame_band_width, Top_frame_band_height,-1])
      cube([Top_frame_width - 2*Top_frame_band_width,
            Top_frame_height - 2*Top_frame_band_height,
            Steel_thickness+2]);
  }
}
top_frame();

module Z_actuator(){
  translate([-Interfacing_block_width/2 + Top_frame_width/2,
             -Interfacing_block_width/2+Nema17_with_leadscrew_height,
             -Nema17_cube_width/2-Space_besides_Nema17_interface])
  l_module2();
  for(s=[-1,1])
  translate([-Interfacing_block_width/2+Top_frame_width/2 + s*211/2,
             Nema17_cube_height+Top_frame_band_height/2,
             -Nema17_cube_width/2-Space_besides_Nema17_interface])
  rotate([0,0,90])
  idle_smooth_rod();
}
Z_actuator();

module smooth_rod(){
  color("grey")
    cylinder(r=Smooth_rod_r,
        h=Nema17_with_leadscrew_height-Nema17_cube_height);
}

module idle_smooth_rod_holder(){
  big = 200;
  color("red")
  difference(){
    union(){
      translate([-Interfacing_block_width/2,-Interfacing_block_height/2,0])
        // Main cube
        cube([Interfacing_block_width,
            Interfacing_block_height,
            Plastic_thickness]);
      // Tower
      cylinder(r1=12,r2=Smooth_rod_r+Clamp_thickness-0.5,h=40,$fn=40);
      cylinder(r=Smooth_rod_r+Clamp_thickness, h=50, $fn=40);
    }
    translate([0,0,-1])
      scale([1.01,1.01,1])
      // Hole for smooth rod
      smooth_rod();
    Nema17_screw_translate()
      // Screw holes
      cylinder(r=1.8,h=100, center=true);
    // Slit in clamp
    translate([0,0,big/2+Plastic_thickness+14])
    cube([Clamp_opening,big,big],center=true);
  }
}
//idle_smooth_rod_holder();

module idle_smooth_rod(){
  smooth_rod();
  idle_smooth_rod_holder();
}
//idle_smooth_rod();

// Screw holes for fastening motors and corners
module frame_holes_2d(){
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
//frame_holes_2d();

module frame_plate_2d(){
  difference(){
    square(Side_length);
    translate([Frame_width, Frame_width])
      Rounded_square(Side_length-2*Frame_width, 10);
    // Screw holes for fastening motors and corners
    frame_holes_2d(Side_length, Side_length,
                        Steel_thickness, Steel_thickness);
  }
}
//frame_plate_2d();

module frame_plate(){
  color("lightSteelBlue")
  linear_extrude(height=Steel_thickness)
    frame_plate_2d();
}
//frame_plate();

// The complete assembled printer.
module assembled_printer(){
  // The frame
  if(Show_frame){
    if(Show_Y_side){
      translate([-Cube_X_length/2,Steel_thickness,0])
        rotate([90,0,0])
        frame_plate(); // Closest to origo
      translate([-Cube_X_length/2,Cube_Y_length,0])
        rotate([90,0,0])
        frame_plate();
    }
    if(Show_X_side){
      for(k=[1,-1])
        translate([k*(Cube_X_length/2-Steel_thickness/2),
            Steel_thickness,0])
          rotate([90,0,90])
          translate([0,0,-Steel_thickness/2])
          frame_plate();
    }
  }

  // The Y axis modules
    translate([Cube_X_length/2-Nema17_cube_width/2-Steel_thickness,
        Steel_thickness,
        Side_length/2 + 3*Nema17_screw_hole_dist])
      rotate([-90,-90,0])
      l_module();
    translate([-(Cube_X_length/2-Nema17_cube_width/2-Steel_thickness),
        Steel_thickness,
        Side_length/2 + 3*Nema17_screw_hole_dist])
        //Cube_Z_length - 2*Nema17_screw_hole_dist])
      rotate([-90,90,0])
      l_module();

  // Z module
  translate([0,Nema17_cube_width/2+Steel_thickness,
             L_module_length])
  rotate([180,0,0])
    l_module();

  // X module
  translate([-L_module_length/2,
             Steel_thickness+Flanged_nut_pos,
             Nema17_cube_width/2 + Cube_Z_length])
  rotate([-90,0,-90])
  l_module();
}
//assembled_printer();
