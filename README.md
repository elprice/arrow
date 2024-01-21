# Arrow
A module for Windower 4 addons to use to draw a pointed arrow @ x,y,z with a text box containing the target name and distance

![unknown2](https://github.com/elprice/arrow/assets/6643792/db113842-4307-4211-89d4-0a33f04ddc38)
![unknown](https://github.com/elprice/arrow/assets/6643792/a56c0e8e-9f8e-4f41-9846-3acba943eb3d)
![unknown3](https://github.com/elprice/arrow/assets/6643792/1cca02c8-1332-4226-9fa0-eb186cb5d9b2)


## Usage

### In your project:
Copy in Images/ and arrow.lua
```lua
-- load the module
local arrowmodule = require('arrow')

-- create/delete the arrow & text box
arrow.init()
arrow.destroy()

-- update the arrow point at (target_x,target_y) and
--  set the text box to target_name
--  Note: calls arrow.show() 
arrow.update(target_name,target_x,target_y)

-- show/hide the arrow & text box
arrow.show()
arrow.hide()
```

### ArrowDemo
```lua
-- load
lua load arrowdemo

-- point arrow at mob in the mob table
//ad pointat <mob_name>

-- to stop
//ad stop
```

