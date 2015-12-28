
Steel_thickness   = 3;
Smooth_rod_r      = 5; // 10 mm diameter
Smooth_rod_length = 300;
Plastic_thickness = M3_wrench_size;
Clamp_height      = 15;

L_module_length   = Nema17_with_leadscrew_height + Plastic_thickness;

// Lengths of sides of individual sheets
Side_length       = L_module_length;

// Outermost lengths of frame cube
// This is determined by corner mounting strategy
Cube_X_length     = Side_length; // X in printer's coordinate sys
Cube_Y_length     = Side_length + 2*Steel_thickness; // Y in printer's coordinate sys
Cube_Z_length     = Side_length;


// Every frame sheet is shaped as a rectangular frame.
// This width keeps l_modules behind frame sides.
Frame_width       = max(2*Plastic_thickness + Nema17_cube_height,
                        Nema17_cube_width + Steel_thickness);

//L_module_width    = Nema17_cube_width+4*(Smooth_rod_r+4);
L_module_width    = 3*Nema17_cube_width;
L_module_smooth_rod_separation = Nema17_cube_width+2*(Smooth_rod_r+3);

L_plate_height = Nema17_cube_height + Plastic_thickness;
