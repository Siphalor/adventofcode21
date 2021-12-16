#! /usr/bin/env node

import fs from "fs"
import {BitBuffer} from "./bit-buffer.js"
import {Packet} from "./packet.js"

if (process.argv.length !== 4) {
	console.error("Incorrect number of arguments")
	process.exit(1)
}

try {
	const buffer = Buffer.from(fs.readFileSync(process.argv[3], "utf-8"), "hex")
	const bitBuffer = new BitBuffer(buffer)
	const packet = Packet.from(bitBuffer)

	switch (process.argv[2]) {
		case "part01": {
			let value = 0;
			packet.forEach(packet => value += packet.version)
			console.log(value)
			break
		}
		case "part02": {
			break
		}
		default: {
			console.error("unknown subcommand")
		}
	}
} catch (err) {
	console.error(err)
}
