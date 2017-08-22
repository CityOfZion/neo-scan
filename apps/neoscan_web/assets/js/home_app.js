import HomeSocket from "./home_socket"
import Inferno from 'inferno';
import List from 'inferno-virtual-list';

var moment = require('moment');

const blocksContainer = document.getElementById("show-blocks")
const transactionsContainer = document.getElementById('show-transactions')

const blockRow = row => (
  <a href={'/block/' + row.hash} class='box'>
    <article class='media'>
      <div class='media-content'>
        <div class='content'>
          <p>
            <strong>Height {row.index}&nbsp;&nbsp;&nbsp;</strong>
            <small>Date&nbsp;&nbsp;{moment.unix(row.time).format('DD-MM-YYYY')}&nbsp;&nbsp;
            </small>
            <small>Time&nbsp;&nbsp;{moment.unix(row.time).format('HH:mm:ss')}&nbsp;&nbsp;
            </small>
            <small class='is-pulled-right'>Number of Transactions {row.tx_count}
            </small>
          </p>
        </div>
      </div>
    </article>
  </a>
)

const transactionRow = row => (
  <a href={'/transaction/' + row.txid} class='box'>
    <article class='media'>
      <div class='media-content'>
        <div class='content'>
          <p>
            <strong>{row.type}&nbsp;&nbsp;&nbsp;</strong>
            <small>Date&nbsp;&nbsp;{moment.unix(row.time).format('DD-MM-YYYY')}&nbsp;&nbsp;
            </small>
            <small>Time&nbsp;&nbsp;{moment.unix(row.time).format('HH:mm:ss')}&nbsp;&nbsp;
            </small>
          </p>
        </div>
      </div>
    </article>
  </a>
)

window.onload = function () {
  let payload = {
    blocks: [],
    transactions: []
  }
  let home = new HomeSocket(payload)

  setInterval(function () {
    Inferno.render((
      <List class='collection' sync={false} data={home.payload.blocks} rowHeight={15} rowRender={blockRow} />
    ), blocksContainer)

    Inferno.render((
      <List class='collection' sync={false} data={home.payload.transactions} rowHeight={15} rowRender={transactionRow} />
    ), transactionsContainer)
  }, 500)

  home.connect()
}
