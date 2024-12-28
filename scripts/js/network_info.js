#!/usr/bin/env node

import { networkInterfaces } from "os";

const getNetworkInfo = () => {
  const interfaces = networkInterfaces();
  const vpnInterfaces = ["tun0", "vpn0", "wg0"];

  for (const vpnName of vpnInterfaces) {
    const vpnAddress = interfaces[vpnName]?.find(
      (addr) => addr.family === "IPv4" && !addr.internal,
    );
    if (vpnAddress) {
      console.log(`VPN: ${vpnAddress.address}`);
      return;
    }
  }

  const allInterfaces = Object.entries(interfaces).flatMap(([name, addrs]) =>
    addrs
      .filter((addr) => addr.family === "IPv4" && !addr.internal)
      .map((addr) => `${name}: ${addr.address}`),
  );

  console.log(allInterfaces.length ? allInterfaces.join("\n") : "No IP");
};

getNetworkInfo();
