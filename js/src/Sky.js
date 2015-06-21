function Sky(time) {
    var sky, horizon;
    if (time < 0.5) {
        sky = lerpColor("#B9F7D5", "#57C8F0", map(time, 0, 0.5, 0, 1));
        horizon = lerpColor("#FCED42", "#E365ED", map(time, 0, 0.5, 0, 1));
    } else {
        sky = lerpColor("#C282E5", "#1A285A", map(time, 0.5, 1, 0, 1));
        horizon = lerpColor("#82E3E5", "#BFE1FC", map(time, 0.5, 1, 0, 1));
    }

    this.draw = function() {
        setGradient(0, 0, width, height, sky, horizon);
    };
}
