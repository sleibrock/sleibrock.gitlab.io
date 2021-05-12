// Complex library

// Export as a single-object binding
var Complex = {
    "init" : function(r, i) {
	return {
	    "real": r,
	    "imag": i,
	};
    },

    "is_complex" : function(C) {
	return C.hasOwnProperty("real")
	    && C.hasOwnProperty("imag");
    },
    
    "add" : function(Ca, Cb) {
	return init_complex(
	    (Ca.real) + (Cb.real),
	    (Ca.imag) + (Cb.imag),
	);
    },
    
    "sub" : function(Ca, Cb) {
	return init_complex(
	    (Ca.real) - (Cb.real),
	    (Ca.imag) - (Cb.imag),
	);
    },
    
    "mul" : function(Ca, Cb) {
	return init_complex(
	    (Ca.real * Cb.real) - (Ca.imag * Cb.imag),
	    (Ca.imag * Cb.real) + (Ca.real * Cb.imag)
	);
    },
    
    "div" : function(Ca, Cb) {
	var divisor = (Cb.real*Cb.real)+(Cb.imag*Cb.imag);
	return init_complex(
	    ((Cb.real*Cb.real)+(Ca.imag*Cb.imag))/divisor,
	    ((Ca.imag*Cb.real)-(Ca.real*Cb.imag))/divisor
	);
    },
    
    "conjugate" : function(Ca, Cb) {
	return init_complex(
	    (Ca.real)*(-1.0),
	    (Cb.real)*(-1.0)
	);
    },
    
    "neg" : function(C) {
	return init_complex(
	    -(C.real),
	    -(C.imag)
	);
    },
    
    "length2" : function(C) {
	return (C.real*C.real)+(C.imag*C.imag);
    },
};

// end
