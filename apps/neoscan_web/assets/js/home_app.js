import HomeSocket from "./home_socket"
import Inferno from 'inferno';
import List from 'inferno-virtual-list';

const blocksContainer = document.getElementById("show-blocks")
// const transactionsContainer = document.getElementById('show-transactions')

const Row = row => (
  <a href="/block/{row.hash}" class="box">
    <article class="media">
      <div class="media-content">
        <div class="content ">
          <p>
            <strong>Height {row.index}</strong>
            <small>Date
            &nbsp&nbsp&nbsp
            </small>
            <small>Time

            &nbsp&nbsp&nbsp
            </small>
            <small class="is-pulled-right">Number of Transactions {row.tx_count}
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

  setInterval(function(){
    Inferno.render((
      <List class="collection" sync={false} data={home.payload.blocks} rowHeight={15} rowRender={Row} />
    ), blocksContainer)
  }, 500);

  home.connect()
}
