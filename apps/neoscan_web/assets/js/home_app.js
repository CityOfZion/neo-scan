import HomeSocket from './home_socket'
import Inferno from 'inferno'
import List from 'inferno-virtual-list'
import { createHomeChart, createAddressChart } from './create_charts'

const moment = require('moment')

const blocksContainer = document.getElementById('blocks-wrapper')
const transactionsContainer = document.getElementById('transactions-wrapper')

const blockRow = row => (
  <div class='full-width-bar block-number'>
    <div class='information-wrapper'>
      <p class='fa fa-signal medium-detail-text'></p>
      <a href={'/block/' + row.hash} alt='View block' title='View block' class='large-blue-link col-4-width'>{row.index}</a>
      <div class='secondary-info-wrapper'>
        <p class='medium-detail-text col-3-width'><span class='tablet-detail-text'>Size: </span>{row.size} bytes</p>
        <p class='medium-detail-text col-3-width'><span class='tablet-detail-text'>Transactions: </span>{row.tx_count}</p>
        <p class='medium-detail-text col-2-width'><span class='tablet-detail-text'>Created: </span>{ moment.unix(row.time).format('DD-MM-YYYY') + ' | ' + moment.unix(row.time).format('HH:mm:ss')}</p>
      </div>
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

let getIcon = function (type) {
  if (type === 'ContractTransaction') {
    return 'fa-cube'
  }
  if (type === 'ClaimTransaction') {
    return 'fa-cubes'
  }
  if (type === 'MinerTransaction') {
    return 'fa-user-circle-o'
  }
  if (type === 'RegisterTransaction') {
    return 'fa-list-alt'
  }
  if (type === 'IssueTransaction') {
    return 'fa-handshake-o'
  }
  if (type === 'PublishTransaction') {
    return 'fa-cube'
  }
  if (type === 'InvocationTransaction') {
    return 'fa-paper-plane'
  }
}

const transactionRow = row => (
  <div class={'full-width-bar ' + getClass(row.type)}>
    <div class='information-wrapper'>
      <p class='medium-detail-text col-2-width'><span class={'fa ' + getIcon(row.type)}></span>{getName(row.type)}</p>
      <div class='secondary-info-wrapper'>
        <p class='medium-detail-text col-2-width'><span class='tablet-detail-text'>Txid: </span><a href={'/transaction/' + row.txid} alt='View transaction' title='View transaction' class='large-blue-link col-6-width'>{row.txid}</a></p>
        <p class='medium-detail-text col-2-width remove-550px'><span class='tablet-detail-text'>Created: </span>{ moment.unix(row.time).format('DD-MM-YYYY') + ' | ' + moment.unix(row.time).format('HH:mm:ss')}</p>
      </div>
    </div>
  </div>
)

window.onload = function () {
  // homepage javascript
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
      if (home.payload.price.neo) {
        document.getElementById('total-tx').innerHTML = home.payload.stats.total_transactions
        document.getElementById('total-blocks').innerHTML = home.payload.stats.total_blocks
        document.getElementById('total-addresses').innerHTML = home.payload.stats.total_addresses
        document.getElementById('neo-price-us').innerHTML = formatterTwo.format(home.payload.price.neo.usd.PRICE)
        document.getElementById('mkt-cap-us').innerHTML = formatterZero.format(home.payload.price.neo.usd.MKTCAP)
        document.getElementById('24hvol').innerHTML = formatterZero.format(home.payload.price.neo.usd.VOLUME24HOUR)

        document.getElementById('24hchange').innerHTML = home.payload.price.neo.usd.CHANGEPCT24HOUR.toFixed(2) +'%'

        if (home.payload.price.neo.usd.VOLUME24HOUR.toFixed(0) > 0) {
          document.getElementById('24hvol').setAttribute('class', 'large-stat-number remove-margin-bottom')
        } else {
          document.getElementById('24hvol').setAttribute('class', 'large-stat-number remove-margin-bottom')
        }

        if (home.payload.price.neo.usd.CHANGEPCT24HOUR.toFixed(2) > 0) {
          document.getElementById('24hchange').setAttribute('class', 'large-stat-number large-number-positive remove-margin-bottom')
        } else {
          document.getElementById('24hchange').setAttribute('class', 'large-stat-number large-number-negative remove-margin-bottom')
        }
      }
    }, 500)
    home.connect()

    let displayCoin = 'neo'
    let displayChart = 'usd'
    let displayTime = '1m'

    createHomeChart(displayCoin, displayChart, displayTime)

    const zoomInChart = document.getElementById('zoom-in-chart')
    const zoomOutChart = document.getElementById('zoom-out-chart')
    const btcChart = document.getElementById('show-btc-chart')
    const usdChart = document.getElementById('show-usd-chart')
    const gasChart = document.getElementById('show-gas-chart')
    const neoChart = document.getElementById('show-neo-chart')

    const coinClickHandler = (coin) => {
      displayCoin = coin
      return createHomeChart(coin, displayChart, displayTime)
    }

    const compareClickHandler = (compare) => {
      displayChart = compare
      return createHomeChart(displayCoin, compare, displayTime)
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
      return createHomeChart(displayCoin, displayChart, displayTime)
    }

    zoomInChart.onclick = () => zoomHandler('in')
    zoomOutChart.onclick = () => zoomHandler('out')
    btcChart.onclick = () => compareClickHandler('btc')
    usdChart.onclick = () => compareClickHandler('usd')
    gasChart.onclick = () => coinClickHandler('gas')
    neoChart.onclick = () => coinClickHandler('neo')
  }

  // address page javascript
  if (window.location.pathname.startsWith('/address/')) {
    const graph_elem = document.getElementById('graph_data')
    const graph_data = JSON.parse(graph_elem.dataset.graphData)
    const count = graph_data.length
    const assetsList = {}
    const dates = ['date']
    graph_data.forEach(({time, assets}) => {
      const date = new Date(time*1000)
      const formattedDate = moment(date).format('YYYY-MM-DD HH:MM:SS')
      if (formattedDate === dates[dates.length-1]) return
      dates.push(formattedDate)

      return assets.forEach((asset) => {
        const assetName = Object.keys(asset)
        if (!assetsList[assetName]) {
          return assetsList[assetName] = [assetName, asset[assetName]]
        } else {
          return assetsList[assetName].push(asset[assetName])
        }
      })
    })

    const transactionsTextElem = document.getElementById('last-x-transactions')
    let transactionText = `Last ${count} Transactions for `

    const assetDropdown = document.getElementById('select-address-chart')
    const assetNames = Object.keys(assetsList)
    assetNames.forEach((name, idx) => {
      const option = document.createElement("option");
      option.text = name;
      option.value = name;
      assetDropdown.add(option);
      if (!assetNames[idx+1] && !assetNames[idx-1] ) {
        transactionText += `${name}`
      } else if (assetNames[idx+1]) {
        transactionText += `${name}, `
      } else {
        transactionText = transactionText.slice(0,-2)
        transactionText += ` and ${name}`
      }

    })

    transactionsTextElem.innerHTML = transactionText

    if (assetsList['NEO']) {
      createAddressChart('NEO', dates, assetsList['NEO'], count)
    } else if (assetsList['GAS']) {
      createAddressChart('GAS', dates, assetsList['GAS'], count)
    } else if (assetNames.length > 0) {
      createAddressChart(assetNames[0], dates, assetsList[assetNames[0]], count)
    }

    assetDropdown.onchange = function () {
      createAddressChart(this.value, dates, assetsList[this.value], count)
    }
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

$('document').ready(function () {
  const $hamburger = $('.hamburger')
  $hamburger.on('click', function (e) {
    $hamburger.toggleClass('is-active')

    if ($hamburger.hasClass('is-active')) {
      $('.nav-wrapper').addClass('active-wrapper')
    } else {
      $('.nav-wrapper').removeClass('active-wrapper')
    }

    if (window.matchMedia('(max-width: 660px)').matches && ($hamburger.hasClass('is-active'))) {
      $('.searchbar').addClass('mobile-active')
      $('.search-btn').addClass('mobile-active')
    } else {
      $('.searchbar').removeClass('mobile-active')
      $('.search-btn').removeClass('mobile-active')
    }
  })

  const $tooltipElement = $('#coz-tooltip')
  console.log($tooltipElement);

  let hover = false
  $tooltipElement.click(function () {
    if(!hover) {
      $('.tooltip').each(function() {
        console.log($(this));
        $(this).addClass('add-hover')
      })
      $(this).css('background-color', '#2CE3B5')
      $(this).text('Tooltips On')
      hover = true
    } else {
      $('.tooltip').each(function() {
        $(this).removeClass('add-hover')
      })
      $(this).css('background-color', '#FF9596')
      $(this).text('Tooltips Off')
      hover = false
    }
  })
})
