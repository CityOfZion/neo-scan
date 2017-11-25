import { Socket } from 'phoenix'

export default class HomeSocket {
  constructor (payload) {
    this.payload = payload
    this.socket = new Socket('/socket', { })
    this.socket.connect()
    this.socket.onError(() => console.log('there was an error with the connection!'))
    this.socket.onClose(() => console.log('the connection dropped'))
  }

  connect () {
    this.setupChannel()
    this.channel
      .join()
      .receive('ok', resp => this.copyPayload(resp))
      .receive('error', resp => {
        alert('Unable to join', resp)
        throw (resp)
      })
      .receive('timeout', () => console.log('Networking issue. Still waiting...'))
  }

  setupChannel () {
    this.channel = this.socket.channel('room:home', {})
    this.channel.onError(() => console.log('there was a channel error!'))
    this.channel.onClose(() => console.log('the channel has gone away gracefully'))
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
    this.payload.price = from.price
    this.payload.stats = from.stats
  }
}
