export class Packet {
    #version
    #type

    static from(buffer) {
        const version = buffer.readFixedInt(3);
        const type = buffer.readFixedInt(3);
        let packet;
        switch (type) {
            case 4: {
                packet = new LiteralPacket()
                break
            }
            default: {
                packet = new OperatorPacket()
            }
        }
        packet.#version = version
        packet.#type = type
        packet.read(buffer)

        return packet
    }

    get version() {
        return this.#version
    }

    get type() {
        return this.#type
    }

    forEach(consumer) {
        consumer(this)
    }
}

export class LiteralPacket extends Packet {
    #literal

    read(buffer) {
        this.#literal = buffer.readVarInt()
    }

    get literal() {
        return this.#literal
    }

    toString() {
        return "literal{ " + this.#literal + " }"
    }
}

export class OperatorPacket extends Packet {
    #subPackets

    read(buffer) {
        this.#subPackets = []
        if (buffer.readBit()) {
            const packetCount = buffer.readFixedInt(11)
            for (let i = 0; i < packetCount; i++) {
                this.#subPackets.push(Packet.from(buffer))
            }
        } else {
            const totalBits = buffer.readFixedInt(15)
            const beginOffset = buffer.bitOffset
            while (buffer.bitOffset - beginOffset < totalBits) {
                this.#subPackets.push(Packet.from(buffer))
            }
        }
    }

    forEach(consumer) {
        super.forEach(consumer)
        this.#subPackets.forEach(p => p.forEach(consumer))
    }

    toString() {
        return "operator[" + this.type + "]{ " + this.#subPackets.map(p => p.toString()).join(", ") + " }";
    }
}