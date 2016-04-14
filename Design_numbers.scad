// ********** Design numbers we're going to use when manufacturing by ourselves  ********** //
// ********** Derive these numbers to keep total design information content down ********** //
// General
Plastic_thickness = 6.3;                  // For plastic sheets/walls. Use sensibly
// Linear actuator module
Smooth_rod_length = Nema17_with_leadscrew_height + Plastic_thickness;
Clamp_height          = Nema17_cube_height/2 - 2;   // Must be < Nema17_cube_height/2
//L_module_length       = Nema17_with_leadscrew_height + Plastic_thickness;
L_module_length       = Nema17_with_leadscrew_height; // No bottom plastic
L_module_width        = 2*(L_module_length/2 - 3*Nema17_screw_hole_dist); // For flush top edge
Smooth_rod_separation = Nema17_cube_width+2*(Smooth_rod_r+4);
L_plate_height        = Nema17_cube_height + Plastic_thickness;
// Width of custom linear bearings build from rollerbearings
Linear_bearing_width  = Smooth_rod_r*2 + Bearing_623_outer_radius + 2*Plastic_thickness + M3_radius;
// Steel Frame
Side_length       = L_module_length;                 // Lengths of sides of individual sheets
Cube_X_length     = Side_length;                     // Outer measures of steel cube
Cube_Y_length     = Side_length + 2*Steel_thickness; // determined by corner mounting strategy
Cube_Z_length     = Side_length;
Frame_width       = max(2*Plastic_thickness + Nema17_cube_height, // See module mounting strategy
                        Nema17_cube_width + Steel_thickness);     // Flush l_modules and frame
//** For stripped version **//
Smooth_rod_off_center = Smooth_rod_separation/2;
Interfacing_block_width = 2*LM8UU_length + 1 + 4;
Interfacing_block_height = Nema17_cube_width + (4 + 2*LM8UU_big_r);
Space_besides_Nema17_interface = Interfacing_block_height - Nema17_cube_width;

Top_frame_width = Nema17_with_leadscrew_height+2*(Plastic_thickness+0.6+Smooth_rod_r)+Interfacing_block_width;
Top_frame_height = Nema17_with_leadscrew_height+Nema17_cube_height;
Top_frame_band_width = Interfacing_block_width;
Top_frame_band_height = Interfacing_block_width;
Interfacing_block_edge = (Interfacing_block_width-Nema17_cube_width)/2;

Clamp_thickness = 1.7;
Clamp_opening   = 2;

Bed_lock_height = 30;

// ********** Echoed derived design numbers below here ********** //
echo("Steel sheet frame weight (kg):");
Frame_weight = (4*Frame_width*(Side_length - Frame_width) * Steel_thickness * 4)*0.000008;
echo(Frame_weight);
