## Rhombic Enneacontahedron

<img src="/Rhombic-Enneacontahedron/regular.png" width="600">

### Using the testshape.py script:
Use ```testshape.py``` to calculate the angles needed by the OpenSCAD.
This generates a preview using library ```pyny3d``` which you will likely need to install.

There is a degree of freedom in the truncation step, controlled by the ```ALONG_EDGE``` parameter. Setting it to 3 splits one of the edges into 3 equal parts and creates the regular rhombic enneacontahedron shown above. If you set it to a negligible value above 2, it will result in a dodecahron (all blue tiles; red tiles become very small).

<img src="/Rhombic-Enneacontahedron/dodecahedron.png" width="400">

If you set it to a very large value it will start to resemble a rhombic triacontahedron (all red tiles; blue tiles become very small).

<img src="/Rhombic-Enneacontahedron/rhombictriancontahedron.png" width="400">

You can use OpenSCAD file ```tilesAandB.scad``` to generate the tiles. See instructions below.

(Note: The older files, named ```rhombicenneacontahedronA.scad``` and ```rhombicenneacontahedronB.scad``` were designed for only the regular rhombic enneacontahedron with "regular" truncation into three pieces that corresponds to setting ```ALONG_EDGE=3``` in the python script)

### Using the OpenSCAD script:
Decide on the size and thickness of the tiles and the magnet holes depth and diameter in the "User Defined Variables" section. Units are millimeters.
```
//User Defined Variables
side = 30; //side length, these match to red side length
thickness = 8; //how thick (z dimension) the tile is
magnetdepth = 2.25; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 4.45; //diameter of the magnet holes; tailor this to suit your 3d printer
```

Take the angles from the ```testshape.py``` script and paste them over the "Other Variables" section in the ```tilesAandB.scad``` file.
For example, for a regular rhombic enneacontahedron with "regular" truncation into three pieces that corresponds to setting ```ALONG_EDGE=3```:

```
//Other Variables - Get from python script
dihedral2= 159.4455573432933 ;
dihedral= 160.81186354627906 ;
alpha= 56.67993474152847 ;
beta= 69.73165195317623 ;
blue1b= 56.679934741528456 ;
obtuse= 116.79420665264766 ;
sidefactor= 0.830397632781982 ;
```
Don't update the block after that (calculating variables such as ```short```,```phi```,...```ldiag```). Those are calculated off the variables above.

Finally, choose what to render. Choose ```tile_A()``` to generate a "red" tile (shown below on the left). Choose ```tile_B()``` to generate a "blue" tile (shown below on the right).

<img src="/Rhombic-Enneacontahedron/tilesAandB.png" width="600">

Or choose ```unit()``` to generate an assembly of both (note it doesn't fold up perfectly--there's a small error from an angle I estimated instead of calculated). Note in the image below, for an ```ALONG_EDGE=4``` parameter and a very thick tile, the need to "bevel" the point where the three A tiles meet becomes more obvious. This bevel is needed for tiles where ```ALONG_EDGE```>3

<img src="/Rhombic-Enneacontahedron/assembly.png" width="600">

