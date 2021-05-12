// A Mandelbrot demo rasterizer

var MAX_ITERS = 100;
var BREAKOUT = 4.0;

(function(cnv_id){

    var m_iter = function(Z, C) {
	if !(Complex.is_complex(Z)){
	    return "fail";
	}
	if !(Complex.is_complex(C)){
	    return "fail";
	}
	var count = 0;

	while(Complex.length2(Z)<BREAKOUT
	      && count++ < MAX_ITERS){
	    Z = Complex.mul(Z,Z);
	    Z = Complex.add(Z,C);
	}
	return count;
    };




    
})("mandelbrot");

// end
