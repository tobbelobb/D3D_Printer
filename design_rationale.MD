= Inspiration =
The printer will be similar to a Prusa i3 Steel.
This is because of its history as a workshop friendly printer.


== Linear motion ==
A 3-axis Cartesian 3D printer needs to control linear movement very precisely.
To keep firmware simple and computational load low, open loop arrangements (no sensor feedback regarding motion) are preferred for simple printers.
This could for example be achieved by putting electromagnets on a row and placing a ferromagnet above it.
Sequentially activating the electromagnets would make the ferromagnet move along a straight line in a controlled way.

Pros of this solution:
 - Easy to understand
 - Open loop control, no feedback or feedback processing needed
Cons:
 - Needs many electromagnets and wires (doesn't scale)
 - Off the shelf driver soulutions not available
 - A range of possible speed/force-ratios are built into the machine
 - Steps are discrete, so precision is limited

All small 3d printer designs overcomes the cons by having the electromagnets arranged in a circle,
and the ferromagnets attached to a shaft right in the middle of it.
This gives the advantages
 - Scaling problem solved. Can do infinitely many rotations with fix number of magnets.
... but adds the disadvantage
 - Outputs rotational motion that needs to be converted into linear motion

Converting the rotation into a linear motion could be done in a number of ways:
#Rotating a pulley that drive a belt/wire
#Rotating a threaded shaft
#Rotating a gear that "walks" a toothed strip
See Polhems mechanical alphabet for suggestions...

== Pulley and Belt or Wire ==
The usual way to drive the axes of a 3d printer is by belts (GT2) or by some kind of non-flexible line/wire.
The pros of belts/wires:
 - Cheap
 - Well known/widely used
 - Easy to source
 - You can change gear ratio by changing pulley, keeping the belt itself
Cons of belts/wires:
 - Must be cut to length
 - Must be fastened somehow
 - Must be tightened somehow
 - Needs retightening after some time
 - Needs guides and bearings to run smooth and stay in place

== Threaded shafts ==
Within the CNC world, threaded shafts are the standard way  belts don't cut it since a CNC generally needs a lot of force.
Threaded shafts are 

The X and Y axis are going to be driven by threaded shafts, as is customary on CNC machines.
Threaded shafts typically give slow and powerful (geared down) motion compared to pulleys and belts.

Since we want relatively high speeds in a 3D printer the rods need to be aggresively threaded.
See for example:
[http://www.kitprinter3d.com/en/linear-motion/87-husillos-8mm-x-300mm.html]

The shape of the screws are important for converting rotational motion into linear motion.
Trapezoidal screws is much better than construction screws.
[forums.reprap.org/read.php?406,581540,588921]

To minimize wear on the rod, its important that the nut and the rod are made out of two different metals.

Motors with threaded shafts already mounted are available.
[http://fr.aliexpress.com/item/2Set-lot-NEMA-17-Linear-Stepper-Motor-Lead-Screw-300mm-M8-Z-axis-3D-Printer-CNC/32217928693.html?spm=2114.06010108.3.21.iRG7eR&ws_ab_test=searchweb201556_7_79_78_77_80_61,searchweb201644_5,searchweb201560_9]
This eliminates the need for a coupling between the motor and the shafts.
Couplings are usual sources for misalignments, so getting away from them is a big relief.

The pros of ready-mounted threaded shafts:
 - Easy fail safe mounting
 - High and predictable over time precision
 - No maintainance
 - Needs less support than belts
The cons of ready-mounted threaded shafts:
 - Harder to source
 - More expensive
 - Fixed threading, gearing down must be done in other ways

== Linear guides ==
