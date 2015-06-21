var width = 720;
var height = 405;
var canvas = document.getElementById("landscape");
var container = document.getElementById("header");
var overlay = document.getElementById("overlay");
var buffer, buffer_canvas;
var pathCleared = true;
var transitioning = false;

var clearBackground = function() {
    buffer.clearRect(0, 0, width, height);
};

var random = function(low, high) {
    if (high === undefined) {
        high = low;
        low = 0;
    }
    return Math.random() * (high - low) + low;
};

var int = function(n) {
    return Math.floor(n);
};

var strokeWeight = function(w) {
    buffer.lineWidth = w;
};

var stroke = function(c) {
    buffer.strokeStyle = c;
};

var line = function(x1, y1, x2, y2) {
    buffer.beginPath();
    buffer.moveTo(x1, y1);
    buffer.lineTo(x2, y2);
    buffer.stroke();
};

var fill = function(c) {
    buffer.fillStyle = c;
};

var beginShape = function() {
    buffer.beginPath();
    pathCleared = true;
};

var vertex = function(x, y) {
    if (pathCleared) {
        buffer.moveTo(x, y);
    } else {
        buffer.lineTo(x, y);
    }
    pathCleared = false;
};

var endShape = function() {
    buffer.closePath();
    buffer.fill();
};

var rect = function(x, y, w, h) {
    buffer.fillRect(x, y, w, h);
};

var ellipse = function(x, y, w, h) {
    buffer.beginPath();
    buffer.ellipse(x, y, w/2, h/2, 0, 0, 2 * Math.PI);
    buffer.fill();
};

var setGradient = function(x, y, w, h, c1, c2) {
    var gradient = buffer.createLinearGradient(0, 0, 0, h);
    gradient.addColorStop(0, c1);
    gradient.addColorStop(1, c2);
    buffer.fillStyle = gradient;
    buffer.fillRect(x, y, w, h);
};

var hexToRGB = function(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
};

var componentToHex = function(c) {
    var hex = int(c).toString(16);
    return hex.length == 1 ? "0" + hex : hex;
};

var rgbToHex = function(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
};

var lerp = function(a, b, n) {
    return Math.abs((b - a) * n + a);
};

var lerpColor = function(beginning, end, percent) {
    var c1 = hexToRGB(beginning);
    var c2 = hexToRGB(end);
    return rgbToHex(
        lerp(c1.r, c2.r, percent),
        lerp(c1.g, c2.g, percent),
        lerp(c1.b, c2.b, percent)
    );
};

var map = function(v, a1, b1, a2, b2) {
    return (((v-a1) / (b1 - a1)) * (b2 - a2) + a2);
};

var perlin = new ClassicalNoise();
var noise = function(x, y) {
    y = y || 0;
    return map(perlin.noise(x, y, 0), -1, 1, 0, 1);
};

var BUILDING_TOP = 0,
    BUILDING_LEFT = -1,
    BUILDING_RIGHT = 1,
    BUILDING_MAX_LEVELS = 2;

var BRANCH_ROOT = 0,
    BRANCH_LEFT = -1,
    BRANCH_RIGHT = 1,
    BRANCH_MAX_LEVELS = 3;

var time, sky, mountains;

var drawScene = function(offsetX, offsetY) {
    sky.draw();
    mountains.draw();
    stage.drawImage(buffer_canvas, offsetX, offsetY);
};

var regenScene = function() {
    width = canvas.width;
    height = canvas.height;
    time = random(1);
    sky = new Sky(time);
    mountains = new Mountains(height * 0.2, height * 0.8, time);
};

var redrawCanvas = function(regen) {
    canvas.width = container.offsetWidth;
    canvas.height = container.offsetHeight;
    if (regen) regenScene();
    var scale;
    if (canvas.width > (width/height)*canvas.height) {
        scale = canvas.width/width;
    } else {
        scale = canvas.height/height;
    }

    buffer_canvas.width = width*scale;
    buffer_canvas.height = height*scale;
    buffer.scale(scale, scale);
    drawScene(
        (canvas.width - buffer_canvas.width)/2,
        (canvas.height - buffer_canvas.height)/2
    );
};

var transition = function() {
    if (transitioning) return;
    overlay.classList.remove("transparent");
    transitioning = true;
    setTimeout(function() {
        redrawCanvas(true);
        overlay.classList.add("transparent");
        setTimeout(function() {
            transitioning = false;
        }, 700);
    }, 700);
};

if (canvas.getContext) {
    stage = canvas.getContext("2d");
    buffer_canvas = document.createElement("canvas");
    buffer = buffer_canvas.getContext("2d");
    if (CanvasRenderingContext2D.prototype.ellipse == undefined) {
        CanvasRenderingContext2D.prototype.ellipse = function(x, y, radiusX, radiusY, rotation, startAngle, endAngle, antiClockwise) {
            this.save();
            this.translate(x, y);
            this.rotate(rotation);
            this.scale(radiusX, radiusY);
            this.arc(0, 0, 1, startAngle, endAngle, antiClockwise);
            this.restore();
        };
    }
    window.addEventListener("resize", throttle(function() { redrawCanvas() }, 200));
    container.addEventListener("click", transition);
    redrawCanvas(true);
} else {
    console.log("canvas not supported");
    document.getElementById("header").classList.add("static");
}
