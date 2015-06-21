function BuildingUnit(x, y, w, h, side, level, time) {
    var WINDOW_LIGHT = "#FFE76F";
    var WINDOW_DARK = "#1B5E81";
    var LIGHTS_ON = 0.6;
    var windows = 0;
    var windowHeight = 0;
    var alignment = 0;
    var units = [];
    var lights = [];
    var offsetLeft = random(-0.1 * w, 0.1 * w);
    var offsetRight = random(-0.1 * w, 0.1 * w);
    var offsetRoof = random(0.1 * w, 0.3 * w);
    var stiltLength = 0;
    if (level > 1) {
        stiltLength = random(h * 0.2, h * 0.5);
    }
    if (level <= 2) {
        windows = int(random(0, 5 - level));
        if (time > LIGHTS_ON) {
            for (var i=0; i<windows; i++) {
                lights.push(random(1) > 0.5);
            }
        }
        windowHeight = random((h - stiltLength) * 0.1, (h - stiltLength) * 0.5);
        if (random(0, 1) > 0.5) {
            alignment = BUILDING_LEFT;
        } else {
            alignment = BUILDING_RIGHT;
        }
        for (var i = 0; i < BUILDING_MAX_LEVELS; i++) {
            if (random(10) >= 5) {
                var branchWidth = random(0.2 * w, 0.8 * w);
                var branchHeight = random(0.2 * h, 0.8 * h);
                var branchX = 0;
                var branchY = 0;

                var branchSide = int(random(-2, 2));
                if (branchSide == BUILDING_TOP) {
                    branchX = random(x - w / 2 + branchWidth / 2, x + w / 2 - branchWidth / 2);
                    branchY = y - h;
                } else if (branchSide == BUILDING_LEFT) {
                    branchX = x - w / 2 - branchWidth / 2 + w * 0.2;
                    branchY = random(y - 0.2 * (h - stiltLength) - stiltLength, y - 0.8 * (h - stiltLength) - stiltLength);
                } else if (branchSide == BUILDING_RIGHT) {
                    branchX = x + w / 2 + branchWidth / 2 - w * 0.2;
                    branchY = random(y - 0.2 * (h - stiltLength) - stiltLength, y - 0.8 * (h - stiltLength) - stiltLength);
                }

                units.push(new BuildingUnit(branchX, branchY, branchWidth, branchHeight, branchSide, level + 1, time));
            }
        }
    }

    this.draw = function() {
        units.forEach(function(b) {
            b.draw();
        });

        var stiltColor, roofColor, houseColor, windowDark;
        if (time < 0.5) {
            stiltColor = lerpColor("#776F7E", "#4B433C", map(time, 0, 0.5, 0, 1));
            houseColor = lerpColor("#AD9592", "#BFABA9", map(time, 0, 0.5, 0, 1));
            roofColor = lerpColor("#776F7E", "#4B433C", map(time, 0, 0.5, 0, 1));
            windowDark = lerpColor("#1B5E81", "#383E5A", map(time, 0, 0.5, 0, 1));
        } else {
            stiltColor = lerpColor("#352B48", "#1D263E", map(time, 0.5, 1, 0, 1));
            houseColor = lerpColor("#C3B7D1", "#8788A7", map(time, 0, 0.5, 0, 1));
            roofColor = lerpColor("#776F7E", "#4B433C", map(time, 0, 0.5, 0, 1));
            windowDark = lerpColor("#644C6F", "#3D435F", map(time, 0, 0.5, 0, 1));
        }

        if (stiltLength > 0) {
            strokeWeight(w / 20);
            stroke(stiltColor);
            if (side == BUILDING_TOP) {
                line(x - w * 0.3, y, x - w * 0.3, y - stiltLength);
                line(x + w * 0.3, y, x + w * 0.3, y - stiltLength);
            } else if (side == BUILDING_LEFT) {
                line(x - w * 0.4, y - stiltLength, x + w / 2, y);
            } else if (side == BUILDING_RIGHT) {
                line(x + w * 0.4, y - stiltLength, x - w / 2, y);
            }
        }

        //Main building
        fill(level % 2 == 1 ? houseColor : lerpColor(houseColor, "#1C1443", 0.2));
        beginShape();
        vertex(x - w / 2, y - stiltLength);
        vertex(x + w / 2, y - stiltLength);
        vertex(x + w / 2 + offsetRight, y - h * 0.85);
        vertex(x - w / 2 + offsetLeft, y - h * 0.85);
        endShape();

        //Windows
        for (var i = 0; i < windows; i++) {
            if (time > LIGHTS_ON && lights[i]) {
                fill(WINDOW_LIGHT);
            } else {
                fill(windowDark);
            }
            if (alignment == BUILDING_LEFT) {
                rect(
                    x + offsetLeft - w / 2 + w * 0.05 + w * 0.25 * i,
                    y - h * 0.8,
                    w * 0.2,
                    windowHeight
                );
            } else if (alignment == BUILDING_RIGHT) {
                rect(
                    x + offsetRight + w / 2 - w * 0.05 - w * 0.25 * (i + 1),
                    y - h * 0.8,
                    w * 0.2,
                    windowHeight
                );
            }
        }

        //Roof
        fill("#685D71");
        beginShape();
        vertex(x - w / 2 + offsetLeft - offsetRoof, y - h * 0.85);
        vertex(x + w / 2 + offsetRight + offsetRoof, y - h * 0.85);
        vertex(x + w / 2 + offsetRight, y - h);
        vertex(x - w / 2 + offsetLeft, y - h);
        endShape();
    };
}

function Building(x, y, w, h, time) {
    var units = [];
    var numUnits = int(random(1, 2));
    for (var i = 0; i < numUnits; i++) {
        var unitWidth = random(0.5, 1.5) * (w / numUnits);
        units.push(new BuildingUnit(
            x - w / 2 + i * (w / numUnits) + unitWidth / 2,
            y,
            unitWidth,
            random(h * 0.2, h),
            BUILDING_TOP,
            1,
            time
        ));
    }

    this.draw = function() {
        units.forEach(function(b) {
            b.draw();
        });
    };
}
