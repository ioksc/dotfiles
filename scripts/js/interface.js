const os = require("os");
const interfaces = os.networkInterfaces();
Object.keys(interfaces).forEach((name) => {
  interfaces[name].forEach((address) => {
    if (address.family === "IPv4" && !address.internal) {
      console.log("%s : %s", name, address.address);
    }
  });
});
