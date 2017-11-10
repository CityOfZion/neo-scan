import HomeSocket from './home_socket'
import Inferno from 'inferno'
import List from 'inferno-virtual-list'
import { createHomeChart, createAddressChart } from './create_charts'
import { getClass, getName, getIcon } from './helpers'

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
        document.getElementById('total-tx').innerHTML = home.payload.stats.total_transactions.toLocaleString()
        document.getElementById('total-blocks').innerHTML = home.payload.stats.total_blocks.toLocaleString()
        document.getElementById('total-addresses').innerHTML = home.payload.stats.total_addresses.toLocaleString()
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

    const priceDropdown = document.getElementById('price-chart')
    const comparisonDropdown = document.getElementById('comparison-chart')
    const zoomInChart = document.getElementById('zoom-in-chart')
    const zoomOutChart = document.getElementById('zoom-out-chart')

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

    priceDropdown.onchange = function () {
      coinClickHandler(this.value)
    }
    comparisonDropdown.onchange = function () {
      compareClickHandler(this.value)
    }
    zoomInChart.onclick = () => zoomHandler('in')
    zoomOutChart.onclick = () => zoomHandler('out')
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

    const address_hash = document.getElementById('address_hash').innerHTML
    fetch(`/api/main_net/v1/get_unclaimed/${address_hash}`).then(res => res.json()).then(results => {
      document.getElementsByClassName('loading-gas')[0].innerHTML = ''
      document.getElementsByClassName('unclaimed-gas')[0].innerHTML = `${results.unclaimed} Unclaimed Gas`
    })
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
  $('#language-dropdown').simpleselect()
  $('#price-chart').simpleselect()
  $('#comparison-chart').simpleselect()

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

  let hover = false
  $tooltipElement.click(function () {
    if(!hover) {
      $('.tooltip').each(function() {
        $(this).addClass('add-hover')
      })
      $(this).text('Tooltips On')
      hover = true
    } else {
      $('.tooltip').each(function() {
        $(this).removeClass('add-hover')
      })
      $(this).text('Tooltips Off')
      hover = false
    }
  })
})
