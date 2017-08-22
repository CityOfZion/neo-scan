import HomeSocket from "./home_socket"
import { h, render, Component } from 'preact'

const blocksContainer = document.getElementById("show-blocks")
// const transactionsContainer = document.getElementById('show-transactions')

class blockList extends Component {
  render (props, state) {
    // props === this.props
    // state === this.state
    return "<h1>Hello, {props}!</h1>"
  }
}
// data binding

window.onload = function () {
  let payload = {
    blocks: [],
    transactions: []
  }
  let home = new HomeSocket(payload)
  blockList.props = home.payload.blocks
  render(blockList, blocksContainer) // call data binding
  // let app2 = view_transactions(home) // call data binding

  home.connect()
}
