// color game

if (!STOVELIB) {
    throw "Stove's library not found";
}
if (!LEVELS) {
    throw "Color levels are not loaded";
}

//var container_div = $("game_container");
var canvas = $("color_game");
var score = $("score");
var levelpick = $("level_selector");
var diffpick = $("difficulty_selector");
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
    map_id: 777,
    map_width: 10,
    map_height: 10,

    difficulty: 5,
    turn_count: 0,
    game_over: false,
    painting: false,
};

var on_resize = function() {
    var new_width = window.innerWidth;
    console.log("New width: " + new_width);
    if (new_width > 800) new_width = 800;
    WORLD.W = new_width;
    WORLD.H = new_width;
    WORLD.square.width = new_width / WORLD.map_width;
    WORLD.square.height = new_width / WORLD.map_height;
    canvas.width = WORLD.W;
    canvas.height = WORLD.H;
};
on_resize(); // init at load time
window.onresize = on_resize; // then bind to window


var on_levelselect = function(){
    var v = levelpick.value;
    console.log("Level picked: " + v);
    if (v == 777) {
	gen_random_map();
	return;
    }
    if (v < 0 || v > LEVELS.length) {
	console.log("Critical error loading Map " + v);
	return;
    }
    WORLD.map = []; // reset the world to nothing
    // only way I can copy without using a reference bind
    for(var y=0; y < LEVELS[v].length; y++) {
	var tmp_arr = [];
	for(var x=0; x < LEVELS[v][y].length; x++){
	    tmp_arr.push(LEVELS[v][y][x]);
	}
	WORLD.map.push(tmp_arr);
    }
    var new_height = LEVELS[v].length;
    var new_width = LEVELS[v][0].length;
    WORLD.turn_count = 0;
    score.innerHTML = "Turns: 0";
    WORLD.map_id = v;
    WORLD.map_width = new_width;
    WORLD.map_height = new_height;
    WORLD.square.width = WORLD.W / WORLD.map_width;
    WORLD.square.height = WORLD.H / WORLD.map_height;
    shuffle_current_map();
};
levelpick.onchange = on_levelselect; // bind the event

var on_difficulty_set = function() {
    var v = diffpick.value;
    WORLD.difficulty = v;
    show_buttons();
    shuffle_current_map();
};
diffpick.onchange = on_difficulty_set;


var show_buttons = function() {
    for(var n=1; n < 10; n++) {
	var butt = $("button"+n);
	if (n <= WORLD.difficulty) {
	    butt.style.display = "inline";
	} else {
	    butt.style.display = "none";
	}
    }
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
    case 7: return "brown"; break;
    case 8: return "grey"; break;
    case 9: return "white"; break;
    default: return "black"; break;
    }
}


// equivalent to a mapcar over the entire map
var iter_over_map = function(proc) {
    for (var y=0; y < WORLD.map.length; y++) {
	for (var x = 0; x < WORLD.map[y].length; x++) {
	    proc(x, y);
	}
    }
    return true;
}

// used to apply an andmap across the entire map
var and_over_map = function(proc) {
    var iterv = true;
    var tmp = true;
    for (var y=0; y < WORLD.map.length; y++) {
	for (var x=0; x < WORLD.map[y].length; x++) {
	    tmp = proc(x, y);
	    if (!(iterv && proc))
		return false;
	    iterv = tmp;
	}
    }
    return true;
}

var gen_random_map = function() {
    if (WORLD.painting) {
	return;
    }
    WORLD.painting = true;
    iter_over_map(function(x,y) {
	WORLD.map[y][x] = randp(1,WORLD.difficulty);
    });
    WORLD.painting = false;
    return;
}

var shuffle_current_map = function() {
    if (WORLD.painting) {
	return;
    }
    WORLD.turn_count = 0;
    score.innerHTML = "Turns: 0";
    if (WORLD.map_id == 777) {
	return gen_random_map();
    }
    WORLD.painting = true;
    iter_over_map(function(x,y) {
	if (WORLD.map[y][x] != 0) {
	    WORLD.map[y][x] = randp(1,WORLD.difficulty);
	}
    });
    WORLD.painting = false;
    return;
};


var on_click = function(num){
    if (WORLD.painting) {
	return;
    }
    var root_color = WORLD.map[0][0];
    WORLD.turn_count += 1;
    WORLD.painting = true;
    paint_traverse(0,0,root_color,num);
    score.innerHTML = "Turns: " + WORLD.turn_count;
    WORLD.painting = false;
};

var paint_traverse = function(x, y, old_color, new_color){
    // check if we're in bounds

    // push co-ords to here in a [x,y] array
    var Q = [[x,y]];
    var V = 0;

    while (Q.length) {
	var item = Q.pop();
	
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
    return;
};


var init = function() {
    canvas.width = WORLD.W;
    canvas.height = WORLD.H;

    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, WORLD.W, WORLD.H);

    on_difficulty_set();
    //gen_random_map();

    window.requestAnimationFrame(loop);
};

var paint_square = function(x, y) {
    ctx.fillStyle = to_color(WORLD.map[y][x]);
    ctx.fillRect(
	x * WORLD.square.width,
	y * WORLD.square.height,
	WORLD.square.width,
	WORLD.square.height
    )
}


var loop = function() {
    iter_over_map(paint_square);
    window.requestAnimationFrame(loop);
};

init();

// end
