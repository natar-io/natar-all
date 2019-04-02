var sketch = function(p) {
    var img = null;
    let markers = [];

    p.setup = function(){
        p.createCanvas(640, 480);
        p.background(0);
    },

    p.loadRedisImage = () => {
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
            p.updateMarkers();
        })
        .catch(function (error) {
            // handle error
            console.log(error);
        })

        // Timeout function for live preview
        setTimeout(function() {
            p.loadRedisImage();
        }, document.getElementById("input-framerate").value );
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
                img.pixels[idx] = 255; // no transparency
                k = 0;
            }
        }
        img.updatePixels();
    },

    p.updateMarkers = () => {
        axios.get('/nectar/redis/get/camera0:markers')
        .then( function(response) {
            markers = [];
            let obj = JSON.parse(JSON.stringify(response.data));
            for (let i = 0 ; i < obj.markers.length ; ++i) {
                markers.push(obj.markers[i]);
            }
        })
        .catch( function(error) {
            console.log(error);
        })
    }

    p.drawMarkers = () => {
        for (let i = 0 ; i < markers.length ; ++i) {
            let marker = markers[i];
            let centerX = marker.center[0];
            let centerY = marker.center[1];

            p.push();
            p.fill(0, 255, 0);
            p.textSize(12);
            p.text("" + marker.id, centerX, centerY);
            for (let c = 0 ; c < marker.corners.length; c+=2) {
                p.fill(255, 0, 0);
                p.noStroke();
                p.ellipse(marker.corners[c], marker.corners[c+1], 3, 3);
                if (c != 0) {
                    p.stroke(255, 0, 0);
                    p.line(marker.corners[c-2], marker.corners[c-1], marker.corners[c], marker.corners[c+1])
                }
            }
            p.pop();
        }
    }

    p.draw = () => {
        p.background(0);
        if(img != null) {
            p.image(img, 0, 0, 640, 480);
        }

        p.drawMarkers();
    }

};
