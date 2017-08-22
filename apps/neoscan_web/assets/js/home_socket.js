import {Socket} from "phoenix"

export default class HomeSocket {
    constructor(payload) {
        this.payload  = payload
        this.socket = new Socket("/socket", { })
        this.socket.connect()
    }

    connect() {
        this.setup_channel();
        this.channel
            .join()
            .receive("ok", resp => {
                console.log("Joined successfully", resp)
                this.copy_payload(resp)
            })
            .receive("error", resp => {
                alert("Unable to join", resp)
                throw(resp)
            })
    }

    setup_channel() {
        this.channel = this.socket.channel("room:home", {})
        this.channel.on("change", (payload) => {
            this.copy_payload(payload)
        })
    }
    copy_payload(from) {
        for (let k in from.blocks) {
            this.payload.blocks[k] = from.blocks[k]
        }
        for (let k in from.transactions) {
            this.payload.transactions[k] = from.transactions[k]
        }
    }
}
