function Tree(x, y, w, h, time) {
    var root = new Branch(x, y, w, h, BRANCH_ROOT, 1, time);
    this.draw = function() {
        root.drawLeaves();
        root.drawBranches();
    };
}

function Branch(x, y, w, h, side, level, time) {
    var branches = [];
    var segmentX = 0;
    var segmentY = 0;
    var leafWidth = 0;
    var leafHeight = 0;

    if (side == BRANCH_ROOT) {
        segmentX = x + (random(w * 0.6) - w * 0.3);
        segmentY = y - h * 0.75 + (random(h * 0.3) - h * 0.15);
    } else if (side == BRANCH_LEFT) {
        segmentX = x - random(w * 0.3);
        segmentY = y - h * 0.75 + (random(h * 0.3) - h * 0.15);
    } else if (side == BRANCH_RIGHT) {
        segmentX = x + random(w * 0.3);
        segmentY = y - h * 0.75 + (random(h * 0.3) - h * 0.15);
    }

    leafWidth = random(w * 0.6) + w * 0.3;
    leafHeight = random(h * 0.6) + h * 0.3;

    if (level < 3) {
        for (var i = 0; i < BRANCH_MAX_LEVELS; i++) {
            if (random(10) >= 7) {
                var branchY = random(segmentY, y);
                var branchX = x + ((segmentX - x) / (segmentY - y)) * (branchY - y);
                var branchDir = random(10) > 5 ? BRANCH_LEFT : BRANCH_RIGHT;
                branches.push(new Branch(branchX, branchY, w * 0.6, h * 0.5, branchDir, level + 1, time));
            }
        }
    }

    this.drawLeaves = function() {
        var leafColor;
        if (time < 0.5) {
            leafColor = lerpColor("#FFD1D1", "#F2C975", map(time, 0, 0.5, 0, 1));
        } else {
            leafColor = lerpColor("#D5BCE0", "#56627C", map(time, 0.5, 1, 0, 1));
        }
        fill(leafColor);
        ellipse(segmentX, segmentY, leafWidth, leafHeight);

        branches.forEach(function(b) {
            b.drawLeaves();
        });
    };

    this.drawBranches = function() {
        var branchColor;
        if (time < 0.5) {
            branchColor = lerpColor("#79504E", "#866A59", map(time, 0, 0.5, 0, 1));
        } else {
            branchColor = lerpColor("#635774", "#635774", map(time, 0.5, 1, 0, 1));
        }

        strokeWeight((y - segmentY) / 20);
        stroke(branchColor);
        line(x, y, segmentX, segmentY);

        branches.forEach(function(b) {
            b.drawBranches();
        });
    };
}
