


var sketch = function(p) {

    var img = null;
    
    p.setup = function(){
	p.createCanvas(640, 480);
	p.background(0);
    }, 

    p.loadRedisImage = function(){
	// Make a request for a user with a given ID
	axios.get('/nectar/redis/get/camera0')
	    .then(function (response) {
		// handle success
		base64 = response.data;
		var raw = window.atob(base64);
		var rawLength = raw.length;
		var array = new Uint8Array(new ArrayBuffer(rawLength));
		
		for(i = 0; i < rawLength; i++) {
		    array[i] = raw.charCodeAt(i);
		}
		p.imageData = array;
		p.updateImageRedis();
		console.log("Get OK");
	    })
	    .catch(function (error) {
		// handle error
		console.log(error);
	    })
	    .then(function () {
		// always executed
	    });
    },
    
    p.updateImageRedis = function() {
	img = p.createImage(640,480,p.RGB);
	img.loadPixels();

	let k = 0;
	let srcIdx = 0;
        for (var idx = 0; idx < img.pixels.length; idx++ ) {
	    img.pixels[idx] = p.imageData[srcIdx];
	    k++;
	    srcIdx++;

	    if(k == 3){
		idx++;
		img.pixels[idx] = 180; // no transparency
		k = 0;
	    }
        }
	img.updatePixels();
    },
    

    //             img.updatePixels();
    //         });
    //         client.quit(function (err, res) {
    //             console.log("Exiting from quit command.");
    //         });
    //     }
    p.draw = function() {
	if(img != null){
	    p.background(100);
	    p.image(img, 0, 0, 640, 480);
	}
    }
    
};


var sketch1 = new p5(sketch, 'p5_test');
