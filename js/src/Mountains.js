function Mountains(top, bottom, time) { //#D36F6F, #AD1515
    var ranges = [];
    var start, end;
    if (time < 0.5) {
        start = lerpColor("#D36F6F", "#F2C178", map(time, 0, 0.5, 0, 1));
        end = lerpColor("#AD1515", "#E85B57", map(time, 0, 0.5, 0, 1));
    } else {
        start = lerpColor("#654183", "#2D3A5F", map(time, 0.5, 1, 0, 1));
        end = lerpColor("#B198C6", "#6172A5", map(time, 0.5, 1, 0, 1));
    }

    var layers = int(random(2, 5));
    var heightUnit = (bottom - top) / (layers + 1);

    for (var l = 0; l < layers; l++) {
        var y = top + random(heightUnit * l, heightUnit * (l + 1));
        var spread = random(1, 3) * heightUnit;
        ranges.push(new MountainRange(
            y,
            spread,
            lerpColor(start, end, l/layers), (l + 1) / layers,
            time
        ));
    }

    this.draw = function() {
        ranges.forEach(function(range) {
            range.draw();
        });
    };
}

function MountainRange(y, spread, c, foreground, time) {
    var elevation = [];
    var trees = [];
    var buildings = [];

    var noiseElevation = random(1, 100);
    var spikiness = random(40, 90);

    for (var x = 0; x < 150; x++) {
        elevation.push(map(noise(x / spikiness, noiseElevation), 0, 1, -1, 1) * spread);
    }

    var numTrees = int(random(1, map(1.0 / foreground, 1, 100, 5, 40)));
    for (var i = 0; i < numTrees; i++) {
        var location = int(random(elevation.length));
        trees.push(new Tree(
            (location / (elevation.length - 1)) * width,
            y + elevation[location],
            foreground * 100,
            foreground * 80,
            time
        ));
    }

    var numBuildings = int(random(1, map(1.0 / foreground, 1, 100, 0, 10)));
    for (var i = 0; i < numTrees; i++) {
        var location = int(random(elevation.length));
        buildings.push(new Building(
            (location / (elevation.length - 1)) * width,
            y + elevation[location] + spread * 0.1,
            foreground * 80,
            foreground * 120,
            time
        ));
    }

    this.draw = function() {
        buildings.forEach(function(building) {
            building.draw();
        });

        fill(c);
        beginShape();
        for (var i = 0; i < elevation.length; i++) {
            vertex((i / (elevation.length - 1)) * width, y + elevation[i]);
        }
        vertex(width, height);
        vertex(0, height);
        endShape();

        trees.forEach(function(tree) {
            tree.draw();
        });
    };
}
