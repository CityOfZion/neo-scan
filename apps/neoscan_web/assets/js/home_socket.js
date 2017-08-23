import {Socket} from 'phoenix'

export default class HomeSocket {
  constructor (payload) {
    this.payload = payload
    this.socket = new Socket('/socket', { })
    this.socket.connect()
  }

  connect () {
    this.setupChannel()
    this.channel
      .join()
      .receive('ok', resp => {
        this.copyPayload(resp)
      })
      .receive('error', resp => {
        alert('Unable to join', resp)
        throw (resp)
      })
  }

  setupChannel () {
    this.channel = this.socket.channel('room:home', {})
    this.channel.on('change', (payload) => {
      this.copyPayload(payload)
    })
  }
  copyPayload (from) {
    for (let k in from.blocks) {
      this.payload.blocks[k] = from.blocks[k]
    }
    for (let k in from.transactions) {
      this.payload.transactions[k] = from.transactions[k]
    }
  }
}
