export class BitBuffer {
    #bufferByteOffset
    #buffer
    #byteBuffer
    #bitsLeft

    constructor(buffer) {
        this.#buffer = buffer
        this.#bufferByteOffset = 0
        this.#byteBuffer = 0
        this.#bitsLeft = 0
    }

    get bitOffset() {
        return this.#bufferByteOffset * 8 - this.#bitsLeft
    }

    finishByte() {
        this.#bitsLeft = 0
    }

    nextByte() {
        if (this.#bufferByteOffset >= this.#buffer.size) {
            throw "tried to read too many bytes from BitBuffer!"
        }
        this.#byteBuffer = this.#buffer.readUInt8(this.#bufferByteOffset)
        this.#bufferByteOffset++
        this.#bitsLeft = 8
    }

    readBit() {
        if (this.#bitsLeft === 0) {
            this.nextByte()
        }
        this.#bitsLeft--
        return (this.#byteBuffer >> this.#bitsLeft) & 0b1
    }

    readFixedInt(width) {
        let value = 0n
        for (let i = 0; i < width; i++) {
            value <<= 1n
            if (this.readBit()) {
                value |= 1n
            }
        }
        return value
    }

    readVarInt() {
        let value = 0n
        let cnt = true
        while (cnt) {
            if (!this.readBit()) {
                cnt = false
            }
            let partial = this.readFixedInt(4)
            value <<= 4n
            value |= partial
        }
        return value
    }
}