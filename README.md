# D3D_Printer
The 3D printer design for the [D3D Fusion Project](http://opensourceecology.org/wiki/D3D_Fusion). Design rationale is found [here](http://opensourceecology.org/wiki/D3D_Fusion_printer_design).

## Build
Use OpenSCAD version 2015.03 or later. See [OpenSCAD web page](www.openscad.org/downloads.html) for instructions. Open up `Footer.scad`, and explore by uncommenting single lines (render single modules).

## Code style and structure
### Use good names
Global parameters names are capitalized. `Smooth_rod_separation` is global, `smooth_rod_separation` is not. The larger the parameter scope, the longer and more descriptive the name.

Modules in `util.scad` have capitalized names. All other modules have non-capitalized names.

### Prefer 2D drawings
Flat modules and flat parts of nearly flat modules are drawn in 2D first and then extruded to preserve support for manufacturing processes that cut parts from sheet material.

### Make thoughts/ideas/contracts explicit with comments
Any sub-module that's too small to be a meaningful module definition can still have a meaningful name. Make informal in-line comments like `// Middle weird hole near edge`.

Describe relevant thoughts on usage, interfaces and parameters above any module definition. Put explicit usage examples in `Footer.scad`.

### Files
**Measured_numbers.scad**
Parameters that are collected from blueprints of parts that are supposed to be bought already mounted.

**Design_numbers.scad**
The parameters that a builder/kit maker of this printer needs to decide/know.

**D3D_Printer.scad**
The body of this design. Contains the main module, called `assembled_printer()`.

**Rendering_control.scad**
Contains some booleans controlling if categories of parts should be rendered as well as rendered positions for moving parts.

**Footer.scad**
Lists defined modules after they have been defined in `D3D_printer.scad`. Useful for exploring modules, arranging them for easier printing and similar. All modules listed here should use `Design_numbers.scad` to define sensible default values of all parameters.

**dummy.scad**
Toy modules with hard coded parameters.

**util.scad**
Generally useful modules copied exactly from other projects.
