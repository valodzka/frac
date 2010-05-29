
(function(){
    var find_fracs = function(x, maxden) {
        var startx = x, ai;
        var m = [[1.0, 0.0],[0.0, 1.0]];

        if (maxden <= 0) 
            throw "Max denominator should be greater then 0";

        while (m[1][0] * (ai = parseInt(x)) + m[1][1] <= maxden) {
            var t = m[0][0] * ai + m[0][1];
            m[0][1] = m[0][0];
            m[0][0] = t;
            t = m[1][0] * ai + m[1][1];
            m[1][1] = m[1][0];
            m[1][0] = t;
            if (x == ai) break; /* AF: division by zero */
            x = 1/(x - ai);
            if (x > 0x7FFFFFFF) break /* AF: representation failure */
        }
        
        var num1 = m[0][0];
        var den1 = m[1][0];
        var err1 = startx - num1 / den1;
    
        ai = (maxden - m[1][1]) / m[1][0];
        m[0][0] = m[0][0] * ai + m[0][1];
        m[1][0] = m[1][0] * ai + m[1][1];
    
        var num2 = m[0][0];
        var den2 = m[1][0];
        var err2 = startx - num2 / den2;

        return [err1, [num1, den1], err2, [num2, den2]];
    };

    Math["frac"] = function(x, maxden) {
        var fracs = find_fracs(parseFloat(x), parseInt(maxden));
        return Math.abs(fracs[0]) < Math.abs(fracs[2]) ? fracs[1] : fracs[3];
    };
})();
