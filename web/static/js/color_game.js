// color game

if (!STOVELIB) {
    throw "Stove's library not found";
}

var canvas = $("color_game");
var ctx = canvas.getContext('2d');

// Mutable properties of the world
var WORLD = {
    W: 700,
    H: 700,
    square: {
	width: 70,
	height: 70,
    },

    map: [
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
	[0,1,2,3,4,5,6,7,0,1],
    ],
    map_width: 10,
    map_height: 10,

    difficulty: 6,
    turn_count: 0,
    game_over: false,
    painting: false,
};

var to_color = function(num) {
    switch (num) {
    case 0: return "black"; break;
    case 1: return "red"; break;
    case 2: return "green"; break;
    case 3: return "blue"; break;
    case 4: return "purple"; break;
    case 5: return "cyan"; break;
    case 6: return "yellow"; break;
    default: return "black"; break;
    }
}

var set_difficulty = function(diff) {
};

var iter_over_map = function(proc) {
    for (var y=0; y < WORLD.map.length; y++) {
	for (var x = 0; x < WORLD.map[y].length; x++) {
	    console.log("applying iteration " + x + "," + y);
	    proc(x, y);
	}
    }
    return true;
}

var shuffle_map = function() {
    return iter_over_map(function(x,y) {
	WORLD.map[y][x] = randp(1,WORLD.difficulty);
    });
}


var on_click = function(num){
    if (WORLD.painting) {
	console.log("Still processing, hang on");
	return;
    }
    console.log("Player input: " + num);
    var root_color = WORLD.map[0][0];
    WORLD.turn_count += 1;
    WORLD.painting = true;
    paint_traverse(0,0,root_color,num);
    WORLD.painting = false;
    console.log("All done");
};

var paint_traverse = function(x, y, old_color, new_color){
    // check if we're in bounds

    // push co-ords to here in a [x,y] array
    var Q = [[x,y]];
    var V = 0;

    while (Q.length) {
	var item = Q.pop();
	console.log("Checking " + item[0] + " " + item[1]);
	
	V = WORLD.map[item[1]][item[0]];
	if (V != old_color) {
	    continue; // dont even bother doing anything
	}
	if (V == new_color) {
	    continue; // already painted this node
	}
	WORLD.map[item[1]][item[0]] = new_color;
	if (item[1] > 0)
	    Q.push([item[0], item[1]-1]);
	if (item[1] < WORLD.map.length-1)
	    Q.push([item[0], item[1]+1]);
	if (item[0] > 0)
	    Q.push([item[0]-1, item[1]]);
	if (item[0] < WORLD.map.length-1)
	    Q.push([item[0]+1, item[1]]);
    }
    console.log("done here");
    return;
};

var init = function() {
    console.log("initing");
    canvas.width = WORLD.W;
    canvas.height = WORLD.H;

    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, WORLD.W, WORLD.H);

    shuffle_map();

    window.requestAnimationFrame(loop);
};


var loop = function() {
    for (var y=0; y < WORLD.map.length; y++) {
	for (var x=0; x < WORLD.map[y].length; x++) {
	    ctx.fillStyle = to_color(WORLD.map[y][x]);
	    ctx.fillRect(x*WORLD.square.width,
			 y*WORLD.square.height,
			 WORLD.square.width,
			 WORLD.square.height
			);
	}
    }
    window.requestAnimationFrame(loop);
};

init();

// end
