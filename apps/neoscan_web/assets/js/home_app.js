import HomeSocket from './home_socket'
import Inferno from 'inferno'
import List from 'inferno-virtual-list'

const moment = require('moment')

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

    const formatChart = (time) => {
      let count = 32, format = '%m-%d-%y';
      if (time === '1d') {
        count = 24
        format = '%H:%M'
      }
      if (time === '1w') {
        count = 7
        format = '%m-%d'
      }
      if (time === '3m') {
        count = 36
        format = '%m-%d'
      }
      return [count, format]
    }

    const createChart = (coin, compareCurrency, time) => {
      fetch(`/price/${coin}/${compareCurrency}/${time}`).then(res => res.json()).then(results => {
        const dates = ['date']
        const prices = [coin.toUpperCase()]
        for (const [unixTimestamp, price] of Object.entries(results)) {
          const formattedDate = moment.unix(unixTimestamp).format('YYYY-MM-DD HH:mm')
          if (dates[dates.length-1] !== formattedDate) dates.push(formattedDate)
          prices.push(price)
        }

        const [count, format] = formatChart(time)
        const chart = c3.generate({
          bindto: '#market-chart',
          data: {
            x: 'date',
            columns: [
              dates,
              prices
            ],
            xFormat: '%Y-%m-%d %H:%M'
          },
          axis: {
            x: {
              height: 75,
              type: 'timeseries',
              tick: {
                culling: false,
                count,
                rotate: -65,
                format,
                fit: true
              }
            },
            y: {
              tick: {
                format: function (d) {
                  if (compareCurrency === 'usd') return '$' + d.toFixed(2)
                  if (time === '3m') return d.toFixed(3)
                  if (time === '1m') return d.toFixed(4)
                  if (time === '1w') return d.toFixed(5)
                  return d.toFixed(8)
                }
              }
            }
          },
          grid: {
            y: {
              show: true,
            }
          },
          tooltip: {
            contents: function (d) {
              const price = compareCurrency === 'usd' ? d[0] && Number(d[0].value).toFixed(2) : d[0] && Number(d[0].value).toFixed(8)
              const name = d[0] && d[0].name
              const time = d[0] && `${d[0].x}`.slice(0, 24)
              return (`<div class="chart-tooltip"><span class="tooltip-xlabel">Price of ${name} (${compareCurrency})</span><span class="tooltip-xlabel">Time:  ${time}</span><span class="tooltip-${compareCurrency}label">${price}</span></div>`)
            }
          },
          point: {
            show: false
          },
          zoom: {
            enabled: false,
          },
          color: {
            pattern: ['#BEEB00']
          }
        })
      })
    }

    let displayCoin = 'neo'
    let displayChart = 'usd'
    let displayTime = '1m'

    createChart(displayCoin, displayChart, displayTime)

    const zoomInChart = document.getElementById('zoom-in-chart')
    const zoomOutChart = document.getElementById('zoom-out-chart')
    const btcChart = document.getElementById('show-btc-chart')
    const usdChart = document.getElementById('show-usd-chart')
    const gasChart = document.getElementById('show-gas-chart')
    const neoChart = document.getElementById('show-neo-chart')

    const coinClickHandler = (coin) => {
      displayCoin = coin
      return createChart(coin, displayChart, displayTime)
    }

    const compareClickHandler = (compare) => {
      displayChart = compare
      return createChart(displayCoin, compare, displayTime)
    }

    const zoomHandler = (zoom) => {
      if (displayTime === '1d') {
        if (zoom === 'in') return
        displayTime = '1w'
      } else if (displayTime === '1w') {
        displayTime = zoom === 'out' ? '1m' : '1d'
      } else if (displayTime === '1m') {
        displayTime = zoom === 'out' ? '3m' : '1w'
      } else if (displayTime === '3m') {
        if (zoom === 'out') return
        displayTime = '1m'
      }
      return createChart(displayCoin, displayChart, displayTime)
    }

    zoomInChart.onclick = () => zoomHandler('in')
    zoomOutChart.onclick = () => zoomHandler('out')
    btcChart.onclick = () => compareClickHandler('btc')
    usdChart.onclick = () => compareClickHandler('usd')
    gasChart.onclick = () => coinClickHandler('gas')
    neoChart.onclick = () => coinClickHandler('neo')
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
