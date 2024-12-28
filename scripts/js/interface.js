import { networkInterfaces } from "os";

const interfaces = networkInterfaces();

console.log(addr);

Object.keys(interfaces).forEach((name) => {
  interfaces[name].forEach((address) => {
    if (address.family === "IPv4" && !address.internal) {
      console.log("%s : %s", name, address.address);
    }
  });
});
