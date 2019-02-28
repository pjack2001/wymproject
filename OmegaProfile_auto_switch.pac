var FindProxyForURL = function(init, profiles) {
    return function(url, host) {
        "use strict";
        var result = init, scheme = url.substr(0, url.indexOf(":"));
        do {
            result = profiles[result];
            if (typeof result === "function") result = result(url, host, scheme);
        } while (typeof result !== "string" || result.charCodeAt(0) === 43);
        return result;
    };
}("+auto switch", {
    "+auto switch": function(url, host, scheme) {
        "use strict";
        if (/(?:^|\.)google\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)github\.com$/.test(host)) return "+proxy";
        if (/^github\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)docker\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)io$/.test(host)) return "+proxy";
        if (/(?:^|\.)ansible\.com$/.test(host)) return "+proxy";
        return "DIRECT";
    },
    "+proxy": function(url, host, scheme) {
        "use strict";
        if (/^127\.0\.0\.1$/.test(host) || /^::1$/.test(host) || /^localhost$/.test(host)) return "DIRECT";
        return "SOCKS5 127.0.0.1:2080; SOCKS 127.0.0.1:2080";
    }
});