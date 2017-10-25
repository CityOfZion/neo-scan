import HomeSocket from './home_socket'
import Inferno from 'inferno'
import List from 'inferno-virtual-list'

var moment = require('moment')

const blocksContainer = document.getElementById('blocks-wrapper')
const transactionsContainer = document.getElementById('transactions-wrapper')

const blockRow = row => (
  <div class='full-width-bar block-number'>
    <div class='information-wrapper'>
      <p class='fa fa-signal medium-detail-text'></p>
      <a href={'/block/' + row.hash} alt='View block' title='View block' class='large-blue-link col-4-width'>{row.index}</a>
      <p class='medium-detail-text col-3-width'>{row.size} bytes</p>
      <p class='medium-detail-text col-3-width'>{row.tx_count}</p>
      <p class='medium-detail-text col-2-width'>{ moment.unix(row.time).format('DD-MM-YYYY') + ' | ' + moment.unix(row.time).format('HH:mm:ss')}</p>
    </div>
  </div>
)

let getClass = function (type) {
  if (type === 'ContractTransaction') {
    return 'neo-transaction'
  }
  if (type === 'ClaimTransaction') {
    return 'gas-transaction'
  }
  if (type === 'MinerTransaction') {
    return 'miner-transaction'
  }
  if (type === 'RegisterTransaction') {
    return 'register-transaction'
  }
  if (type === 'IssueTransaction') {
    return 'issue-transaction'
  }
  if (type === 'PublishTransaction') {
    return 'publish-transaction'
  }
  if (type === 'InvocationTransaction') {
    return 'invocation-transaction'
  }
}

let getName = function (type) {
  if (type === 'ContractTransaction') {
    return 'Contract'
  }
  if (type === 'ClaimTransaction') {
    return 'GAS Claim'
  }
  if (type === 'MinerTransaction') {
    return 'Miner'
  }
  if (type === 'RegisterTransaction') {
    return 'Asset Register'
  }
  if (type === 'IssueTransaction') {
    return 'Asset Issue'
  }
  if (type === 'PublishTransaction') {
    return 'Contract Publish'
  }
  if (type === 'InvocationTransaction') {
    return 'Contract Invocation'
  }
}

const transactionRow = row => (
  <div class={'full-width-bar ' + getClass(row.type)}>
    <div class='information-wrapper'>
      <p class='medium-detail-text col-2-width'><span class='fa fa-cube'></span>{getName(row.type)}</p>
      <a href={'/transaction/' + row.txid} alt='View transaction' title='View transaction' class='large-blue-link col-5-width'>{row.txid}&#8230;</a>
      <p class='medium-detail-text col-2-width'>&nbsp;&nbsp;&nbsp;<a href={'/block/' + row.block_hash + '1'} alt='View block' title='View block' class='blue-link'>{row.block_height}</a></p>
      <p class='medium-detail-text col-2-width'>{ moment.unix(row.time).format('DD-MM-YYYY') + ' | ' + moment.unix(row.time).format('HH:mm:ss')}</p>
    </div>
  </div>
)

window.onload = function () {
  if (window.location.pathname === '/') {
    let payload = {
      blocks: [],
      transactions: [],
      stats: {},
      price: {}
    }
    let home = new HomeSocket(payload)

    setInterval(function () {
      Inferno.render((
        <List class='blocks-list' sync={false} data={home.payload.blocks} rowHeight={15} rowRender={blockRow} />
      ), blocksContainer)
      Inferno.render((
        <List class='transactions-list' sync={false} data={home.payload.transactions} rowHeight={15} rowRender={transactionRow} />
      ), transactionsContainer)
      document.getElementById('total-tx').innerHTML = home.payload.stats.total_transactions
      document.getElementById('total-blocks').innerHTML = home.payload.stats.total_blocks
      document.getElementById('total-addresses').innerHTML = home.payload.stats.total_addresses
      document.getElementById('neo-price-us').innerHTML = formatterTwo.format(home.payload.price.neo.usd.PRICE)
      document.getElementById('mkt-cap-us').innerHTML = formatterZero.format(home.payload.price.neo.usd.MKTCAP)
      document.getElementById('24hvol').innerHTML = formatterZero.format(home.payload.price.neo.usd.VOLUME24HOUR)

      document.getElementById('24hchange').innerHTML = home.payload.price.neo.usd.CHANGEPCT24HOUR.toFixed(2) +'%'

      if (home.payload.price.neo.usd.VOLUME24HOUR.toFixed(0) > 0) {
        document.getElementById('24hvol').setAttribute('class', 'large-number large-number-positive')
      } else {
        document.getElementById('24hvol').setAttribute('class', 'large-number large-number-negative')
      }

      if (home.payload.price.neo.usd.CHANGEPCT24HOUR.toFixed(2) > 0) {
        document.getElementById('24hchange').setAttribute('class', 'large-number large-number-positive')
      } else {
        document.getElementById('24hchange').setAttribute('class', 'large-number large-number-negative')
      }
    }, 500)
    home.connect()
  }
}

// Create our number formatter.
var formatterZero = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 0,
  maximumFractionDigits: 0
})

var formatterTwo = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 2
})

var acc = document.getElementsByClassName('btn-accordion')
var i

for (i = 0; i < acc.length; i++) {
  acc[i].onclick = function () {
    this.classList.toggle('active')
    var panel = this.nextElementSibling

    if (panel.style.maxHeight) {
      panel.style.maxHeight = null
    } else {
      panel.style.maxHeight = panel.scrollHeight + 'px'
    }
  }
}

var chart = c3.generate({
  data: {
    x: 'x',
    columns: [
      ['x', '02-11-17', '03-11-17', '04-11-17', '05-11-17', '06-11-17', '07-11-17', '08-11-17', '09-11-17', '10-11-17', '11-11-17', '12-11-17', '13-11-17', '14-11-17', '15-11-17', '16-11-17', '17-11-17', '18-11-17', '19-11-17', '20-11-17', '21-11-17', '22-11-17', '23-11-17', '24-11-17', '25-11-17', '26-11-17', '27-11-17'],
      ['NEO', 69, 72, 75, 84, 66, 90, 87, 86, 63, 68, 72, 75, 81, 90, 92, 99, 82, 93, 77, 71, 69, 82, 88, 94, 102]
    ]
  },
  axis: {
    x: {
      height: 75,
      type: 'timeseries',
      tick: {
        culling: false,
        count: 25,
        rotate: -65,
        format: '%y - %m - %d',
        fit: true
      }
    }
  },
  grid: {
    y: {
      show: true,
      tick: {
        format: d3.format('$,'),
        values: [110, 100, 90, 80, 70, 60]
      }
    }
  },
  tooltip: {
    contents: function (d, defaultTitleFormat, defaultValueFormat, color) {
      return ('<div class="chart-tooltip"><span class="tooltip-xlabel">Xlabel date content here</span><span class="tooltip-neolabel">0.0811</span><span class="tooltip-gaslabel">72.10</span></div>')
    }
  },
  zoom: {
    enabled: true
  },
  point: {
    r: 6,
    focus: {
      expand: {
        r: 8
      }
    }
  },
  color: {
    pattern: ['#BEEB00']
  },
  onrendered: function () {
    var $$ = this
    var circles = $$.getCircles()
    for (var i = 0; i < circles.length; i++) {
      for (var j = 0; j < circles[i].length; j++) {
        $$.getCircles(j).style('fill', '#313164')
            .style('fill', $$.color)
            .style('stroke-width', 2)
      }
    }
  }
})
